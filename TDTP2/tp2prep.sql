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
create or replace function 
--exo 2 q4

create or replace procedure 