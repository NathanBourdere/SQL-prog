public class Entrepot{
    private int code;
    private String nom;
    private String departement;
    public Entrepot(int c,String n,String d){
        this.code = c;
        this.nom = n;
        this.departement = d;
    }
    public int getCode(){
        return this.code;
    }
    public void setCode(int c){
        this.code = c;
    }
    public String getNom(){
        return this.nom;
    }
    public void setNom(String n){
        this.nom = n;
    }
    public String getDepartement() {
        return departement;
    }
    public void setDepartement(String departement) {
        this.departement = departement;
    }
    @Override
    public String toString() {
        return "Entrepot [code=" + code + ", nom=" + nom + ", departement=" + departement + "]";
    }
}
