DROP SCHEMA IF EXISTS echecs CASCADE;

CREATE SCHEMA echecs;

CREATE TABLE echecs.cadence (
	id_cadence    INT         PRIMARY KEY,
	nom           VARCHAR(10) NOT NULL,
	description   VARCHAR(50)
);


CREATE TABLE echecs.titre (
	code          CHAR(3)      PRIMARY KEY,
	nom           VARCHAR(50)  NOT NULL,
	description   VARCHAR(100)
);


CREATE TABLE echecs.resultat_partie (
	id_resultat  INT         PRIMARY KEY,
	resultat     VARCHAR(10) NOT NULL,
	description  VARCHAR(50)
);


CREATE TABLE echecs.ouverture (
	id_ouverture INT          PRIMARY KEY,
	eco          CHAR(3)      NOT NULL,
	nom          VARCHAR(50)  NOT NULL,
	coups        VARCHAR(50)
);


CREATE TABLE echecs.club (
	id_club        INT  PRIMARY KEY,
	nom            VARCHAR(100) NOT NULL,
	ville          VARCHAR(100),
	id_presidente  INT
);

CREATE TABLE echecs.joueuse (
	id_joueuse      INT PRIMARY KEY,
	code_titre      CHAR(3),
	nom             VARCHAR(100) NOT NULL,
	prenom          VARCHAR(100) NOT NULL,
	elo             INT NOT NULL,
	date_naissance  DATE,
	id_club         INT,
	arbitre         BOOL
);

ALTER TABLE echecs.joueuse ADD CONSTRAINT fk_joueuse_titre FOREIGN KEY (code_titre) REFERENCES echecs.titre(code);
ALTER TABLE echecs.joueuse ADD CONSTRAINT fk_joueuse_club FOREIGN KEY (id_club) REFERENCES echecs.club(id_club);

ALTER TABLE echecs.club ADD CONSTRAINT fk_club_presidente FOREIGN KEY (id_presidente) REFERENCES echecs.joueuse(id_joueuse);


CREATE TABLE echecs.tournoi (
	id_tournoi        INT PRIMARY KEY,
	nom               VARCHAR(100) NOT NULL,
	ville             VARCHAR(100),
	date_debut        DATE,
	date_fin          DATE,
	id_cadence        INT,
	nb_rondes         INT,
	nb_participantes  INT,
	id_arbitre        INT 
);

ALTER TABLE echecs.tournoi ADD CONSTRAINT fk_tournoi_cadence FOREIGN KEY (id_cadence) REFERENCES echecs.cadence(id_cadence);
ALTER TABLE echecs.tournoi ADD CONSTRAINT fk_tournoi_arbitre FOREIGN KEY (id_arbitre) REFERENCES echecs.joueuse(id_joueuse);


CREATE TABLE echecs.partie (
	id_partie       INT PRIMARY KEY,
	id_blanc        INT NOT NULL,
	id_noir         INT NOT NULL,
	date_partie     DATE ,
	id_resultat     INT NOT NULL,
	id_ouverture    INT,
	id_tournoi      INT
);


ALTER TABLE echecs.partie ADD CONSTRAINT fk_partie_blanc FOREIGN KEY (id_blanc) REFERENCES echecs.joueuse(id_joueuse);
ALTER TABLE echecs.partie ADD CONSTRAINT fk_partie_noir FOREIGN KEY (id_noir) REFERENCES echecs.joueuse(id_joueuse);
ALTER TABLE echecs.partie ADD CONSTRAINT fk_partie_ouverture FOREIGN KEY (id_ouverture) REFERENCES echecs.ouverture(id_ouverture);
ALTER TABLE echecs.partie ADD CONSTRAINT fk_partie_resultat FOREIGN KEY (id_resultat) REFERENCES echecs.resultat_partie(id_resultat);
ALTER TABLE echecs.partie ADD CONSTRAINT fk_partie_tournoi FOREIGN KEY (id_tournoi) REFERENCES echecs.tournoi(id_tournoi);



