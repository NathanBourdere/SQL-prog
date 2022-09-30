--prepare nomRequete from
--'Select...
--From...
--Where... >=?'?
--set @somme:=10;
--execute nomRequete using @somme;

--question 1
PREPARE listeArticle FROM
    'SELECT *
    FROM ARTICLE
    WHERE prix <= ?';
set @prix := 4;
EXECUTE listeArticle using @prix;

--question 2
PREPARE qteStock FROM
    'SELECT *
     FROM ARTICLE NATURAL JOIN STOCKER NATURAL JOIN ENTREPOT
     WHERE libelle = ? and departement = ?';
set @dep := 'Loiret';
set @libelle := 'Chaise';
EXECUTE qteStock using @libelle,@dep;

--exo 2 question 1

DELIMITER |
create or replace function maxRefArticle() returns int
begin
    declare res int;
        select IFNULL(max(reference),0) into res
        from ARTICLE;
return res;
END |
DELIMITER ;

select maxRefArticle();

--exo 2 q2

DELIMITER |
create or replace function deptEntrepot(codeEnt int) returns varchar(42)
begin
    declare res varchar(42) DEFAULT '';
    select departement into res
    from ENTREPOT
    where code = codeEnt;
    if res = '' then set res = concat("l'entrepôt numéro ",codeEnt," n'existe pas"); end if;
return res;
END |
DELIMITER ;
select deptEntrepot(5);

--exo 2 q3
DELIMITER |
create or replace function valEntrepot(codeEnt int) returns int
begin 
    declare res int DEFAULT 0;
    select sum(quantite * prix) into res
    from ENTREPOT NATURAL JOIN STOCKER NATURAL JOIN ARTICLE
    where code = codeEnt;
return res;
END |
DELIMITER ;
select valEntrepot(1);
--exo 2 q4
DELIMITER |
create or replace procedure toutEntrepots()
begin
declare res varchar(500) default '';
declare cod int;
declare nomEnt varchar(42);
declare dpt varchar(42);
declare fini boolean default false;
declare lesEntrepots cursor for
    select code, nom, departement
    from ENTREPOT;

declare continue handler for not found set fini = true;

open lesEntrepots;
    while not fini do
        fetch lesEntrepots into cod, nomEnt, dpt;

        if not fini then
            set res = concat(res,"l'entrepot ",cod,' nommé ',nomEnt,' du département ',dpt,'\n');
        end if;
    end while;
close lesEntrepots;
select res;
end |
delimiter ;
call toutEntrepots();

--exo 2 q5
DELIMITER |
create or replace procedure entrepotsParDep()
begin 
declare res varchar(500) default '';
declare dpt varchar(42);
declare cod int;
declare nomEnt varchar(42);
declare deptPrec varchar(42) default '';
declare nbDep int default 0;
declare fini boolean default false;
declare fin boolean default false;
declare curseur cursor for
    select code,nom,departement
    from ENTREPOT
    order by departement;

declare continue handler for not found set fini = true;

open curseur;
set deptPrec = '';
set nbDep = 0;
    while not fini do
    fetch curseur into cod,nomEnt,dpt;

    if not fini then
        if(deptPrec !='' and deptPrec!=dpt) then
            set res = concat(res," il y a ",nbDep," entrepots dans le departement ",deptPrec,'\n','     ','\n ');
            set nbDep = 0;
        end if;
        set deptPrec = dpt;
        set nbDep = nbDep+1;
        set res = concat(res,'entrepot code ',cod,' nom ',nomEnt,'\n ');
        end if;
    end while;
close curseur;
    if nbDep!=0 then
    set res = concat(res," il y a ",nbDep," entrepots dans le departement ",deptPrec,'\n','     ','\n ');
    end if;
select res;
end |
delimiter ;
call entrepotsParDep();

--exo 2 q6

DELIMITER |
create or replace procedure entrepotsParDep()
begin 
declare res varchar(500) default '';
declare dpt varchar(42);
declare valdept int default 0;
declare nbDep int default 0;
declare fini boolean default false;
declare curseur cursor for
    select sum(quantite * prix)val,COUNT(distinct code)feur, departement
    from ENTREPOT NATURAL LEFT JOIN STOCKER NATURAL JOIN ARTICLE
    group by departement
    order by departement;

declare continue handler for not found set fini = true;

open curseur;
    while not fini do
    fetch curseur into valdept,nbDep, dpt;

    if not fini then
        set res = concat(res,"le dpt ",dpt," possède ",nbDep," entrepots"," et à un patrimoine de ",valdept ,'\n');
        end if;
    end while;
close curseur;
select res;
end |
delimiter ;
call entrepotsParDep();

--exo 2 q7

DELIMITER |
create or replace function majArticle(ref INT(4),newLibelle varchar(42),newPrix decimal(5,2)) returns varchar(500)
begin
    declare res varchar(500) DEFAULT "libelle qui n'existe pas";
    declare refres varchar(42) DEFAULT '';
    declare intRes int(50) DEFAULT -1;
    declare prixRes decimal(5,2) DEFAULT 0.0;
    declare maximum int(5) DEFAULT 0;
        select reference,libelle into intres,refres
        from ARTICLE
        where reference = ref;
    if intres = ref THEN
    if refres = newLibelle THEN
    update ARTICLE
    set prix = newPrix
    where reference = ref;
    set res = concat(res,"la table Article a été modifiée, l'article ",ref," qui propose : ",newLibelle," a vu son prix être modifié, nouveau prix : ",newPrix);
    end if;
    ELSE
    set maximum = maxRefArticle()+1;
    insert into ARTICLE VALUES(maximum,newLibelle,newPrix);
    set res = concat(res,"la table Article a un nouvel article, l'article ",maximum," qui propose : ",newLibelle," à été crée, nouveau prix : ",newPrix);
    end if;
return res;
END |
DELIMITER ;
select majArticle(123,'fpjapf', 3.55);

--exo2 q8
DELIMITER |
create or replace function entrerStock(refA int, codeE int, qte int) returns int(6)
begin
    declare res int(6) DEFAULT -1;
    declare resA int(6) DEFAULT 0;
    declare resE int(6) DEFAULT 0;
    declare resQ int(6) DEFAULT 0;
    
    select reference into resA from ARTICLE where reference = refA;

    select code into resA from ENTREPOT where code = codeE;

    if (resA is not null and resE is not null) THEN
    select quantite into resQ from STOCKER where code = codeE and reference = refA;
        if (resQ IS NULL) THEN
        insert into STOCKER(reference,code,quantite) values(refA,codeE,qte);
        else
        set qte = qte+resQ;
        update STOCKER set quantite=qte where code=codeE and reference = refA;
        set res = qte;
        end if;
    end if;
return res;
END |
DELIMITER ;
select entrerStock(1,1,25);

--exo2 q9
DELIMITER |
create or replace function retirerStock(refA int, codeE int, qte int) returns int(6)
begin
    declare res int(6) DEFAULT -1;
    declare resA int(6) DEFAULT 0;
    declare resE int(6) DEFAULT 0;
    
    select reference,code into resA,resE
    from STOCKER 
    where reference = refA and code = codeE;

    if resA = refA and resE = codeE THEN
        update STOCKER
        set quantite = quantite-qte
        where reference = refA and code = codeE;
        set res = qte;
    end if;
return res;
END |
DELIMITER ;
--select retirerStock(1,1,25);

--exo3 q1
--ou ALTER TABLE ENTREPOT ADD CONSTRAINT UNIQUE(nom, departement);
DELIMITER |
create or replace trigger uniciteNomEnt before insert on ENTREPOT for each row
begin
    declare entNom int;
    declare res varchar(500) default '';
    select nom into entNom from ENTREPOT where nom = new.nom and departement = new.departement;
    if (entNom is not null) THEN
        set res = concat(res,"erreur :",entNom," déjà dans la bd");
        signal SQLSTATE '45000' set MESSAGE_TEXT = res;
    end if;
END |
DELIMITER ;

--exo3 q2

DELIMITER |
create or replace trigger trigga before insert on ENTREPOT for each row
begin
    declare jspquoi int;
    declare res varchar(500) default '';
    select IFNULL(count(code),0) into jspquoi from ENTREPOT;
    if (jspquoi > 3) THEN
        set res = concat(res,"erreur : trop d'entreprise dans ce département ( ",jspquoi," doit être inférieur ou égal à 3");
        signal SQLSTATE '45000' set MESSAGE_TEXT = res;
    end if;
END |
DELIMITER ;

--exo3 q3

DELIMITER |
create or replace trigger exo3 before update on ENTREPOT for each row
begin
    declare diff int(6);
    declare res varchar(500) default '';
    declare qteAjoute int(6);
    declare oldQte int(6);
    declare refA int(6);
    declare codeE int(6);
    select reference,code,quantite into refA,codeE,oldQte from ARTICLE NATURAL JOIN STOCKER NATURAL JOIN ENTREPOT where reference = new.reference;
    set qteAjoute = new.quantite;
    set diff = qteAjoute-oldQte;
    create or replace view 