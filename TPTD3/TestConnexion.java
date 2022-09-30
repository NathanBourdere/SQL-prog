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