public class Article {
    int reference;
    String libelle;
    double prix;
    public Article(int r,String l,double p){
        this.reference = r;
        this.libelle = l;
        this.prix = p;
    }
    public int getReference() {
        return reference;
    }
    public void setReference(int reference) {
        this.reference = reference;
    }
    public String getLibelle() {
        return libelle;
    }
    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
    public double getPrix() {
        return prix;
    }
    public void setPrix(double prix) {
        this.prix = prix;
    }
    @Override
    public String toString() {
        return "Article [reference=" + reference + ", libelle=" + libelle + ", prix=" + prix + "]";
    }
}
