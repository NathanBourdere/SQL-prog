--question 1 : insertion pas possible
INSERT INTO TABLE RESERVABLE(000,9);
--question 2
insert into OCCUPANT values(06,'mairie pasqueeier','mairie du villeeage',8);
-- clé étrangère de OCCUPANT vers TYPE (idT)

--question 3
insert into LETYPE values (6,'Particulier');
-- accepté, car il n'y a aucune contrainte émise lors de la création, il faut donc utiliser le mot clé "unique" lors de la création de l'attribut "duplicate entry"

--question 4
insert into SALLE values (009, 'Salle des fêtes', 133);

--question 5
INSERT INTO RESERVATION VALUES(000,09,'2021-06-25',10,2,16);
-- pas accepté, clé étrangère de OCCUPANT vers RESERVATION vers TYPE keepo

--question 6
INSERT INTO RESERVATION VALUES(999,02,'2022-06-25',10,2,16);
-- Cannot add or update a child row: a foreign key constraint fails (`DBbourdere`.`RESERVATION`, CONSTRAINT `RESERVATION_ibfk_2` FOREIGN KEY (`idS`) REFERENCES `SALLE` (`idS`))

--question 7
INSERT INTO RESERVATION VALUES(000,05,'2022-12-25',24,2,16);

--question 8
INSERT INTO RESERVATION VALUES(000,02,'2022-09-14',24,2,16);
-- faire un trigger (je suis vraiment triggered)

--question 9
INSERT INTO RESERVATION VALUES(000,01,'2020-09-13',20.5,1,16);
--accepté mais l'heure se fait arrondir, faudrait faire un trigger

--question 10
INSERT INTO RESERVATION VALUES(000,01,'2013-10-10',20,1,NULL);
--accepte, mettre un not null dans le truc de création

--question 11
INSERT INTO RESERVATION VALUES(000,01,'2024-10-10',20,2,488);
--faire un trigger

--question 12
INSERT INTO RESERVATION VALUES(000,01,'2024-10-10',20,2,48),
(000,02,'2024-10-10',21,2,48);
--faire un PUTAIN de trigger