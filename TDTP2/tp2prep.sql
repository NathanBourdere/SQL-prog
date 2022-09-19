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
declare nbDep int default 0;
declare fini boolean default false;
declare fin boolean default false;
declare curseur cursor for
    select COUNT(distinct code)feur, code,nom,departement
    from ENTREPOT
    group by departement
    order by departement;

declare continue handler for not found set fini = true;

open curseur;
    while not fini do
    fetch curseur into nbDep, cod,nomEnt,dpt;

    if not fini then
        set res = concat(res,"le dpt ",dpt," possède ",nbDep," entrepots",'\n','     ','entrepot ',cod,' ',nomEnt,'\n');
        end if;
    end while;
close curseur;
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
