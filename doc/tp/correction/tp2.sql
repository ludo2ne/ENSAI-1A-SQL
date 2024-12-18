---------------------------------------------------------------
-- Ecole de musique
---------------------------------------------------------------

-- Noms des instruments
SELECT nom_instrument
  FROM musique.instrument;


-- Noms et adresses des adhérents
SELECT nom_adherent,
       adresse_adherent
  FROM musique.adherent_ecole;


-- Adresse de l'adhérent numéro 15
SELECT adresse_adherent
  FROM musique.adherent_ecole 
 WHERE num_adherent = 15;


-- Numéros des adhérents de nom "DUPONT"
SELECT num_adherent
  FROM musique.adherent_ecole 
 WHERE UPPER(nom_adherent) = 'DUPONT';


-- Nom des instruments dont joue chaque adhérent
SELECT ae.*,
       i.nom_instrument
  FROM musique.instrument i
  JOIN musique.joue j USING (num_instrument)
  JOIN musique.adherent_ecole ae USING (num_adherent);


-- Nom des adhérents inscrits au cours numéro 6
SELECT ae.nom_adherent
  FROM musique.adherent_ecole ae
  JOIN musique.suit_cours sc ON ae.num_adherent = sc.num_adherent 
   AND sc.num_cours = 6;


-- Cours du Samedi et nom des adhérents inscrits
SELECT c.nom_cours,
       ae.nom_adherent
  FROM musique.adherent_ecole ae
  JOIN musique.suit_cours sc USING(num_adherent) 
  JOIN musique.cours c USING(num_cours)
 WHERE horaire_cours LIKE '%samedi%';



-- Quels sont les cours auxquels sont inscrits les adhérents qui jouent du piano
-- Remarque : pas besoin de passer par la table adherent_ecole
SELECT DISTINCT c.nom_cours
  FROM musique.instrument i
  JOIN musique.joue j USING(num_instrument)
  JOIN musique.suit_cours sc USING(num_adherent)
  JOIN musique.cours c USING(num_cours)
 WHERE UPPER(i.nom_instrument) = 'PIANO';

      
-- De quels instruments jouent les personnes inscrites au cours de guitare classique ?
SELECT DISTINCT i.nom_instrument
  FROM musique.instrument i
  JOIN musique.joue j USING(num_instrument)
  JOIN musique.suit_cours sc USING(num_adherent)
  JOIN musique.cours c USING(num_cours)
WHERE UPPER(c.nom_cours) = 'GUIT-CLASS';




---------------------------------------------------------------
-- Location de dvd
---------------------------------------------------------------

-- Création des tables
CREATE TABLE dvd.adherent (
    num_adherent     INT PRIMARY KEY,
    nom_adherent     TEXT,
    prenom_adherent  TEXT,
    adresse_adherent TEXT);

CREATE TABLE dvd.dvd (
    num_dvd        INT PRIMARY KEY,
    date_achat     DATE,
    montant_pret   NUMERIC(6, 2),
    num_film       INT REFERENCES dvd.film(num_film));

CREATE TABLE dvd.emprunte (
    num_emprunt    INT PRIMARY KEY,
    num_adherent   INT REFERENCES dvd.adherent(num_adherent),
    num_dvd        INT REFERENCES dvd.dvd(num_dvd),
    date_debut     DATE,
    date_fin       DATE);


-- Nom et prénom des adhérents
SELECT nom_adherent,
       prenom_adherent
  FROM dvd.adherent;


-- Titre des films de la base
SELECT titre
  FROM dvd.film;


-- Numéro d'adhérent de Pierre DUCHEMIN
SELECT num_adherent
  FROM dvd.adherent 
 WHERE UPPER(nom_adherent) = 'DUCHEMIN' 
   AND UPPER(prenom_adherent) = 'PIERRE';


-- Nom, Prénom et adresse de tous les DUCHEMIN 
SELECT nom_adherent, 
       prenom_adherent, 
       adresse_adherent
  FROM dvd.adherent 
 WHERE UPPER(nom_adherent) = 'DUCHEMIN';


-- Numéro des DVD du film « la guerre des etoiles » 
SELECT d.num_dvd
  FROM dvd.dvd d
  JOIN dvd.film f USING(num_film)
WHERE LOWER(f.titre) = 'la guerre des etoiles';


-- Nom, Prénom des adhérents ayant emprunté le film "la guerre des etoiles"
SELECT DISTINCT CONCAT_WS(' ', a.nom_adherent, a.prenom_adherent) AS adherent
  FROM dvd.adherent a
  JOIN dvd.emprunte e USING(num_adherent)
  JOIN dvd.dvd d USING(num_DVD) 
  JOIN dvd.film f USING(num_film)
 WHERE LOWER(f.titre) = 'la guerre des etoiles';


-- Nom, Prénom des adhérents ayant au moins un emprunt en cours
SELECT DISTINCT CONCAT_WS(' ', a.nom_adherent, a.prenom_adherent) AS adherent       
  FROM dvd.adherent a
  JOIN dvd.emprunte e USING(num_adherent)
 WHERE e.date_fin IS NULL;


-- Nom, Prénom du réalisateur de la Guerre des étoiles
SELECT DISTINCT UPPER(r.nom_realisateur) || ' ' || r.prenom_realisateur  AS realisateur
  FROM dvd.realisateur r
  JOIN dvd.a_realise ar USING(num_realisateur) 
  JOIN dvd.film f USING(num_film)
 WHERE LOWER(f.titre) = 'la guerre des etoiles';


-- Titre des films empruntés par Pierre DUCHEMIN, ainsi que dates de début et de fin
SELECT f.titre,
       e.date_debut,
       e.date_fin
  FROM dvd.adherent a
  JOIN dvd.emprunte e USING(num_adherent)
  JOIN dvd.dvd d USING(num_dvd) 
  JOIN dvd.film f USING(num_film)
 WHERE UPPER(a.nom_adherent) = 'DUCHEMIN' 
   AND UPPER(a.prenom_adherent) = 'PIERRE';


-- Nom des réalisateurs des films empruntés par pierre DUCHEMIN
SELECT r.nom_realisateur
  FROM dvd.realisateur r
  JOIN dvd.a_realise ar USING(num_realisateur)
  JOIN dvd.dvd d USING(num_film)
  JOIN dvd.emprunte e USING(num_dvd)
  JOIN dvd.adherent a USING(num_adherent)
 WHERE UPPER(nom_adherent) = 'DUCHEMIN' 
   AND UPPER(prenom_adherent) = 'PIERRE';


-- Nom des réalisateurs de films de science fiction ou policiers
SELECT r.nom_realisateur
  FROM dvd.realisateur r
  JOIN dvd.a_realise ar USING(num_realisateur)
  JOIN dvd.film f USING(num_film)
 WHERE UPPER(f.genre) IN ('SCIENCE-FICTION', 'POLICIER');


-- Nombre de DVD dont le cout de l emprunt est inferieur ou egal a 2 euros
SELECT COUNT(*)
  FROM dvd.dvd
 WHERE montant_pret <= 2;
   
 
-- Nombre d'emprunts ayant été effectués par Dominique Duchemin.
SELECT COUNT(*)
  FROM dvd.adherent
  JOIN dvd.emprunte USING (num_adherent)
 WHERE UPPER(nom_adherent) = 'DUCHEMIN' 
   AND UPPER(prenom_adherent) = 'DOMINIQUE';
  
   
-- Nombre de films differents ayant ete empruntes par Dominique Duchemin
SELECT COUNT(DISTINCT num_film)
  FROM dvd.adherent
  JOIN dvd.emprunte USING (num_adherent)
  JOIN dvd.dvd USING (num_dvd)
  JOIN dvd.film USING (num_film)
 WHERE UPPER(nom_adherent) = 'DUCHEMIN' 
   AND UPPER(prenom_adherent) = 'DOMINIQUE';


-- Numéro des DVD en ordre décroissant du nombre de fois qu ils ont ete empruntes
SELECT num_dvd, 
       COUNT(*) AS nb_emprunts
  FROM dvd.emprunte
 GROUP BY num_dvd
 ORDER BY nb_emprunts DESC;

 
-- Numero du DVD le plus recemment achete
SELECT num_dvd
  FROM dvd.dvd
 WHERE date_achat = (SELECT MAX(date_achat) 
                       FROM dvd.dvd);

SELECT num_dvd
  FROM dvd.dvd
 ORDER BY date_achat DESC 
 LIMIT 1;

-- Durée d'emprunt la plus longue
SELECT MAX(date_fin - date_debut) AS duree_jours
  FROM dvd.emprunte e;

-- En date du 10 août 2010, combien de DVD sont en cours d'emprunt
SELECT f.titre
  FROM dvd.emprunte e
  JOIN dvd.dvd d USING(num_dvd)
  JOIN dvd.film f USING(num_film)
 WHERE '2010-08-10' BETWEEN date_debut and date_fin;

-- Combien de dvd ont été achetés chaque année
SELECT EXTRACT(YEAR FROM date_achat) AS annee_achat,
       COUNT(1)
  FROM dvd.dvd e
 GROUP BY annee_achat
 ORDER BY 1;



-- Numéros de films empruntés
SELECT DISTINCT d.num_film
  FROM dvd.dvd d
  JOIN emprunte e USING(num_dvd);


-- Titre des films ayant pour numéros 18, 19 ou 20
SELECT f.titre
  FROM dvd.film f
 WHERE num_film IN (18, 19, 20);

-- Titre des films n'ayant pas pour numéros 18, 19 ni 20
SELECT f.titre
  FROM dvd.film f
 WHERE num_film NOT IN (18, 19, 20);


-- Titre des films jamais empruntés
SELECT f.titre
  FROM dvd.film f
 WHERE num_film NOT IN (
    SELECT DISTINCT d.num_film
      FROM dvd.dvd d
      JOIN dvd.emprunte e USING(num_dvd));






---------------------------------------------------------------
-- Rugby
---------------------------------------------------------------

-- Équipes qui ont joué a Nantes
SELECT DISTINCT nom_equipe
  FROM rugby.equipe
  JOIN rugby.matches ON (num_equipe1 = num_equipe OR num_equipe2 = num_equipe)
 WHERE UPPER(lieu_match) = 'NANTES';


-- Contre quelles équipes a joué l'équipe de France
SELECT DISTINCT e.nom_equipe
  FROM rugby.equipe e
  JOIN rugby.matches m ON e.num_equipe = m.num_equipe1 OR e.num_equipe = m.num_equipe2
  JOIN rugby.equipe e_fr ON e_fr.num_equipe = m.num_equipe1 OR e_fr.num_equipe = m.num_equipe2
 WHERE e.nom_equipe <> 'France'
   AND e_fr.nom_equipe = 'France'

  
-- Afficher pour tous les matchs les informations suivantes : Date du match, Nom de la première équipe, nombre de points de la première équipe, nombre de points de la deuxième équipe, nom de la deuxième équipe et lieu du match.
SELECT m.date_match,
       e1.nom_equipe,
       m.nb_points_equipe1,
       m.nb_points_equipe2,
       e2.nom_equipe,
       m.lieu_match
FROM rugby.equipe e1
JOIN rugby.matches m ON e1.num_equipe = num_equipe1
JOIN rugby.equipe e2 ON e2.num_equipe = num_equipe2;
    
-- [Travail préparatoire] Créations de vues pour les requêtes suivantes
-- Pour répondre aux requêtes suivantes nous allons créer 3 vues contenant les informations pour chaque équipe.
-- Première vue : Numéro d'équipe et nombre de matchs effectués
-- Pour supprimer la vue : DROP VIEW equipe_nb_match;

CREATE OR REPLACE VIEW equipe_nb_match AS (
    SELECT num_equipe, COUNT(*) AS nb_matchs
    FROM (
        SELECT num_equipe1 as num_equipe
        FROM rugby.matches
        UNION ALL
        SELECT num_equipe2 AS num_equipe
        FROM rugby.matches) AS matchs_equipes
    GROUP BY num_equipe);

-- Contenu de la première vue
SELECT * FROM equipe_nb_match;

-- Deuxième vue : Numéro d'équipe et nombre de matchs perdus

CREATE OR REPLACE VIEW equipe_nb_match_perdus AS (
    SELECT num_equipe, COUNT(*) AS nb_defaites
    FROM (
        SELECT
            CASE
                WHEN nb_points_equipe1 < nb_points_equipe2 THEN
                    num_equipe1
                ELSE
                    num_equipe2
            END AS num_equipe
        FROM rugby.matches
        WHERE nb_points_equipe1 != nb_points_equipe2) AS matchs_perdus_equipes
    GROUP BY num_equipe);

-- Contenu de la deuxième vue
SELECT * FROM equipe_nb_match_perdus;

-- Troisième vue : Numéro d'équipe et nombre de matchs gagnés.

CREATE OR REPLACE VIEW equipe_nb_match_gagnes AS (
    SELECT num_equipe, COUNT(*) AS nb_victoires
    FROM (
        SELECT
            CASE
                WHEN nb_points_equipe1 < nb_points_equipe2 THEN
                    num_equipe2
                ELSE
                    num_equipe1
            END AS num_equipe
        FROM rugby.matches
        WHERE nb_points_equipe1 != nb_points_equipe2) AS matchs_gagnes_equipes
    GROUP BY num_equipe);

-- Contenu de la troisième vue
SELECT * FROM equipe_nb_match_gagnes;

-- Quatrième vue : Numéro d'équipe et nombre de matchs nuls.

CREATE OR REPLACE VIEW equipe_nb_match_nuls AS (
    SELECT num_equipe, COUNT(*) AS nb_nuls
    FROM (
        SELECT num_equipe1 as num_equipe
        FROM rugby.matches
        WHERE nb_points_equipe1 = nb_points_equipe2
        UNION ALL
        SELECT num_equipe2 AS num_equipe
        FROM rugby.matches
        WHERE nb_points_equipe1 = nb_points_equipe2) AS matchs_equipes
    GROUP BY num_equipe);

-- Contenu de la quatrieme vue
SELECT * FROM equipe_nb_match_nuls;



-- Quels sont les noms des équipes qui ont gagné au moins deux matchs ?
SELECT nom_equipe
  FROM rugby.equipe
  JOIN equipe_nb_match_gagnes USING (num_equipe)
 WHERE nb_victoires >= 2;


-- Quels sont les noms des équipes qui ont perdu tous leurs matchs
SELECT nom_equipe
  FROM rugby.equipe
 WHERE num_equipe NOT IN (SELECT num_equipe FROM equipe_nb_match_gagnes) 
   AND num_equipe NOT IN (SELECT num_equipe FROM equipe_nb_match_nuls);

-- Pour chaque équipe donner le nombre de matchs qu'elles ont gagnés ou perdus
SELECT nom_equipe,
       COALESCE(nb_victoires, 0) AS nb_victoires,
       COALESCE(nb_defaites, 0)  AS nb_defaites
  FROM rugby.equipe
  LEFT JOIN equipe_nb_match_perdus USING (num_equipe)
LEFT JOIN equipe_nb_match_gagnes USING (num_equipe);

-- Donner le nombre de points total obtenus par équipe en classant les équipes de celle ayant marqué le plus à celle ayant marqué le moins
SELECT nom_equipe, 
       SUM(nb_points) nb_points
  FROM (
    SELECT
        num_equipe1 AS num_equipe,
        SUM(nb_points_equipe1) AS nb_points
    FROM rugby.matches
    GROUP BY num_equipe
    UNION ALL
    SELECT
        num_equipe2 AS num_equipe,
        SUM(nb_points_equipe2) AS nb_points
    FROM rugby.matches
    GROUP BY num_equipe) AS points
  JOIN rugby.equipe  USING (num_equipe)
 GROUP BY nom_equipe, num_equipe
 ORDER BY nb_points DESC;
