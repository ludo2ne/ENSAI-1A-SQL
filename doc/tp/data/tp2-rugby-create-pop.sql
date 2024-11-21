DROP SCHEMA IF EXISTS rugby CASCADE;

CREATE SCHEMA rugby;

DROP TABLE IF EXISTS rugby.equipe;
DROP TABLE IF EXISTS rugby.matches;

CREATE TABLE rugby.equipe (
    num_equipe INT PRIMARY KEY,
    nom_equipe TEXT, 
    groupe     TEXT);

CREATE TABLE rugby.matches (
    num_match         INT PRIMARY KEY,
    num_equipe1       INT REFERENCES rugby.equipe,
    num_equipe2       INT REFERENCES rugby.equipe,
    nb_points_equipe1 INT,
    nb_points_equipe2 INT,
    date_match        DATE,
    lieu_match        TEXT);


INSERT INTO rugby.equipe VALUES (1,  'Afrique du sud', 'A');
INSERT INTO rugby.equipe VALUES (2,  'Angleterre', 'A');
INSERT INTO rugby.equipe VALUES (3,  'Argentine', 'D'); 
INSERT INTO rugby.equipe VALUES (4,  'Australie', 'B'); 
INSERT INTO rugby.equipe VALUES (5,  'Canada', 'B'); 
INSERT INTO rugby.equipe VALUES (6,  'Écosse', 'C'); 
INSERT INTO rugby.equipe VALUES (7,  'États-Unis', 'A'); 
INSERT INTO rugby.equipe VALUES (8,  'Fidji', 'B'); 
INSERT INTO rugby.equipe VALUES (9,  'France', 'D'); 
INSERT INTO rugby.equipe VALUES (10, 'Géorgie', 'D'); 
INSERT INTO rugby.equipe VALUES (11, 'Irlande', 'D'); 
INSERT INTO rugby.equipe VALUES (12, 'Italie', 'C'); 
INSERT INTO rugby.equipe VALUES (13, 'Japon', 'B'); 
INSERT INTO rugby.equipe VALUES (14, 'Namibie', 'D'); 
INSERT INTO rugby.equipe VALUES (15, 'Nouvelle-Zélande', 'C'); 
INSERT INTO rugby.equipe VALUES (16, 'Pays de Galles', 'B'); 
INSERT INTO rugby.equipe VALUES (17, 'Portugal', 'C');
INSERT INTO rugby.equipe VALUES (18, 'Roumanie', 'C'); 
INSERT INTO rugby.equipe VALUES (19, 'Samoa', 'A'); 
INSERT INTO rugby.equipe VALUES (20, 'Tonga', 'A'); 

CREATE SEQUENCE rugby.seq_match;

INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 9,  3,  12,  17, TO_DATE('07/09/2007', 'DD/MM/YYYY'), 'Saint-Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 2,  7,  28,  10, TO_DATE('08/09/2007', 'DD/MM/YYYY'), 'Lens');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 4,  13, 91,  3,  TO_DATE('08/09/2007', 'DD/MM/YYYY'), 'Lyon');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 15, 12, 76,  14, TO_DATE('08/09/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  19, 59,  7,  TO_DATE('09/09/2007', 'DD/MM/YYYY'), 'Paris');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 16, 5,  42,  17, TO_DATE('09/09/2007', 'DD/MM/YYYY'), 'Nantes');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 6,  17, 56,  10, TO_DATE('09/09/2007', 'DD/MM/YYYY'), 'Saint-Etienne');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 11, 14, 32,  17, TO_DATE('09/09/2007', 'DD/MM/YYYY'), 'Bordeaux');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 3,  10, 33,  3,  TO_DATE('11/09/2007', 'DD/MM/YYYY'), 'Lyon');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 7,  20, 15,  25, TO_DATE('12/09/2007', 'DD/MM/YYYY'), 'Montpellier');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 13, 8,  31,  35, TO_DATE('12/09/2007', 'DD/MM/YYYY'), 'Toulouse');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 12, 18, 24,  18, TO_DATE('12/09/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 2,  1,  0,   36, TO_DATE('14/09/2007', 'DD/MM/YYYY'), 'Saint-Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 15, 17, 108, 13, TO_DATE('15/09/2007', 'DD/MM/YYYY'), 'Lyon');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 11, 10, 32,  17, TO_DATE('15/09/2007', 'DD/MM/YYYY'), 'Bordeaux');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 19, 20, 15,  19, TO_DATE('16/09/2007', 'DD/MM/YYYY'), 'Montpellier');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 8,  5,  29,  16, TO_DATE('16/09/2007', 'DD/MM/YYYY'), 'Cardiff');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 9,  14, 87,  10, TO_DATE('16/09/2007', 'DD/MM/YYYY'), 'Toulouse');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 6,  18, 42,  0,  TO_DATE('18/09/2007', 'DD/MM/YYYY'), 'Edimbourg');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 12, 17, 31,  5,  TO_DATE('19/09/2007', 'DD/MM/YYYY'), 'Paris');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 16, 13, 72,  18, TO_DATE('20/09/2007', 'DD/MM/YYYY'), 'Cardiff');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 9,  11, 25,  3,  TO_DATE('21/09/2007', 'DD/MM/YYYY'), 'Saint-Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  20, 30,  25, TO_DATE('22/09/2007', 'DD/MM/YYYY'), 'Lens');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 2,  19, 44,  22, TO_DATE('22/09/2007', 'DD/MM/YYYY'), 'Nantes');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 4,  8,  55,  12, TO_DATE('23/09/2007', 'DD/MM/YYYY'), 'Montpellier');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 6,  15, 0,   40, TO_DATE('23/09/2007', 'DD/MM/YYYY'), 'Edimbourg');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 18, 17, 14,  10, TO_DATE('25/09/2007', 'DD/MM/YYYY'), 'Toulouse');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 16, 4,  20,  32, TO_DATE('15/09/2007', 'DD/MM/YYYY'), 'Cardif');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 3,  14, 63,  3,  TO_DATE('22/09/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 5,  13, 12,  12, TO_DATE('25/09/2007', 'DD/MM/YYYY'), 'Bordeaux');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 19, 7,  25,  21, TO_DATE('26/09/2007', 'DD/MM/YYYY'), 'Saint-Etienne');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 10, 14, 30,  0,  TO_DATE('26/09/2007', 'DD/MM/YYYY'), 'Lens');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 2,  20, 36,  20, TO_DATE('28/09/2007', 'DD/MM/YYYY'), 'Paris');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 4,  5,  37,  6,  TO_DATE('29/09/2007', 'DD/MM/YYYY'), 'Bordeaux');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 16, 8,  34,  38, TO_DATE('29/09/2007', 'DD/MM/YYYY'), 'Nantes');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 15, 18, 85,  8,  TO_DATE('29/09/2007', 'DD/MM/YYYY'), 'Toulouse');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 6,  12, 18,  16, TO_DATE('29/09/2007', 'DD/MM/YYYY'), 'Saint-Etienne');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  7,  64,  15, TO_DATE('30/09/2007', 'DD/MM/YYYY'), 'Montpellier');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 9,  10, 64,  7,  TO_DATE('30/09/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 11, 3,  15,  30, TO_DATE('30/09/2007', 'DD/MM/YYYY'), 'Paris');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 4,  2,  10,  12, TO_DATE('06/10/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 15, 9,  18,  20, TO_DATE('06/10/2007', 'DD/MM/YYYY'), 'Cardiff');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  8,  37,  20, TO_DATE('07/10/2007', 'DD/MM/YYYY'), 'Marseille');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 3,  6,  19,  13, TO_DATE('07/10/2007', 'DD/MM/YYYY'), 'Saint_Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 2,  9,  14,  9,  TO_DATE('13/10/2007', 'DD/MM/YYYY'), 'Saint_Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  3,  37,  13, TO_DATE('14/10/2007', 'DD/MM/YYYY'), 'Saint_Denis');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 9,  3,  10,  34, TO_DATE('19/10/2007', 'DD/MM/YYYY'), 'Paris');
INSERT INTO rugby.matches VALUES (NEXTVAL('rugby.seq_match'), 1,  2,  15,  6,  TO_DATE('20/10/2007', 'DD/MM/YYYY'), 'Saint_Denis');

SET SEARCH_PATH TO rugby, public;