import java.sql.*;
public class TestConnexion {
    public static void main (String[] args){
    ConnexionMySQL co;
    String loginMySQL = "bourdere";
    String mdpMySQL = "bourdere";
    String nomServeur = "servinfo-mariadb";
    String nomBase = "DB" + loginMySQL;
    co = new ConnexionMySQL(nomServeur, nomBase, loginMySQL, mdpMySQL);
    if ( co.getConnecte()){
    System.out.println("La connexion s’est bien passee") ;
    Connection connex = co.getConnexion();
    EntrepotBD edb = new EntrepotBD(co);
    try{
    System.out.println("q1 : "+edb.maxReference());
    System.out.println("q2 : "+edb.getArticle(1));
    System.out.println("q3 : "+edb.getmaxRefArticle());
    System.out.println("q4 : "+edb.getArticles());
    System.out.println("q5 : ");
    edb.getEntrepotsPardpt();
    System.out.println("q6 : ");
    edb.q6(new Article(1, "Chaise", 49));
    System.out.println("q7 : ");
    edb.q7(1);
    System.out.println("q8 : ");
    edb.q8(1);
    System.out.println(edb.majArticle(edb.getArticle(123)));
    System.out.println(edb.ajoutEntrepot(new Entrepot(4, "jsp", "Loiret")));
    System.out.println(edb.entrerStock(1,1 ,35));
    System.out.println(edb.sortirStock(1, 1, 30));
    }
    catch(SQLException e){
    System.out.println(e);
    }
    }
    else{
    System.out.println("La connexion a votre BD ne s’est pas faite");
    }
    }
}