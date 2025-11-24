-- Listez toutes les chansons
SELECT *
  FROM music.chanson;


-- Listez les chansons (titre, année) ainsi que le nom de l'artiste
SELECT c.titre,
       c.annee,
       a.nom
  FROM music.chanson c
  JOIN music.artiste a ON c.id_artiste_principal = a.id_artiste
 ORDER BY a.nom, c.titre;


-- Ajoutez le titre de l'album si celui-ci est précisé
SELECT c.titre,
       c.annee,
       ar.nom   AS nom_artiste,
       al.titre AS titre_album
  FROM music.chanson c
  JOIN music.artiste ar ON c.id_artiste_principal = ar.id_artiste
  LEFT JOIN music.album al USING(id_album)
 ORDER BY ar.nom, c.titre;


-- Vérifiez s il y a dans un album des chansons dont l'artiste principal n'est pas l'artiste de l'album
SELECT c.titre,
       c.annee,
       ar.nom   AS nom_artiste,
       al.titre AS titre_album,
       aral.nom AS artiste_album
  FROM music.chanson c
  JOIN music.artiste ar ON c.id_artiste_principal = ar.id_artiste
  LEFT JOIN music.album al USING(id_album)
  LEFT JOIN music.artiste aral ON al.id_artiste = aral.id_artiste
 WHERE c.id_artiste_principal <> aral.id_artiste
 ORDER BY ar.nom, c.titre;


-- Durées minimum, maximum et moyenne des chansons
SELECT MIN(duree),
       MAX(duree),
       AVG(duree)
  FROM music.chanson;


-- Nombre de chansons par année
SELECT annee, 
       COUNT(*) AS nb_chansons
  FROM music.chanson
 GROUP BY annee
 ORDER BY nb_chansons DESC;


 -- Années avec un nombre de chansons supérieur ou égal à 10
SELECT annee, 
       COUNT(*) AS nb_chansons
  FROM music.chanson
 GROUP BY annee
HAVING COUNT(*) >= 10;


-- Durée moyenne des chansons par année (années avec au moins 10 chansons)
SELECT annee,
       AVG(duree),
       DATE_TRUNC('second', AVG(duree)) AS duree_moyenne -- Format HH:MM:SS
  FROM music.chanson
 GROUP BY annee
HAVING COUNT(*) >= 10
 ORDER BY AVG(duree) DESC;


-- Chansons avec le même titre
SELECT titre, 
       COUNT(*) AS nb_occurrences
  FROM music.chanson
 GROUP BY titre
HAVING COUNT(*) >= 2;


-- Chansons en doublon : même titre, même artiste
SELECT c.titre, 
       a.nom AS artiste, 
       COUNT(*) AS nb_occurrences
  FROM music.chanson c
  JOIN music.artiste a ON c.id_artiste_principal = a.id_artiste
 GROUP BY c.titre, 
          a.nom
HAVING COUNT(*) > 1;


-- Vue titre frequents
--DROP VIEW music.titre_frequent;
CREATE VIEW music.titre_frequent
AS
SELECT titre
  FROM music.chanson
 GROUP BY titre
HAVING COUNT(*) >= 2;

-- Nom artiste et titres frequents
SELECT a.nom AS nom_artiste,
       c.*
  FROM music.titre_frequent tf
  JOIN music.chanson c USING(titre)
  JOIN music.artiste a ON c.id_artiste_principal = a.id_artiste
 ORDER BY c.titre;  


--------------------------------------------------------------
-- Place aux artistes
--------------------------------------------------------------

-- Listez les noms d'artistes ainsi que les titres de leurs chansons
SELECT a.nom, 
       c.titre
  FROM music.artiste a
  JOIN music.chanson c ON a.id_artiste = c.id_artiste_principal
  ORDER BY a.nom, 
           c.titre;


-- Comptez le nombre de chansons par artiste
SELECT a.nom, 
       COUNT(*) AS nb_chansons
  FROM music.artiste a
  JOIN music.chanson c ON a.id_artiste = c.id_artiste_principal
 GROUP BY a.nom
 ORDER BY nb_chansons DESC;


-- Comptez le nombre de chansons par artiste 20 chansons ou plus
SELECT a.nom, 
       COUNT(*) AS nb_chansons
  FROM music.artiste a
  JOIN music.chanson c ON a.id_artiste = c.id_artiste_principal
 GROUP BY a.nom
HAVING COUNT(*) >= 20
 ORDER BY nb_chansons DESC;


-- Supprimer les dates de naissance des groupes
UPDATE music.artiste
   SET date_naissance = NULL
 WHERE groupe;


-- Plus viel artiste solo en activite
SELECT nom,
       date_naissance,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_naissance)) AS age_en_annees
  FROM music.artiste a
 WHERE actif
   AND NOT groupe
   AND date_naissance IS NOT NULL
 ORDER BY date_naissance ASC
 LIMIT 1;


-- Comptez le nombre d'artistes par pays
SELECT code_pays, 
       COUNT(*) AS nb_artistes
  FROM music.artiste
 GROUP BY code_pays
 ORDER BY nb_artistes DESC;


--------------------------------------------------------------
-- Créez votre playlist
--------------------------------------------------------------

-- Création d'une nouvelle playlist
INSERT INTO playlist (nom, date_creation, description)
VALUES ('Ma Super Playlist', CURRENT_DATE, 'Mes chansons préférées.');


-- Ajout de 5 chansons à la dernière playlist créée
INSERT INTO playlist_chanson (id_playlist, id_chanson, ordre, date_ajout)
VALUES
    (CURRVAL('playlist_id_playlist_seq'), 822, 1, CURRENT_DATE),
    (CURRVAL('playlist_id_playlist_seq'), 570, 2, CURRENT_DATE),
    (CURRVAL('playlist_id_playlist_seq'), 820, 3, CURRENT_DATE),
    (CURRVAL('playlist_id_playlist_seq'), 459, 4, CURRENT_DATE),
    (CURRVAL('playlist_id_playlist_seq'), 464, 5, CURRENT_DATE);


-- Créez une séquence nommée seq_playlist_ordre
CREATE SEQUENCE seq_playlist_ordre START 6;


-- Chansons de l'album Californian Soil
SELECT c.*
  FROM music.album a
  JOIN music.chanson c USING(id_album)
 WHERE a.titre = 'Californian Soil';


-- Insérer toutes les chansons de l'album California Soil dans la playlist
INSERT INTO playlist_chanson (id_playlist, id_chanson, ordre, date_ajout)
SELECT CURRVAL('playlist_id_playlist_seq'),
       c.id_chanson,
       nextval('seq_playlist_ordre'),
       CURRENT_DATE
  FROM music.chanson c
  JOIN music.album a USING(id_album)
 WHERE a.titre = 'Californian Soil'
 ORDER BY c.id_chanson;


-- Est-ce que vous pouvez ajouter plusieurs fois la même chanson dans une playlist
-- Non car le couple (id_playlist, id_chanson) est la clé primaire de la table playlist_chanson
-- Il ne peut donc pas y avoir de doublons
-- Solutions possibles :
--   - ajouter, ordre à la clé primaire
--   - créer / utiliser une autre clé primaire


--------------------------------------------------------------
-- Playlists
--------------------------------------------------------------

-- Affichez les playlists
SELECT *
  FROM music.playlist p;


-- Ajoutez les titres des chansons
SELECT p.nom,
       pc.ordre,
       c.titre
  FROM music.playlist p
  JOIN music.playlist_chanson pc USING(id_playlist)
  JOIN music.chanson c USING (id_chanson)
 ORDER BY 1, 2;


-- Ajoutez les noms des artistes
SELECT p.nom,
       pc.ordre,
       c.titre,
       a.nom
  FROM music.playlist p
  JOIN music.playlist_chanson pc USING(id_playlist)
  JOIN music.chanson c USING (id_chanson)
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal
 ORDER BY 1, 2;


-- Affichage des noms de colonnes
SELECT p.nom   AS "Nom de la playlist",
       pc.ordre,
       a.nom   AS "Nom de l'artiste",
       c.titre AS "Titre de la chanson"
  FROM music.playlist p
  JOIN music.playlist_chanson pc USING(id_playlist)
  JOIN music.chanson c USING (id_chanson)
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal
 ORDER BY 1, 2;


-- Quelle playlist a le plus de chansons
SELECT p.nom, 
       COUNT(pc.id_chanson) AS nb_chansons
  FROM music.playlist p
  JOIN music.playlist_chanson pc USING(id_playlist)
 GROUP BY p.id_playlist, p.nom
 ORDER BY nb_chansons DESC;


-- Quelle playlist dure le plus longtemps
SELECT p.nom, 
       SUM(EXTRACT(EPOCH FROM c.duree)) AS duree_totale_secondes
  FROM music.playlist p
  JOIN music.playlist_chanson pc USING(id_playlist)
  JOIN music.chanson c USING(id_chanson)
GROUP BY p.id_playlist, p.nom
ORDER BY duree_totale_secondes DESC;


-- Artistes présents dans les playlists
SELECT a.*
  FROM music.chanson c
  JOIN music.playlist_chanson pc USING(id_chanson)
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal;


-- Gardez uniquement les différents id_artiste
SELECT DISTINCT a.id_artiste
  FROM music.chanson c
  JOIN music.playlist_chanson pc USING(id_chanson)
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal;


-- NOT IN
SELECT a.*
  FROM music.artiste a
WHERE a.id_artiste NOT IN (
    SELECT DISTINCT c.id_artiste_principal
      FROM music.playlist_chanson pc
      JOIN music.chanson c ON pc.id_chanson = c.id_chanson
);


-- NOT EXISTS
SELECT a.*
  FROM music.artiste a
WHERE NOT EXISTS (
    SELECT 1
      FROM music.chanson c
      JOIN music.playlist_chanson pc ON pc.id_chanson = c.id_chanson
     WHERE c.id_artiste_principal = a.id_artiste
);


-- Combien de fois chaque chanson apparait dans une playlist
SELECT a.nom, 
       c.titre, 
       COUNT(pc.id_playlist) AS nb_playlists
  FROM music.chanson c
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal
  JOIN music.playlist_chanson pc USING(id_chanson)
 GROUP BY a.nom, 
          c.titre
ORDER BY nb_playlists DESC;


-- Avec LEFT JOIN
SELECT a.nom, 
       c.titre, 
       COUNT(pc.id_playlist) AS nb_playlists
  FROM music.chanson c
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal
  LEFT JOIN music.playlist_chanson pc USING(id_chanson)
 GROUP BY a.nom, 
          c.titre
ORDER BY nb_playlists DESC;


-- Chansons présentes dans au moins 3 playlists
SELECT a.nom, 
       c.titre, 
       COUNT(pc.id_playlist) AS nb_playlists
  FROM music.chanson c
  JOIN music.artiste a ON a.id_artiste = c.id_artiste_principal
  LEFT JOIN music.playlist_chanson pc USING(id_chanson)
 GROUP BY a.nom, 
          c.titre
HAVING COUNT(pc.id_playlist) >= 3
ORDER BY nb_playlists DESC;


-- Combien y a-t-il de chansons dans toutes les playlists
SELECT COUNT(*) AS total_chansons
  FROM music.playlist_chanson;


-- Combien y a-t-il de chansons différentes dans toutes les playlists
SELECT COUNT(DISTINCT id_chanson) AS total_chansons_uniques
  FROM music.playlist_chanson;

--------------------------------------------------------------
-- I'm WITH u
--------------------------------------------------------------

-- Elle liste pour chaque pays l artiste solo le plus vieux
SELECT DISTINCT ON (code_pays) code_pays, 
       nom, 
       date_naissance
  FROM music.artiste
 WHERE NOT groupe
 ORDER BY code_pays, 
          date_naissance ASC;


-- Listez les artistes qui ne sont pas des groupes
SELECT *
  FROM music.artiste
 WHERE NOT groupe;


-- Affichez pour chaque pays, la plus ancienne date de naissance 
SELECT code_pays, 
       MIN(date_naissance)
  FROM music.artiste
 WHERE NOT groupe
 GROUP BY code_pays;


-- WITH
WITH viel_artiste_pays AS (
SELECT code_pays, 
       MIN(date_naissance) AS date_min
  FROM music.artiste
 WHERE NOT groupe
 GROUP BY code_pays
)
SELECT a.code_pays, 
       a.nom, 
       a.date_naissance
  FROM music.artiste a
  JOIN viel_artiste_pays pv ON a.code_pays = pv.code_pays AND a.date_naissance = pv.date_min
 ORDER BY a.code_pays;
