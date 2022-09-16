DROP TABLE RESERVATION;
DROP TABLE RESERVABLE;
DROP TABLE OCCUPANT;
DROP TABLE LETYPE;
DROP TABLE SALLE;

CREATE TABLE LETYPE(
    idT int(3),
    letype varchar(20) UNIQUE,
    PRIMARY KEY(idT)
);

CREATE TABLE OCCUPANT(idO int(3), nomO varchar(20), caracteristique varchar(20),idT int(3), PRIMARY KEY(idO));

CREATE TABLE SALLE(
    idS int(3),
    nomS varchar(20) UNIQUE,
    capacite int(3),
    PRIMARY KEY(idS)
);

CREATE TABLE RESERVATION(
    idS int(3),
    idO int(3),
    ladate DATE,
    heure int(2) check (heure between 0 and 23),
    duree int(2),
    nbpers int(3) not null,
    PRIMARY KEY(idS,idO,ladate,heure),
    check (heure + duree <= 24)
);

CREATE TABLE RESERVABLE(
    idT int(3),
    idS int(3),
    PRIMARY KEY(idT,idS)
);

ALTER TABLE OCCUPANT ADD FOREIGN KEY (idT) REFERENCES LETYPE(idT); 
ALTER TABLE RESERVATION ADD FOREIGN KEY (idO) REFERENCES OCCUPANT(idO); 
ALTER TABLE RESERVATION ADD FOREIGN KEY (idS) REFERENCES SALLE(idS); 
ALTER TABLE RESERVABLE ADD FOREIGN KEY (idT) REFERENCES LETYPE(idT); 
ALTER TABLE RESERVABLE ADD FOREIGN KEY (idS) REFERENCES SALLE(idS); 