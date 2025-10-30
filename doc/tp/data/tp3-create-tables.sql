

DROP SCHEMA IF EXISTS music CASCADE;

CREATE SCHEMA music;

SET search_path TO music;

CREATE TABLE artiste (
    id_artiste SERIAL PRIMARY KEY,
    nom        VARCHAR(100) NOT NULL,
    code_pays  CHAR(2),
    date_naissance DATE,
    actif BOOLEAN,
    groupe BOOLEAN
);


CREATE TABLE album (
    id_album SERIAL PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    annee SMALLINT,
    id_artiste INT NOT NULL,
    CONSTRAINT fk_album_artiste FOREIGN KEY (id_artiste) REFERENCES artiste(id_artiste)
);


CREATE TABLE chanson (
    id_chanson SERIAL PRIMARY KEY,
    id_artiste_principal INT NOT NULL,
    titre VARCHAR(150) NOT NULL,
    duree TIME,
    id_album INT,
    annee SMALLINT,
    FOREIGN KEY (id_artiste_principal) REFERENCES artiste(id_artiste),
    FOREIGN KEY (id_album) REFERENCES album(id_album)
);

CREATE TABLE playlist (
    id_playlist SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    date_creation DATE DEFAULT CURRENT_DATE,
    description TEXT
);

CREATE TABLE artiste_chanson (
    id_artiste INT NOT NULL,
    id_chanson INT NOT NULL,
    PRIMARY KEY (id_artiste, id_chanson),
    CONSTRAINT fk_am_artiste FOREIGN KEY (id_artiste) REFERENCES artiste(id_artiste),
    CONSTRAINT fk_am_chanson FOREIGN KEY (id_chanson) REFERENCES chanson(id_chanson)
);

CREATE TABLE playlist_chanson (
    id_playlist INT NOT NULL,
    id_chanson INT NOT NULL,
    ordre INT CHECK (ordre > 0),
    date_ajout DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_playlist, id_chanson),
    CONSTRAINT fk_pm_playlist  FOREIGN KEY (id_playlist)  REFERENCES playlist(id_playlist),
    CONSTRAINT fk_pm_chanson FOREIGN KEY (id_chanson) REFERENCES chanson(id_chanson)
);
