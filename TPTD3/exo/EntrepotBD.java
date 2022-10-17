import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EntrepotBD {
    ConnexionMySQL co;

    public EntrepotBD(ConnexionMySQL co) {
        this.co = co;
    }

    public int maxReference() throws SQLException{
        Connection connexion = co.getConnexion();
        
        Statement statement = connexion.createStatement();
        ResultSet result = statement.executeQuery("select IFNULL(max(reference),0) as maxRef from ARTICLE;");
        if (result.next()){
        return result.getInt("maxRef");}
        return -1;
    }

    public Article getArticle(int reference) throws SQLException{
        Connection connexion = co.getConnexion();
        
        PreparedStatement ps = connexion.prepareStatement("select * from ARTICLE where reference = ?;");
        ps.setInt(1, reference);
        ResultSet r = ps.executeQuery();
        if(r.next()){
        return new Article(r.getInt(1),r.getString(2),r.getDouble(3));
        }
        return null;
    }

    public Article getmaxRefArticle() throws SQLException{
        return getArticle(maxReference());
    }

    public List<Article> getArticles() throws SQLException{
        List<Article> l = new ArrayList<>();
        Connection connexion = co.getConnexion();
        
        Statement statement = connexion.createStatement();
        ResultSet r = statement.executeQuery("select * from ARTICLE;");
        while(r.next()){
            l.add(new Article(r.getInt(1),r.getString(2),r.getDouble(3)));
        }
        return l;
    }

    public void getEntrepotsPardpt() throws SQLException{
        String res = "";
        String dernierdept = "";
        String espace = "  ";
        boolean fin = false;
        int compteur = 0;
        Connection connexion = co.getConnexion();
        Statement statement = connexion.createStatement();
        ResultSet r = statement.executeQuery("select * from ENTREPOT ORDER BY DEPARTEMENT;");
        while(r.next()){
            if (!dernierdept.equals(r.getString(3))){
                if (res.equals("")){
                    res = "les entrepots triés par départements : "+"\n";
                    res += espace+r.getString(3)+"\n";
                    dernierdept = r.getString(3);
                }
                else{
                    res+= espace+"il y a "+compteur+" entrepots dans ce département"+"\n";
                    compteur = 0;
                    res += espace+r.getString(3)+"\n";
                    dernierdept = r.getString(3); 
                }
            }  
                ++compteur;
                res += espace+espace+r.getString(2)+" de code "+r.getInt(1)+"\n";
        }
        res+= espace+"il y a "+compteur+" entrepots dans ce département"+"\n";
        System.out.println(res);
    }

    public void q6(Article a) throws SQLException{
        String res = "Liste des entrepots disposant de l'article "+a+" :"+"\n";
        boolean debut = true;
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select COUNT(code) as nbent,code,nom,departement,quantite from ENTREPOT NATURAL JOIN STOCKER where reference = ? and quantite != ? group by code;");
        ps.setInt(2,0);
        ps.setInt(1,a.getReference());
        ResultSet r = ps.executeQuery();
        while(r.next()){
            if (debut){
            res += "il y a "+r.getInt(1)+" entrepots possédants cette article "+"\n";
            debut = false;
            }
            res += "l'entrepot "+r.getString(3)+" de code "+r.getInt(2)+" du département "+r.getString(4)+" en qte "+r.getInt(5)+"\n";
        }
        System.out.println(res);
    }
    
    public void q7(int code) throws SQLException{
        String res = "Liste des articles dans l'entrepot de code "+code+" :"+"\n";
        int nb = 0;
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select reference,libelle,prix,quantite from ARTICLE NATURAL JOIN STOCKER where code = ?;");
        ps.setInt(1,code);
        ResultSet r = ps.executeQuery();
        while(r.next()){
            nb++;
            res += "l'article "+r.getString(2)+" reference "+r.getInt(1)+" prix "+r.getString(3)+" en qte "+r.getInt(4)+"\n";
        }
        res += "il y a "+nb+" articles dans cet entrepot "+"\n";
        System.out.println(res);

    }
    public void q8(int code) throws SQLException{
        String res = "Liste des articles dans l'entrepot de code "+code+" :"+"\n";
        int nb = 0;
        int valfin = 0;
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select sum(quantite*prix)as somme,reference,libelle,prix,quantite from ARTICLE NATURAL JOIN STOCKER where code = ? group by reference;");
        ps.setInt(1,code);
        ResultSet r = ps.executeQuery();
        while(r.next()){
            nb++;
            valfin +=r.getInt(1);
            res += "val : "+r.getInt(1)+"\n";
        }
        res += "il y a "+nb+" articles dans cet entrepot et la somme des vals est "+valfin+"\n";
        System.out.println(res);
    }

    public int majArticle(Article a) throws SQLException{
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select reference,libelle,prix from ARTICLE where reference = ?;");
        ps.setInt(1,a.getReference());
        ResultSet r = ps.executeQuery();
        boolean rbool = r.next();
        if (rbool && r.getString(2).equals(a.getLibelle())){
            PreparedStatement statement = connexion.prepareStatement("update ARTICLE set prix=? where reference = ?");
            statement.setDouble(1, r.getDouble(3));
            statement.setInt(2,r.getInt(1));
            int i = statement.executeUpdate();
            if (i==-1){
                System.out.println("Update error");
                return -1;
            }
            System.out.println("update bien");
            return a.getReference();
        }
        else if(rbool && !(r.getString(2).equals(a.getLibelle()))){
            System.out.println("rien");
            return -1;
        }
        else{
            PreparedStatement statement = connexion.prepareStatement("insert into ARTICLE values(?,?,?);");
            statement.setInt(1,maxReference()+1);
            statement.setString(2,a.getLibelle());
            statement.setDouble(3,a.getPrix());
            int i = statement.executeUpdate();
            if (i==-1){
                System.out.println("Insert error");
                return -1;
            }
            System.out.println("insert bien");
            return a.getReference();
        }
    }
    public int ajoutEntrepot(Entrepot e) throws SQLException{
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select * from ENTREPOT where code = ?;");
        ps.setInt(1,e.getCode());
        ResultSet r = ps.executeQuery();
        boolean rbool = r.next();
        if(rbool){
            System.out.println("rien");
            return -1;
        }
        else{
            PreparedStatement statement = connexion.prepareStatement("insert into ENTREPOT values(?,?,?);");
            statement.setInt(1,e.getCode());
            statement.setString(2,e.getNom());
            statement.setString(3,e.getDepartement());
            int i = statement.executeUpdate();
            if (i==-1){
                System.out.println("Insert error");
                return -1;
            }
            System.out.println("insert bien"+e.getNom());
            return e.getCode();
        }
    }
    public int entrerStock(int refA,  int codeE, int qte) throws SQLException{
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select * from STOCKER NATURAL JOIN ENTREPOT where code = ? and reference = ?;");
        ps.setInt(1,codeE);
        ps.setInt(2,refA);
        ResultSet r = ps.executeQuery();
        boolean rbool = r.next();
        if(!rbool){
            System.out.println("rien");
            return -1;
        }
        else{
            PreparedStatement statement = connexion.prepareStatement("update STOCKER set quantite = ? where code = ? and reference = ?;");
            statement.setInt(1,r.getInt(3)+qte);
            statement.setInt(2,codeE);
            statement.setInt(3,refA);
            int i = statement.executeUpdate();
            if (i==-1){
                System.out.println("update error");
                return -1;
            }
            System.out.println("update cool bien nouvelle quantite "+ (r.getInt(3)+qte)+" prix de base : "+r.getInt(3));
            return i;
        }
    }
    public int sortirStock(int refA, int codeE, int qte) throws SQLException{
        Connection connexion = co.getConnexion();
        PreparedStatement ps = connexion.prepareStatement("select * from STOCKER NATURAL JOIN ENTREPOT where code = ? and reference = ?;");
        ps.setInt(1,codeE);
        ps.setInt(2,refA);
        ResultSet r = ps.executeQuery();
        boolean rbool = r.next();
        if (qte>r.getInt(3)){
            return -2;
        }
        if(!rbool){
            System.out.println("rien");
            return -1;
        }
        else{
            PreparedStatement statement = connexion.prepareStatement("update STOCKER set quantite = ? where code = ? and reference = ?;");
            statement.setInt(1,r.getInt(3)-qte);
            statement.setInt(2,codeE);
            statement.setInt(3,refA);
            int i = statement.executeUpdate();
            if (i==-1){
                System.out.println("update error");
                return -1;
            }
            System.out.println("update cool bien nouvelle quantite "+ (r.getInt(3)-qte)+" prix de base : "+r.getInt(3));
            return i;
        }
    }
    
    }


