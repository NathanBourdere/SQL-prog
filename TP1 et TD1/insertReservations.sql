insert into SALLE values (000, 'Salle des fêtes', 123);
insert into SALLE values (001, 'Salle info', 124);
insert into SALLE values (002, 'Salle conseil', 125);
insert into SALLE values (003, 'Salle écureil', 126);
insert into SALLE values (004, 'Salle jsp', 127);

insert into LETYPE values (1,'Ecole');
insert into LETYPE values (2,'Mairie');
insert into LETYPE values (3,'Maison');
insert into LETYPE values (4,'Assos');
insert into LETYPE values (5,'Particulier');

insert into OCCUPANT values(01,'école jean pasquier','école du village',1);
insert into OCCUPANT values(02,'Assos du coeur','assos cool',4);
insert into OCCUPANT values(03,'Maison 348','Maison du village',3);
insert into OCCUPANT values(04,'Particulier','particulier simpa',5);
insert into OCCUPANT values(05,'mairie pasquier','mairie du village',2);


insert into RESERVABLE values(1,001);
insert into RESERVABLE values(1,002);
insert into RESERVABLE values(1,003);
insert into RESERVABLE values(1,004);
insert into RESERVABLE values(2,000);
insert into RESERVABLE values(2,001);
insert into RESERVABLE values(2,002);
insert into RESERVABLE values(2,003);
insert into RESERVABLE values(3,001);
insert into RESERVABLE values(3,002);
insert into RESERVABLE values(4,003);
insert into RESERVABLE values(4,004);
insert into RESERVABLE values(5,000);

insert into RESERVATION values(000,01,'2022-06-25',10,2,16);
insert into RESERVATION values(001,02,'2022-06-24',10,3,16);
insert into RESERVATION values(002,03,'2022-06-23',11,2,16);
insert into RESERVATION values(003,04,'2022-06-25',14,2,16);
insert into RESERVATION values(004,04,'2022-06-22',7,2,16);
insert into RESERVATION values(000,05,'2022-06-21',22,1,16);
insert into RESERVATION values(001,02,'2022-06-21',18,3,16);
insert into RESERVATION values(002,02,'2022-06-25',18,4,16);
insert into RESERVATION values(003,03,'2022-06-29',10,2,16);
insert into RESERVATION values(004,01,'2022-06-25',4,1,16);
insert into RESERVATION values(000,03,'2022-06-25',11,2,24);
