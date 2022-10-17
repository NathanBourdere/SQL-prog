class Article:

    def __init__(self,reference,libelle,prix) -> None:
        self._reference = reference
        self._libelle = libelle
        self._prix = prix

    def __repr__(self) -> str:
        res ="Article %d nommé %s coûte %r"%(self._reference,self._libelle,self._prix)
        return res
    @property
    def getRef(self):
        return self._reference
    
    @property
    def getLibelle(self):
        return self._libelle
    
    @property
    def getPrix(self):
        return self._prix
    
    def setRef(self,ref):
        self._reference = ref
    
    def setLibelle(self,l):
        self._libelle = l
    
    def setPrix(self,p):
        self._prix = p