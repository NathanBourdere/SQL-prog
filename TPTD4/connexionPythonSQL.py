import sqlalchemy  
# pour avoir sqlalchemy :
# sudo apt-get update 
# sudo apt-get install python3-sqlalchemy
# pip3 install mysql-connector-python
from Article import Article
from Entrepot import *
from Stocker import *
import getpass  # pour faire la lecture cachée d'un mot de passe

def ouvrir_connexion(user,passwd,host,database):
    """
    ouverture d'une connexion MySQL
    paramètres:
       user     (str) le login MySQL de l'utilsateur
       passwd   (str) le mot de passe MySQL de l'utilisateur
       host     (str) le nom ou l'adresse IP de la machine hébergeant le serveur MySQL
       database (str) le nom de la base de données à utiliser
    résultat: l'objet qui gère le connection MySQL si tout s'est bien passé
    """
    try:
        #creation de l'objet gérant les interactions avec le serveur de BD
        engine=sqlalchemy.create_engine('mysql+mysqlconnector://'+user+':'+passwd+'@'+host+'/'+database)
        #creation de la connexion
        cnx = engine.connect()
    except Exception as err:
        print(err)
        raise err
    print("connexion réussie")
    return cnx

def max_article(connexion):
    res = ""
    try:
        rep = connexion.execute("select IFNULL(max(reference),0) maxRef,libelle,prix from ARTICLE;")
        for (maxRef,libelle,prix) in rep:
            res = int(maxRef)
    except Exception as err:
        print(err)
    return res

def get_article(connexion,reference):
    res = ""
    try:
        rep = connexion.execute("select * from ARTICLE where reference = %s",reference)
        for (ref,libelle,prix) in rep:
            res = Article(int(ref),libelle,float(prix))
    except Exception as err:
        print(err)
    return res

def getMaxArticle(connexion):
    return get_article(connexion,max_article(connexion))
    
def getArticles(connexion):
    liste = []
    try:
        rep = connexion.execute("select * from ARTICLE;")
        for (ref,libelle,prix) in rep:
            liste.append(Article(int(ref),libelle,float(prix)))
    except Exception as err:
        print(err)
    return liste

def getEntrepotsParDep(connexion):
    res = ""
    dernierdept = ""
    compteur = 0
    try:
        rep = connexion.execute("select * from ENTREPOT ORDER BY DEPARTEMENT;")
        for (code,nom,dep) in rep:
            if (dernierdept != dep):
                if res =="":
                    res = "les entrepots triés par départements : "+"\n" + "\t"+dep+"\n"
                    dernierdept = dep
                else:
                    res+= "\t"+"il y a "+str(compteur)+" entrepots dans ce département"+"\n" + "\t"+dep+"\n"
                    compteur = 0
                    dernierdept = dep
            compteur+=1
            res += "\t"*2+nom+" de code "+str(code)+"\n"
        res+= "\t"+"il y a "+str(compteur)+" entrepots dans ce département"+"\n"
    except Exception as err:
        print(err)
    print(res)

def q6(connexion,a):
    res = ""
    res_bis = ""
    rer = ""
    cpt = 0
    try:
        rep = connexion.execute(f"select COUNT(code) as nbent,code,nom,departement,quantite from ENTREPOT NATURAL JOIN STOCKER where reference = {a._reference} and quantite !=0 group by code;")
        #rep.first()
        for nbent,code,nom,dep,qte in rep:
            cpt+=nbent
            res+=f"l'entreprise {code} nommé {nom} du departement {dep} possède l'article {a} en qte {qte} \n"
        res_bis+=f"Il y a {cpt} entrepots qui possèdent cet article \n"
        rer += res_bis + res
    except Exception as err:
        print(err)
    print(rer)

def q7(connexion,code):
    res = f"Liste des articles dans l'entrepot de code {code} :\n"
    try:
        rep = connexion.execute(f"select reference,libelle,prix,quantite from ARTICLE NATURAL JOIN STOCKER where code = {code};")
        for r,l,p,q in rep:
            res += f"{Article(r,l,p)} en qte {q}\n"
    except Exception as err:
        print(err)
    print(res)

def q8(connexion,code):
    res = f"Liste des articles dans l'entrepot de code {code} :\n"
    somme = 0
    nb_article = 0
    try:
        rep = connexion.execute(f"select sum(quantite*prix)as somme,reference,libelle,prix,quantite from ARTICLE NATURAL JOIN STOCKER where code = {code} group by reference;")
        for s,r,l,p,q in rep:
            nb_article+=1
            res += f"{Article(r,l,p)} en qte {q}\n"
            somme+=s
        res+=f"l'entrepot {code} possède {nb_article} et la somme des valeurs est de {somme}"
    except Exception as err:
        print(err)
    print(res)

def majArticle(connexion,a):
    res=""
    try:
        rep =connexion.execute(f"select reference,libelle,prix from ARTICLE where reference = {a._reference};")
        res = rep.first()
        if res is not None and res[1]==a._libelle:
            connexion.execute(f"update ARTICLE set prix={a._prix} where reference = {a._reference}")
            connexion.close()
            print("updated")
        elif res is not None and res[1]!=a._libelle:
            print("nevermind")
        else:
            connexion.execute(f"insert into ARTICLE values({a._reference},'{a._libelle}',{a._prix});")
            print("new Article inserted into the Nothan Interactive Database")
            connexion.close()
    except Exception as err:
        print("an error has occured")
        print(err)

def ajoutEntrepot(connexion,e):
    res=""
    try:
        rep =connexion.execute(f"select * from ENTREPOT where code = {e._code};")
        res = rep.first()
        if res is not None:
            print(f"the warehouse code {e._code} already exists within our Database")
        else:
            connexion.execute(f"insert into ENTREPOT values({e._code},'{e._nom}','{e._dep}');")
            print(f"the warehouse code {e._code}, named '{e._nom}', from the department' {e._dep}' was successfully inserted into the Nothan Interactive Database")
            connexion.close()
    except Exception as err:
        print("an error has occured")
        print(err)
if __name__ == "__main__":
    #login=input("login MySQL ")
    #passwd=getpass.getpass("mot de passe MySQL ")
    #serveur=input("serveur MySQL ")
    #bd=input("nom de la base de données ")
    cnx=ouvrir_connexion("bourdere","bourdere","servinfo-mariadb","DBbourdere")
    print(max_article(cnx))
    print(get_article(cnx,1))
    print(getMaxArticle(cnx))
    print(getArticles(cnx))
    getEntrepotsParDep(cnx)
    q6(cnx,Article(123,"tuile17x27",2.55))
    q7(cnx,1)
    q8(cnx,1)
    majArticle(cnx,Article(123,"tuile18x27",4.55))
    ajoutEntrepot(cnx,Entrepot(7,"niggers","Cher"))
#ajoutEnte
    # ici l'appel des procédures et fonctions
    cnx.close()
