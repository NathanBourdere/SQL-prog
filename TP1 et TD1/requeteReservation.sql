select idO,nomO,idT
from OCCUPANT NATURAL JOIN LETYPE;

SELECT idS,nomS
from SALLE NATURAL JOIN RESERVABLE NATURAL JOIN LETYPE
where letype='Assos';

select idO, nomO, caracteristique, nomS
from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
where nomS = 'Salle des fêtes' or nomS = 'Salle info';

select idO, nomO, caracteristique, nomS
from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
where nomS = 'Salle des fêtes'
INTERSECT
select idO, nomO, caracteristique, nomS
from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
where nomS = 'Salle info';

select idO, nomO, caracteristique, nomS
from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
where nomS = 'Salle des fêtes' and idO in (
    select idO
    from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
    where nomS = 'Salle info'
);

select idO, nomO, caracteristique, nomS
from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
where nomS = 'Salle des fêtes' and idO not in (
    select idO
    from OCCUPANT NATURAL JOIN RESERVATION NATURAL JOIN SALLE
    where nomS = 'Salle info'
);

select *
from SALLE
where capacite = (SELECT max(capacite) FROM SALLE);

select sum(duree) duréeTotale,nomS,MONTH(ladate) mois
from SALLE NATURAL JOIN RESERVATION 
GROUP BY idS,MONTH(ladate);

select * 
from OCCUPANT 
where not exists (select idS from SALLE EXCEPT select idS from RESERVER where RESERVER.idO = OCCUPANT.idO);

select idO ,count(distinct idS)
from OCCUPANT NATURAL JOIN RESERVATION
GROUP BY idO
having count(distinct idS) = (select count(*) from SALLE);





select *
from RESERVATION
where heure + duree > 24;

select idS,idO,ladate,heure,duree,nbpers
from RESERVATION NATURAL JOIN OCCUPANT NATURAL JOIN SALLE
where capacite < nbpers;

select idS,idO,ladate,heure,duree,nbpers
from RESERVATION NATURAL JOIN OCCUPANT NATURAL JOIN SALLE S1
where OCCUPANT.idT not in(
    select idT
    from RESERVABLE NATURAL JOIN SALLE S2
    where S1.ids = S2.ids
);

select r1.*,r2.*
from RESERVATION r1, RESERVATION r2
where r1.ladate = r2.ladate and r1.idS = r2.idS and r1.idO != r2.idO and r1.heure > r2.heure and (r1.heure + r1.duree) > r2.heure;