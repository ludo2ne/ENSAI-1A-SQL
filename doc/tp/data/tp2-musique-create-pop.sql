--
-- Suppression du schéma et des tables
--

DROP SCHEMA IF EXISTS musique CASCADE;

CREATE SCHEMA musique;

--
-- Structure de la table adherent
--
CREATE TABLE musique.adherent_ecole (
    num_adherent     INT  PRIMARY KEY,
    nom_adherent     TEXT NOT NULL,
    adresse_adherent TEXT);

--
-- Contenu de la table ADHERENT_ECOLE
--

INSERT INTO musique.adherent_ecole VALUES
    (15, 'DUPONT', 'Bruz'),
    (12, 'DUCHEMIN', 'Rennes'),
    (13, 'MARTIN', 'Bruz'),
    (14, 'DURAND', 'Rennes'),
    (16, 'DUPONT', 'Nantes'),
    (17, 'Dupont', 'Bruz');

-- --------------------------------------------------------

--
-- Structure de la table cours
--


CREATE TABLE musique.cours (
	 num_cours     INT PRIMARY KEY,
	 nom_cours     TEXT,
	 horaire_cours TEXT);

--
-- Contenu de la table COURS
--

INSERT INTO musique.cours VALUES
    (1, 'Flute traversière niveau 1', 'samedi 10 heures'),
    (2, 'Flute traversière niveau 2', 'samedi 12 heures'),
    (3, 'Violon niveau 1', 'lundi 18 heures'),
    (4, 'Violon niveau 2', 'mardi 18 heures'),
    (5, 'Violon niveau 3', 'jeudi 20 heures'),
    (6, 'Piano niveau 1', 'jeudi 18 heures'),
    (7, 'Piano niveau 2', 'mardi 20 heures'),
    (8, 'Piano niveau 3', 'vendredi 20 heures'),
    (9, 'Guitare électrique débutant', 'samedi 14 heures'),
    (10, 'Guitare électrique perfectionnement', 'samedi 16 heures'),
    (11, 'GUIT-CLASS', 'mercredi 10 heures'),
    (12, 'GUIT-CLASS', 'mercredi 14 heures');

-- --------------------------------------------------------

--
-- Structure de la table instrument
--

CREATE TABLE musique.instrument (
    num_instrument INT PRIMARY KEY,
    nom_instrument TEXT);

--
-- Contenu de la table instrument
--

INSERT INTO musique.instrument VALUES
    (1, 'Guitare électrique'),
    (2, 'Guitare classique'),
    (3, 'Piano'),
    (4, 'Violon'),
    (5, 'Harpe');

-- --------------------------------------------------------

--
-- Structure de la table JOUE
--


CREATE TABLE musique.joue (
    num_adherent   INT REFERENCES musique.adherent_ecole(num_adherent),
    num_instrument INT REFERENCES musique.instrument(num_instrument),
    PRIMARY KEY (num_adherent, num_instrument));

--
-- Contenu de la table JOUE
--

INSERT INTO musique.joue VALUES
    (12, 3),
    (12, 4),
    (13, 4),
    (14, 1),
    (14, 4),
    (15, 1),
    (15, 2),
    (16, 3),
    (16, 5);

-- --------------------------------------------------------

--
-- Structure de la table SUIT_COURS
--


CREATE TABLE musique.suit_cours (
    num_adherent INT REFERENCES musique.adherent_ecole(num_adherent),
    num_cours    INT REFERENCES musique.cours(num_cours),
    PRIMARY KEY (num_adherent, num_cours));


--
-- Contenu de la table SUIT_COURS
--

INSERT INTO musique.suit_cours VALUES
    (12, 4),
    (12, 6),
    (12, 11),
    (13, 4),
    (14, 1),
    (14, 4),
    (14, 12),
    (15, 2),
    (15, 10),
    (15, 11),
    (16, 6);
