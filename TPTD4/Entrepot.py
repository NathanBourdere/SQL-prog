class Entrepot:
    def __init__(self,code,nom,dep) -> None:
        self._code = code
        self._nom = nom
        self._dep = dep
    
    def __repr__(self) -> str:
        return "Entrepot %d nommé %s qui vient du departement %s"+"\n"

    @property
    def getCode(self):
        return self._code
    
    @property
    def getNom(self):
        return self._nom
    
    @property
    def getDep(self):
        return self._dep
    
    def setCode(self,c):
        self._code = c
    
    def setNom(self,n):
        self._nom = n
    
    def setDep(self,d):
        self._dep = d