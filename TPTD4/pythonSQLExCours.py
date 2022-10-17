#! /usr/bin/python3
import sqlalchemy  
# pour avoir sqlalchemy s'il n'est pas installé :
# sudo apt-get update 
# sudo apt-get install python3-sqlalchemy
# pip3 install mysql-connector-python

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

def saisir_activite():
    ref=input("entrez le numéro de l'activité : ")
    ref=int(ref)
    nom=input("entrez le nom de l'activité : ")
    am=input("entrez l'age minimum pour l'activité : ")
    am=int(am)
    ana=input("entrez l'année de l'activité : ")
    ana=int(ana)
    nmp=input("entrez le nombre maxi de participant pour l'activité : ")
    nmp=int(nmp)
    idp=input("entrez le numéro de la personne qui anime l'activité : ")
    idp=int(idp)
    
    return (ref,nom,am, ana, nmp, idp)
        
def ajouter_des_activites(connexion):
    """
    ajoute une nouvelle activité dans la base de données
    paramètres:
       connexion (Connection) une connexion ouverte sur le serveur MySQL
    """
    rep='O'
    while rep=='O':
        act=saisir_activite()
        try:
            # instruction permettant l'insertion 
            # les %s vont être remplacés par les valeurs représentant le produit
            connexion.execute("insert into ACTIVITE(ida, noma, agemini, annee, nbmaxp, idp) values (%s,%s,%s,%s,%s,%s)",act)
            print("l'activité ",act,"a été insérée avec succès")
        except Exception as err:
            print("l'activité",act,"n'a pas pu être insérée")
            print(err)
        rep=input("Voulez vous ajouter une autre activité (O/N)? ")
        
def afficher_personne_annee(connexion):
    annee=input("entrez l'année de naissance dont vous cherchez les personnes ")
    annee=int(annee)
    resultat=connexion.execute("select idp, nomp, prenomp, ddnp from PERSONNE where YEAR(ddnp)=%s",annee)
    print("les personnes née en ",annee,"sont les suivantes")
    for (num,nom,prenom,nele) in resultat:
        print(str(num).rjust(5),nom.ljust(15),prenom.ljust(15), str(nele).ljust(20))

    

if __name__ == "__main__":
    login=input("login MySQL ")
    passwd=getpass.getpass("mot de passe MySQL ")
    serveur=input("serveur MySQL ")
    # serveur = 'servinfo-mariadb'  # pour IUT
    bd=input("nom de la base de données ")
    cnx=ouvrir_connexion("bourdere","bourdere","servinfo-mariadb","DBbourdere")
    ajouter_des_activites(cnx)
    afficher_personne_annee(cnx)
    cnx.close()
