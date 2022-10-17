class Stocker:

    def __init__(self,reference,code,qte) -> None:
        self._reference = reference
        self._code = code
        self._qte = qte

    def __repr__(self) -> str:
        return "Article %d dans l'entrepot %s est disponible en qte %d"+"\n"

    @property
    def getRef(self):
        return self._reference
    
    @property
    def getCode(self):
        return self._code
    
    @property
    def getQte(self):
        return self._qte
    
    def setRef(self,ref):
        self._reference = ref
    
    def setCode(self,l):
        self._code = l
    
    def setQte(self,p):
        self._qte = p