CREATE OR REPLACE TABLE prenoms AS
FROM 'https://www.insee.fr/fr/statistiques/fichier/8595130/prenoms-2024.parquet';

SET force_download=true;

SELECT *
  FROM prenoms
 WHERE niveau_geographique = 'FRANCE'
   AND prenom = 'GINETTE';


CREATE OR REPLACE TABLE prenoms_fr AS
SELECT sexe,
       prenom,
       periode,
       valeur
  FROM prenoms
 WHERE niveau_geographique = 'FRANCE';

  
SELECT COUNT(1)
  FROM prenoms_fr;

-------------------------------------------------------------------------------
-- Année 2022
-------------------------------------------------------------------------------

SELECT *
  FROM prenoms_fr
 WHERE periode = '2022'
 ORDER BY valeur DESC;

-- Colonnes
SELECT sexe,
       prenom,
       valeur
  FROM prenoms_fr
 WHERE periode = '2022'
   AND valeur >= 2000;

-- Donnés 2000 fois ou plus
SELECT *
  FROM prenoms_fr
 WHERE periode = '2022'
   AND valeur >= 2000;

-- Classés par sexe et nombre
SELECT sexe,
       prenom,
       valeur
  FROM prenoms_fr
 WHERE periode = '2022'
   AND valeur >= 2000
 ORDER BY sexe,
          valeur DESC;

-- Prénoms féminins commençant par la lettre Q
SELECT sexe,
       prenom,
       valeur
  FROM prenoms_fr
 WHERE periode = '2022'
   AND sexe = '2'
   AND prenom LIKE 'Q%';

-- Prénoms contenant un X et pas de A
SELECT sexe,
       prenom,
       valeur
  FROM prenoms_fr
 WHERE periode = '2022'
   AND prenom LIKE '%X%'
   AND prenom NOT LIKE '%A%';

-- Nombre de prénoms commençant par chaque lettre
SELECT SUBSTRING(prenom, 1, 1) AS premiere_lettre,
       COUNT(1) AS nombre
  FROM prenoms_fr
 WHERE periode = '2022'
 GROUP BY premiere_lettre
 ORDER BY 1;

-- Nombre de prénoms par sexe commençant par chaque lettre
SELECT SUBSTRING(prenom, 1, 1) AS premiere_lettre,
       COUNT(1) FILTER (WHERE sexe = 1) AS garcon,
       COUNT(1) FILTER (WHERE sexe = 2) AS fille
  FROM prenoms_fr
 WHERE periode = '2022'
 GROUP BY premiere_lettre
 ORDER BY 1;


-------------------------------------------------------------------------------
-- Statistiques descriptives
-------------------------------------------------------------------------------

SUMMARIZE prenoms;

-- Affichez pour l'année 2003, les prénoms et leurs nombres de caractères
SELECT prenom,
       LENGTH(prenom)
  FROM prenoms_fr
 WHERE periode = '2003';


-- Nombres de caractères minimum, maximum et moyen parmi les prénoms de 2003
SELECT MIN(LENGTH(prenom)),
       MAX(LENGTH(prenom)),
       AVG(LENGTH(prenom))
  FROM prenoms_fr
 WHERE periode = '2003';


-- Listez les 3 prénoms de 2003 ayant le valeur de caractères maximum
-- step1 : taille max en 2003
SELECT MAX(LENGTH(prenom))
  FROM prenoms_fr
 WHERE periode = '2003';

-- step2 : utiliser ce résultat dans une sous-requête
SELECT prenom
  FROM prenoms_fr
 WHERE periode = '2003'
   AND LENGTH(prenom) = (SELECT MAX(LENGTH(prenom)) 
                             FROM prenoms_fr 
                            WHERE periode = '2003');

-- afficher pour chaque année entre 2015 et 2022 le ou les prénoms avec le plus de caractères
-- step1 : taille max par année
SELECT p2.periode,
       MAX(LENGTH(p2.prenom))
  FROM prenoms_fr p2
 WHERE p2.periode BETWEEN '2015' AND '2022'
  GROUP BY p2.periode
  ORDER BY 1;

-- step2 : utiliser la requête ci-dessus comme sous requête et faire le lien avec le champ periode
SELECT p1.periode,
       p1.prenom,
       LENGTH(p1.prenom)
  FROM prenoms_fr p1
 WHERE p1.periode BETWEEN '2015' AND '2022'
   AND LENGTH(prenom) = (SELECT MAX(LENGTH(p2.prenom)) 
                           FROM prenoms_fr p2
                          WHERE p1.periode = p2.periode)
 ORDER BY periode;

-- Affichez pour chaque année la taille moyenne des prénoms
SELECT periode,
       ROUND(AVG(LENGTH(prenom)),1)
  FROM prenoms_fr
 GROUP BY periode
 ORDER BY periode;


-------------------------------------------------------------------------------
-- Jérôme
-------------------------------------------------------------------------------

-- Années où le prénom JÉRÔME a été donné
SELECT DISTINCT periode
  FROM prenoms_fr
 WHERE prenom = 'JÉRÔME'
 ORDER BY periode DESC;

-- Différentes manières d'écrire JEROME
SELECT DISTINCT(prenom)
  FROM prenoms_fr
 WHERE prenom LIKE 'J_R_ME';

-- JEROME avec d'autres accents / sans accent
SELECT *
  FROM prenoms_fr
 WHERE strip_accents(prenom) = 'JEROME'
 ORDER BY periode DESC;

-- valeur de fois où le prénom JEROME a été donné, quelle que soit l'accentuation
SELECT strip_accents(prenom),
       periode,
       SUM(valeur)
  FROM prenoms_fr
 WHERE strip_accents(prenom) = 'JEROME'
 GROUP BY strip_accents(prenom),
          periode
 ORDER BY periode DESC;

-------------------------------------------------------------------------------
-- Vérifions le classement
-------------------------------------------------------------------------------

-- Top 10 prénoms féminins 2023
SELECT *
  FROM prenoms_fr
 WHERE sexe = 2
   AND periode = '2023'
 ORDER BY valeur DESC
 LIMIT 10;

-- 11e au classement
SELECT *
  FROM prenoms_fr
 WHERE sexe = 2
   AND periode = '2023'
 ORDER BY valeur DESC
OFFSET 10
 LIMIT 1;

-- Classement sans accents
SELECT STRIP_ACCENTS(prenom),
       SUM(valeur) AS nb
  FROM prenoms_fr
 WHERE sexe = 2
   AND periode = '2023'
 GROUP BY STRIP_ACCENTS(prenom)
 ORDER BY nb DESC
 LIMIT 10;


-------------------------------------------------------------------------------
-- Prénoms composés
-------------------------------------------------------------------------------

-- prénoms composés entre les années 2000 et 2009 incluses
SELECT DISTINCT prenom
  FROM prenoms_fr
 WHERE prenom LIKE '%-%'
   AND periode BETWEEN '2000' AND '2009';

-- affichez également le valeur de fois où ils ont été donnés, trié en décroissant
SELECT prenom,
       SUM(valeur) AS nb_donnes
  FROM prenoms_fr
 WHERE prenom LIKE '%-%'
   AND periode BETWEEN '2000' AND '2009'
 GROUP BY prenom
 ORDER BY nb_donnes DESC;

-- Prénoms composés contenant JEAN
SELECT prenom,
       SUM(valeur) AS nb_donnes,
  FROM prenoms
 WHERE prenom LIKE '%-%'
   AND prenom LIKE '%JEAN%'
   AND periode BETWEEN '2000' AND '2009'
 GROUP BY prenom
 ORDER BY nb_donnes DESC;

-- Pour retirer les JEANNE...
SELECT prenom,
       SUM(valeur) AS nb_donnes,
  FROM prenoms_fr
 WHERE prenom LIKE '%-%'
   AND prenom LIKE '%JEAN%'
   AND prenom NOT LIKE '%JEANNE%'
   AND periode BETWEEN '2000' AND '2009'
 GROUP BY prenom
 ORDER BY nb_donnes DESC;


-------------------------------------------------------------------------------
-- Cette année-là
-------------------------------------------------------------------------------

-- valeur de prénoms distincts en 2016
SELECT COUNT(DISTINCT prenom) AS nb_prenoms,
       COUNT(DISTINCT prenom) FILTER (WHERE sexe = 2) AS prenoms_filles,
       COUNT(DISTINCT prenom) FILTER (WHERE sexe = 1) AS prenoms_garcons,
       prenoms_filles + prenoms_garcons
  FROM prenoms_fr
 WHERE periode = '1962';

-- Prénoms 1962 donnés à des filles et des garçons
SELECT prenom,
       SUM(valeur) AS total,
       SUM(valeur) FILTER (WHERE sexe = 2) AS total_filles,
       SUM(valeur) FILTER (WHERE sexe = 1) AS total_garcons
  FROM prenoms_fr
 WHERE periode = '1962'
 GROUP BY prenom
 HAVING COUNT(DISTINCT sexe) = 2  -- Le prénom doit avoir été donné aux deux sexes
ORDER BY total DESC;

-- Prénoms plus donnés aux filles
SELECT prenom,
       SUM(valeur) AS total,
       SUM(valeur) FILTER (WHERE sexe = 2) AS total_filles,
       SUM(valeur) FILTER (WHERE sexe = 1) AS total_garcons,
       total_filles > total_garcons
  FROM prenoms_fr
 WHERE periode = '1962'
 GROUP BY prenom
 HAVING COUNT(DISTINCT sexe) = 2  -- Le prénom doit avoir été donné aux deux sexes
    AND total_filles > total_garcons  -- Plus donné aux filles
ORDER BY total DESC;


-------------------------------------------------------------------------------
-- Fichier des individus
-------------------------------------------------------------------------------

CREATE OR REPLACE VIEW individus AS
FROM 'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20231023-122841/fd-indcvi-2020.parquet'; 


-- valeur d'individus
SELECT COUNT(1)
  FROM individus;

-- sommer la variable ipondi
SELECT SUM(ipondi)::INT
  FROM individus;

-- Affichez 10 lignes
SELECT *
  FROM individus
 LIMIT 10;

CREATE OR REPLACE VIEW variables_individus AS
FROM 'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20231025-082910/dictionnaire-variables-indcvi-2020.csv'

-- dictionnaire des variables
SELECT *
  FROM variables_individus;

-- modalité représentant le département de résidence de l'individu
SELECT *
  FROM variables_individus
 WHERE lib_var ILIKE '%partem%';

-- valeur d'habitants par départements
SELECT dept,
       SUM(ipondi)::INT AS nb_hab
  FROM individus
 GROUP BY dept
 ORDER BY 1;

-- valeur d'habitants par départements par sexe entre 25 et 29 ans
SELECT dept,
       SUM(ipondi) FILTER(WHERE sexe = 1)::INT AS hommes,
       SUM(ipondi) FILTER(WHERE sexe = 2)::INT AS femmes
  FROM individus
 WHERE ager20 = 29
 GROUP BY dept
 ORDER BY 1;