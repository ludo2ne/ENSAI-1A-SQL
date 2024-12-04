----------------------------------------------------------------------
-- Tricheuses Elo
----------------------------------------------------------------------

-- Joueuses par elo décroissant
SELECT *
  FROM echecs.joueuse
 ORDER BY elo DESC;


-- Joueuses avec elo suspect
SELECT *
  FROM echecs.joueuse
 WHERE elo > 2600
   AND code_titre IS NULL;


-- Maj des elo suspects
UPDATE echecs.joueuse
   SET elo = elo - 1200
 WHERE elo > 2600
   AND code_titre IS NULL;

-- Verif de la maj
SELECT *
  FROM echecs.joueuse
 ORDER BY 1 DESC;


----------------------------------------------------------------------
-- Dates naissance
----------------------------------------------------------------------

-- Nombre de joueuses nées par année
SELECT EXTRACT(YEAR FROM date_naissance) AS annee_naissance,
       COUNT(1)
  FROM echecs.joueuse
 GROUP BY annee_naissance
 ORDER BY annee_naissance;


-- Années suspectes
SELECT *
  FROM echecs.joueuse
 WHERE EXTRACT(YEAR FROM date_naissance) NOT BETWEEN 1930 AND 2030;

-- Correction
UPDATE echecs.joueuse
   SET date_naissance = date_naissance + INTERVAL '100 years'
 WHERE id_joueuse IN (111, 122, 133, 144);

UPDATE echecs.joueuse
   SET date_naissance = date_naissance - INTERVAL '100 years'
 WHERE id_joueuse IN (155, 166, 177, 188);


----------------------------------------------------------------------
-- Anonymisation
----------------------------------------------------------------------

SELECT *
  FROM echecs.joueuse;


-- tentative pour casser l'anonymat
SELECT REPLACE(REPLACE(REPLACE(nom, 'EUH', 'E'), 'AO', 'A'), 'OU', 'U')
  FROM echecs.joueuse
 WHERE code_titre IS NULL;


-- maj des noms des joueuse
UPDATE echecs.joueuse
   SET nom = REPLACE(REPLACE(REPLACE(nom, 'EUH', 'E'), 'AO', 'A'), 'OU', 'U')
 WHERE code_titre IS NULL;


----------------------------------------------------------------------
-- Parties louches
----------------------------------------------------------------------

-- parties contre soi-meme
SELECT *
  FROM echecs.partie
 WHERE id_blanc = id_noir;


-- table tricheuses
CREATE TABLE echecs.Tricheuse
AS
SELECT * 
  FROM echecs.joueuse
 WHERE id_joueuse IN(SELECT id_blanc
                       FROM echecs.partie
                      WHERE id_blanc = id_noir);


-- suppression des parties suspectes
DELETE FROM echecs.partie
 WHERE id_blanc = id_noir;



----------------------------------------------------------------------
-- Election des présidentes
----------------------------------------------------------------------

-- Joueuse par club
SELECT c.nom,
       j.*
  FROM echecs.club c
  JOIN echecs.joueuse j USING(id_club)
 ORDER BY 1;


-- Elo minimum par club
SELECT c.nom,
       MIN(j.elo) AS elo_min
  FROM echecs.club c
  JOIN echecs.joueuse j USING(id_club)
 GROUP BY c.nom
 ORDER BY 1;


-- Table temporaire pour stocker id_club et elo mini
CREATE TEMPORARY TABLE club_min_elo
AS
SELECT c.id_club,
       MIN(j.elo) AS elo_min
  FROM echecs.club c
  JOIN echecs.joueuse j USING(id_club)
 GROUP BY c.id_club;


-- Joueuse ayant le plus petit elo dans chaque club
SELECT j.id_club,
       j.*       
  FROM echecs.joueuse j
  JOIN club_min_elo cme ON (j.id_club = cme.id_club AND j.elo = cme.elo_min)
 ORDER BY 1;


-- en cas d'égalité, on choisit l'id joueuse min
CREATE TEMPORARY TABLE joueuse_presidente_club
AS 
SELECT MIN(j.id_joueuse) AS id_joueuse,
       j.id_club
  FROM echecs.joueuse j
  JOIN club_min_elo cme ON (j.id_club = cme.id_club AND j.elo = cme.elo_min)
 GROUP BY j.id_club;


-- Maj des présidentes de clubs
UPDATE echecs.club c
   SET id_presidente = id_joueuse
  FROM joueuse_presidente_club jpc
 WHERE c.id_club = jpc.id_club;


-- Affichage des présidentes
SELECT c.nom,
       CONCAT_WS(' ', p.nom, p.prenom, p.elo) AS presidente
  FROM echecs.club c
  JOIN echecs.joueuse p ON (p.id_joueuse = c.id_presidente);


----------------------------------------------------------------------
-- Statistiques sur les parties
----------------------------------------------------------------------

SELECT COUNT(*)
  FROM echecs.partie;


-- nombre de parties jouées par tournoi
SELECT t.nom AS tournoi,
       COUNT(*) AS nb_parties
  FROM echecs.partie p
  LEFT JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY t.nom;


-- Taux de victoire blanches, noires et matchs nuls
SELECT t.nom AS tournoi,
       COUNT(*) AS nb_parties,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 1) / COUNT(*), 2) AS tx_victoire_blancs,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*), 2) AS tx_match_nul,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 2) / COUNT(*), 2) AS tx_victoire_noirs
  FROM echecs.partie p
  LEFT JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY t.nom;


-- Taux de matchs nuls inférieur à 0.2
SELECT t.nom AS tournoi,
       COUNT(*) AS nb_parties,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 1) / COUNT(*), 2) AS tx_victoire_blancs,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*), 2) AS tx_match_nul,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 2) / COUNT(*), 2) AS tx_victoire_noirs
  FROM echecs.partie p
  LEFT JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY t.nom
HAVING ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*), 2) <= 0.2;


----------------------------------------------------------------------
-- Ouvertures
----------------------------------------------------------------------

SELECT *
  FROM echecs.ouverture o
 WHERE NOT EXISTS(SELECT 1
                    FROM echecs.partie p
                   WHERE p.id_ouverture = o.id_ouverture);


-- Suppression de la partie Bretonne
DELETE FROM echecs.ouverture
 WHERE nom = 'Partie Bretonne';


-- Stat sur les ouvertures
SELECT o.nom AS Ouverture,
       COUNT(*) AS nb_parties,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 1) / COUNT(*),2) AS tx_victoire_blancs,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*),2) AS tx_match_nul,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 2) / COUNT(*),2) AS tx_victoire_noirs
  FROM echecs.ouverture o
  JOIN echecs.partie p USING(id_ouverture)
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j1 ON p.id_blanc = j1.id_joueuse
  JOIN echecs.joueuse j2 ON p.id_noir = j2.id_joueuse
 GROUP BY o.nom;


-- Joueuses ayant joué la défense sicilienne plus de 5 fois avec les noirs
SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS noirs,
       COUNT(*) AS nb_parties
  FROM echecs.ouverture o
  JOIN echecs.partie p USING(id_ouverture)
  JOIN echecs.joueuse j ON p.id_noir = j.id_joueuse
 WHERE o.nom = 'Défense Sicilienne'
 GROUP BY 1
HAVING COUNT(1) > 5;


----------------------------------------------------------------------
-- Afficher les résultat de parties
----------------------------------------------------------------------

SELECT j1.code_titre,
       j1.nom,
       j1.prenom,
       j1.elo,
       rp.resultat,
       j2.code_titre,
       j2.nom,
       j2.prenom,
       j2.elo
  FROM echecs.joueuse j1
  JOIN echecs.partie p ON (p.id_blanc = j1.id_joueuse)
  JOIN echecs.joueuse j2 ON (p.id_noir = j2.id_joueuse)
  JOIN echecs.resultat_partie rp USING(id_resultat);


-- Affichage résultats parties joli
SELECT CONCAT_WS(' ', LOWER(j1.code_titre), j1.nom, j1.prenom) AS blancs,
       j1.elo,
       rp.resultat AS res,
       CONCAT_WS(' ', LOWER(j2.code_titre), j2.nom, j2.prenom) AS noirs,
       j2.elo
  FROM echecs.joueuse j1
  JOIN echecs.partie p ON (p.id_blanc = j1.id_joueuse)
  JOIN echecs.joueuse j2 ON (p.id_noir = j2.id_joueuse)
  JOIN echecs.resultat_partie rp USING(id_resultat);


-- Blitz à Rennes
SELECT CONCAT_WS(' ', LOWER(j1.code_titre), j1.nom, j1.prenom) AS blancs,
       j1.elo,
       rp.resultat AS res,
       CONCAT_WS(' ', LOWER(j2.code_titre), j2.nom, j2.prenom) AS noirs,
       j2.elo
  FROM echecs.joueuse j1
  JOIN echecs.partie p ON (p.id_blanc = j1.id_joueuse)
  JOIN echecs.joueuse j2 ON (p.id_noir = j2.id_joueuse)
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.tournoi t USING(id_tournoi)
 WHERE t.nom = 'Blitz à Rennes';


-- Performances
SELECT CONCAT_WS(' ', LOWER(j1.code_titre), j1.nom, j1.prenom) AS blancs,
       j1.elo,
       rp.resultat,
       j2.elo,
       CONCAT_WS(' ', LOWER(j2.code_titre), j2.nom, j2.prenom) AS noirs
  FROM echecs.joueuse j1
  JOIN echecs.partie p ON (p.id_blanc = j1.id_joueuse)
  JOIN echecs.joueuse j2 ON (p.id_noir = j2.id_joueuse)
  JOIN echecs.resultat_partie rp USING(id_resultat)
 WHERE (j1.elo > j2.elo + 400 AND rp.id_resultat = 2)
    OR (j1.elo < j2.elo - 400 AND rp.id_resultat = 1);


-- Performances classées par différence de elo
SELECT CONCAT_WS(' ', LOWER(j1.code_titre), j1.nom, j1.prenom) AS blancs,
       j1.elo,
       rp.resultat,
       j2.elo,
       CONCAT_WS(' ', LOWER(j2.code_titre), j2.nom, j2.prenom) AS noirs,
       ABS(j1.elo - j2.elo) AS difference_elo
  FROM echecs.joueuse j1
  JOIN echecs.partie p ON (p.id_blanc = j1.id_joueuse)
  JOIN echecs.joueuse j2 ON (p.id_noir = j2.id_joueuse)
  JOIN echecs.resultat_partie rp USING(id_resultat)
 WHERE (j1.elo > j2.elo + 400 AND rp.id_resultat = 2)
    OR (j1.elo < j2.elo - 400 AND rp.id_resultat = 1)
 ORDER BY difference_elo DESC;


----------------------------------------------------------------------
-- Gagnantes de tournoi
----------------------------------------------------------------------

SELECT DISTINCT t.*
  FROM echecs.partie p
  JOIN echecs.joueuse j ON (p.id_blanc = j.id_joueuse OR p.id_noir = j.id_joueuse)
  JOIN echecs.tournoi t USING(id_tournoi)
 WHERE j.nom = 'HOU';

-- Création de la vue participante
CREATE VIEW echecs.participante AS 
SELECT DISTINCT p.id_tournoi,
       p.id_blanc AS id_joueuse
  FROM echecs.partie p
 WHERE p.id_tournoi IS NOT NULL
UNION
SELECT DISTINCT p.id_tournoi,
       p.id_noir AS id_joueuse
  FROM echecs.partie p
 WHERE p.id_tournoi IS NOT NULL;


-- Vérif
SELECT COUNT(1)
  FROM echecs.participante;


-- Score des blancs par partie
SELECT p.id_partie,
       p.id_blanc AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('1 - 0', '1 - F') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat);


-- Score des blancs par partie avec id_tournoi et elo adversaire
SELECT p.id_partie,
       p.id_tournoi,
       p.id_blanc AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('1 - 0', '1 - F') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score,
       adv.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse adv ON adv.id_joueuse = p.id_noir;

-- Vue partie_score
CREATE VIEW echecs.partie_score
AS
SELECT p.id_partie,
       p.id_tournoi,
       p.id_blanc AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('1 - 0', '1 - F') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score,
       adv.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse adv ON adv.id_joueuse = p.id_noir
UNION
SELECT p.id_partie,
       p.id_tournoi,
       p.id_noir AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('0 - 1', 'F - 1') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score,
       adv.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse adv ON adv.id_joueuse = p.id_blanc;


-- Vérifications
SELECT DISTINCT SUM(score)
  FROM echecs.partie_score
 GROUP BY id_partie;

SELECT id_partie, SUM(score)
  FROM echecs.partie_score
 GROUP BY id_partie
HAVING SUM(score) <> 1;


-- Classement Guingamp
SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(ps.score) AS points,
       ROUND(AVG(ps.elo_adversaire)) AS moyenne_elo_adversaire
  FROM echecs.joueuse j
  JOIN echecs.partie_score ps USING(id_joueuse)
  JOIN echecs.tournoi t USING(id_tournoi)
 WHERE t.nom = 'Open de Guingamp'
 GROUP BY j.id_joueuse,
          joueuse,
          j.elo
 ORDER BY points DESC,
          moyenne_elo_adversaire DESC;


-- Classements de chaque tournoi
SELECT t.nom,
       CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(ps.score) AS points,
       ROUND(AVG(ps.elo_adversaire)) AS moyenne_elo_adversaire,
       RANK() OVER (PARTITION BY t.nom 
                        ORDER BY SUM(ps.score) DESC, 
                                 ROUND(AVG(ps.elo_adversaire)) DESC
       ) AS classement
  FROM echecs.joueuse j
  JOIN echecs.partie_score ps USING(id_joueuse)
  JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY j.id_joueuse,
          joueuse,
          j.elo, 
          t.nom
 ORDER BY t.nom,
          classement;


-- Vue classement des tournois
CREATE VIEW echecs.classement_tournoi
AS
SELECT t.nom,
       CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(ps.score) AS points,
       ROUND(AVG(ps.elo_adversaire)) AS moyenne_elo_adversaire,
       RANK() OVER (PARTITION BY t.nom 
                        ORDER BY SUM(ps.score) DESC, 
                                 ROUND(AVG(ps.elo_adversaire)) DESC
       ) AS classement
  FROM echecs.joueuse j
  JOIN echecs.partie_score ps USING(id_joueuse)
  JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY j.id_joueuse,
          joueuse,
          j.elo, 
          t.nom
 ORDER BY t.nom,
          classement;


-- Victorieuses de chaque tournoi
SELECT nom,
       joueuse,
       elo,
       points
  FROM echecs.classement_tournoi
 WHERE classement = 1;


----------------------------------------------------------------------
-- Qui est la meilleure ?
----------------------------------------------------------------------

SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(score) AS points,
       COUNT(1) AS parties
  FROM echecs.partie_score rp
  JOIN echecs.joueuse j USING(id_joueuse)
 WHERE j.nom = 'POLGAR'
 GROUP BY 1, 2;


-- Ratio de points de Judith POLGAR
SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(score) AS points,
       COUNT(1) AS parties,
       ROUND(SUM(score) / COUNT(1), 2) As ratio_points
  FROM echecs.partie_score rp
  JOIN echecs.joueuse j USING(id_joueuse)
 WHERE j.nom = 'POLGAR'
 GROUP BY 1, 2;


-- Taux de victoire de Judith POLGAR
 SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(score) AS points,
       COUNT(1) AS parties,
       ROUND(SUM(score) / COUNT(1), 2) AS ratio_points,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 1) / COUNT(1), 2) AS tx_victoires,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 0.5) / COUNT(1), 2) AS tx_matchs_nuls,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 0) / COUNT(1), 2) AS tx_defaites
  FROM echecs.partie_score rp
  JOIN echecs.joueuse j USING(id_joueuse)
 WHERE j.nom = 'POLGAR'
 GROUP BY 1, 2;


-- Taux de victoire, nuls et défaites pour tous
SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       j.elo,
       SUM(score) AS points,
       COUNT(1) AS parties,
       ROUND(SUM(score) / COUNT(1), 2) AS ratio_points,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 1) / COUNT(1), 2) AS tx_victoires,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 0.5) / COUNT(1), 2) AS tx_matchs_nuls,
       ROUND(1.0 * COUNT(1) FILTER (WHERE score = 0) / COUNT(1), 2) AS tx_defaites
  FROM echecs.partie_score rp
  JOIN echecs.joueuse j USING(id_joueuse)
GROUP BY 1, 2
ORDER BY SUM(score) / COUNT(1) DESC;
