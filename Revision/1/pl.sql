--num -> nom,prenom,bac,annee
--reference -> nom,domaine,nbdomaines
--num,reference -> nbHeuresEffectuees,*
--nom,domaine -> reference,nbdomaines
--domaine -> nbHeuresTotales
DELIMITER |
CREATE OR REPLACE FUNCTION getElevesDuBac(lebac varchar(50)) returns int(10)
begin
    declare res int(10) DEFAULT -1;
    select count(num) into res
    from ELEVE
    where bac = lebac;
return res;
END |
DELIMITER ;

select getElevesDuBac("STI2D");

DELIMITER |
CREATE OR REPLACE FUNCTION getTotHeuresEleve(numE int(9)) returns int(10)
begin 
    declare res int(10) DEFAULT -1;
    select ifnull(sum(nbheureseffectuees),0) into res
    from ELEVE NATURAL JOIN SUIVRE
    WHERE num = numE;
return res;
END |
DELIMITER ;

select getTotHeuresEleve(1);

DELIMITER | 
CREATE OR REPLACE PROCEDURE afficheMatieresSuivisEleve(numE int(9))
begin
    declare res varchar(500) DEFAULT 'Ensemble des matières suivis par eleve '+numE+"\n";
    declare refM varchar(42) DEFAULT '';
    declare nomM varchar(42) DEFAULT '';
    declare domM varchar(42) DEFAULT '';
    declare nbheures int(10);
    declare fini boolean DEFAULT false;
    declare lesMatieres cursor for
        select reference,nom,domaine,nbheurestotale
        from MATIERE NATURAL JOIN SUIVRE
        where num = numE;
    
    declare continue handler for not found set fini = true;

open lesMatieres;
    while not fini do
        fetch lesMatieres into refM,nomM,domM,nbheures;

        if not fini then
            set res = concat(res,"",refM," : ",nomM," domaine ",domM," heures de la matière : ",nbheures,"\n");
        end if;
    end while;
close lesMatieres;
select res;
END |
DELIMITER ;
call afficheMatieresSuivisEleve(1);

DELIMITER |
CREATE OR REPLACE TRIGGER nomMatiereUnique BEFORE INSERT ON MATIERE FOR EACH ROW
begin
    declare res varchar(500) DEFAULT '';
    declare nomM varchar(42) DEFAULT '';
    select nom into nomM from MATIERE where nom = new.nom and domaine = new.domaine;
    if (nomM = new.nom) then
    set res = concat(res,"tu peux pas frr pck ",new.nom," existe déjà dans le domaine ",new.domaine);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = res;
    end if;
END |
DELIMITER ;
INSERT INTO MATIERE VALUES(3042,"Web","prog",36); 