----------------------------------------------------------------------
-- Tricheuses Elo
----------------------------------------------------------------------

SELECT *
  FROM echecs.joueuse
 ORDER BY elo DESC;

SELECT *
  FROM echecs.joueuse
 WHERE elo > 2600
   AND code_titre IS NULL;

UPDATE echecs.joueuse
   SET elo = elo - 1200
 WHERE elo > 2600
   AND code_titre IS NULL;

SELECT *
  FROM echecs.joueuse
 ORDER BY 1 DESC;


----------------------------------------------------------------------
-- Dates naissance
----------------------------------------------------------------------


SELECT EXTRACT(YEAR FROM date_naissance) AS annee_naissance,
       COUNT(1)
  FROM echecs.joueuse
 GROUP BY annee_naissance
 ORDER BY annee_naissance;

SELECT *
  FROM echecs.joueuse
 WHERE EXTRACT(YEAR FROM date_naissance) NOT BETWEEN 1930 AND 2030;

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
  FROM echecs.joueuse

SELECT REPLACE(REPLACE(REPLACE(nom, 'EUH', 'E'), 'AO', 'A'), 'OU', 'U')
  FROM echecs.joueuse
 WHERE code_titre IS NULL;

UPDATE echecs.joueuse
   SET nom = REPLACE(REPLACE(REPLACE(nom, 'EUH', 'E'), 'AO', 'A'), 'OU', 'U')
 WHERE code_titre IS NULL;


----------------------------------------------------------------------
-- Parties louches
----------------------------------------------------------------------

SELECT *
  FROM echecs.partie
 WHERE id_blanc = id_noir;

SELECT * 
  FROM echecs.joueuse
 WHERE id_joueuse IN(SELECT id_blanc
                       FROM echecs.partie
                      WHERE id_blanc = id_noir);

DELETE FROM echecs.partie
 WHERE id_blanc = id_noir;

----------------------------------------------------------------------
-- Statistiques sur les parties
----------------------------------------------------------------------

SELECT COUNT(*)
  FROM echecs.partie;


SELECT t.nom AS tournoi,
       COUNT(*) AS nb_parties,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 1) / COUNT(*),2) AS tx_victoire_blancs,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*),2) AS tx_match_nul,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 2) / COUNT(*),2) AS tx_victoire_noirs
  FROM echecs.partie p
  LEFT JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY t.nom;


SELECT t.nom AS tournoi,
       COUNT(*) AS nb_parties,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 1) / COUNT(*),2) AS tx_victoire_blancs,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*),2) AS tx_match_nul,
       ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 2) / COUNT(*),2) AS tx_victoire_noirs
  FROM echecs.partie p
  LEFT JOIN echecs.tournoi t USING(id_tournoi)
 GROUP BY t.nom
HAVING ROUND(1.0 * COUNT(*) FILTER (WHERE id_resultat = 3) / COUNT(*),2) <= 0.2;


----------------------------------------------------------------------
-- Ouvertures
----------------------------------------------------------------------

SELECT *
  FROM echecs.ouverture o
 WHERE NOT EXISTS(SELECT 1
                    FROM echecs.partie p
                   WHERE p.id_ouverture = o.id_ouverture);

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
SELECT CONCAT_WS(' ', LOWER(j2.code_titre), j2.nom, j2.prenom) AS noirs,
       COUNT(*) AS nb_parties
  FROM echecs.ouverture o
  JOIN echecs.partie p USING(id_ouverture)
  JOIN echecs.joueuse j2 ON p.id_noir = j2.id_joueuse
 WHERE o.nom = 'Défense Sicilienne'
 GROUP BY 1
HAVING COUNT(1) > 5;


----------------------------------------------------------------------
-- Afficher les résultat de parties
----------------------------------------------------------------------

SELECT j1.titre,
       j1.nom
       j1.prenom,
       j1.elo,
       rp.resultat,
       j2.titre,
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
CREATE OR REPLACE VIEW echecs.participante AS 
SELECT DISTINCT p.id_tournoi,
       p.id_blanc AS id_joueuse
  FROM echecs.partie p
 WHERE p.id_tournoi IS NOT NULL
UNION
SELECT DISTINCT p.id_tournoi,
       p.id_noir AS id_joueuse
  FROM echecs.partie p
 WHERE p.id_tournoi IS NOT NULL;

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

-- Score des blancs par partie
SELECT p.id_partie,
       p.id_tournoi,
       p.id_blanc AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('1 - 0', '1 - F') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score,
       j.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON j.id_joueuse = p.id_noir;

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
       j.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON j.id_joueuse = p.id_noir
UNION
SELECT p.id_partie,
       p.id_tournoi,
       p.id_noir AS id_joueuse,
       CASE
           WHEN rp.resultat IN ('0 - 1', 'F - 1') THEN 1 
           WHEN rp.resultat = 'X - X'             THEN 0.5
           ELSE 0           
       END AS score,
       j.elo AS elo_adversaire
  FROM echecs.partie p
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON j.id_joueuse = p.id_blanc;


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
       SUM(score) AS points,
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



----





SELECT p.*,
       rp.*
  FROM echecs.participante pa
  JOIN echecs.joueuse j USING(id_joueuse)
  JOIN echecs.partie p 
    ON p.id_tournoi = pa.id_tournoi 
   AND (j.id_joueuse = p.id_blanc OR j.id_joueuse = p.id_noir)
  JOIN echecs.resultat_partie rp USING(id_resultat)
 WHERE p.id_tournoi = 1
  

CREATE OR REPLACE VIEW echecs.partie_score
AS
SELECT p.id_partie,
       p.id_blanc,
       p.id_noir,
       rp.score_blanc,
       rp.score_noir
  FROM echecs.partie p 
  JOIN echecs.resultat_partie rp USING(id_resultat)

SELECT id_partie,
       UNNEST(ARRAY[id_blanc, id_noir]) AS id_joueuse,
       UNNEST(ARRAY[score_blanc, score_noir]) AS score
  FROM echecs.partie_score p


WITH a AS( 
SELECT id_partie,
       UNNEST(ARRAY[id_blanc, id_noir]) AS id_joueuse,
       UNNEST(ARRAY[score_blanc, score_noir]) AS score
  FROM echecs.partie_score p)
SELECT id_partie, sum(score)
  from a
group by 1
having sum(score) <> 1









----------------------------------------------------------------------
-- Qui est la meilleure ?
----------------------------------------------------------------------

ALTER TABLE echecs.resultat_partie
ADD COLUMN score_blanc FLOAT;

ALTER TABLE echecs.resultat_partie
ADD COLUMN score_noir FLOAT;

UPDATE echecs.resultat_partie
   SET score_blanc = 1,
       score_noir = 0
 WHERE id_resultat = 1;

UPDATE echecs.resultat_partie
   SET score_blanc = 0,
       score_noir = 1
 WHERE id_resultat = 2;

UPDATE echecs.resultat_partie
   SET score_blanc = 0.5,
       score_noir = 0.5
 WHERE id_resultat = 3;

SELECT CASE 
           WHEN p.id_noir = j.id_joueuse THEN rp.score_noir 
           WHEN p.id_blanc = j.id_joueuse THEN rp.score_blanc
       END,
       p.id_blanc,
       p.id_noir,
       rp.resultat
  FROM echecs.partie p 
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON (p.id_noir = j.id_joueuse OR p.id_blanc = j.id_joueuse)
 WHERE j.nom = 'HOU'

SELECT SUM(CASE 
           WHEN p.id_noir = j.id_joueuse THEN rp.score_noir 
           WHEN p.id_blanc = j.id_joueuse THEN rp.score_blanc
       END),
       COUNT(1)
  FROM echecs.partie p 
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON (p.id_noir = j.id_joueuse OR p.id_blanc = j.id_joueuse)
 WHERE j.nom = 'HOU'


SELECT SUM(CASE 
           WHEN p.id_noir = j.id_joueuse THEN rp.score_noir 
           WHEN p.id_blanc = j.id_joueuse THEN rp.score_blanc
       END) / COUNT(1)
  FROM echecs.partie p 
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON (p.id_noir = j.id_joueuse OR p.id_blanc = j.id_joueuse)
 WHERE j.nom = 'HOU'

SELECT CONCAT_WS(' ', LOWER(j.code_titre), j.nom, j.prenom) AS joueuse,
       SUM(CASE 
           WHEN p.id_noir = j.id_joueuse THEN rp.score_noir 
           WHEN p.id_blanc = j.id_joueuse THEN rp.score_blanc
       END) / COUNT(1)
  FROM echecs.partie p 
  JOIN echecs.resultat_partie rp USING(id_resultat)
  JOIN echecs.joueuse j ON (p.id_noir = j.id_joueuse OR p.id_blanc = j.id_joueuse)
 GROUP BY 1
 ORDER BY 2 DESC;

