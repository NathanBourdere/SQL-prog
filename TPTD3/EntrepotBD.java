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
        
        PreparedStatement ps = connexion.prepareStatement("select * from ARTICLE where reference = ?");
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
        Connection connexion = co.getConnexion();
        Statement statement = connexion.createStatement();
        ResultSet r = statement.executeQuery("select * from ENTREPOT ORDER BY DEPARTEMENT");
        while(r.next()){
            
        }

    }

}
