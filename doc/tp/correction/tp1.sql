CREATE OR REPLACE VIEW prenom AS
FROM 'https://static.data.gouv.fr/resources/base-prenoms-insee-format-parquet/20231121-161435/prenoms-nat2022.parquet'


-------------------------------------------------------------------------------
-- 1ere requêtes
-------------------------------------------------------------------------------

-- tous les prénoms
SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES';

DESCRIBE FROM prenom;

-- Ordonnés par année de naissance DESC
SELECT DISTINCT annais
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
 ORDER BY annais DESC;

-- Sans les données manquantes
SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX';

-------------------------------------------------------------------------------
-- Année 2022
-------------------------------------------------------------------------------

SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022';

-- Donnés plus de 2000 fois classé par sexe et nombre
SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
   AND nombre > 2000
 ORDER BY sexe,
          nombre DESC;

SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
   AND sexe = 2
   AND preusuel LIKE 'Q%';

SELECT SUBSTRING(preusuel, 1, 1) AS lettre,
       SUM(nombre)
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
 GROUP BY SUBSTRING(preusuel, 1, 1)
 ORDER BY 1;

SELECT SUBSTRING(preusuel, 1, 1) AS lettre, --preusuel[:1],
       SUM(nombre) FILTER (WHERE sexe = 1) AS garcon,
       SUM(nombre) FILTER (WHERE sexe = 2) AS fille
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
 GROUP BY SUBSTRING(preusuel, 1, 1)
 ORDER BY 1;


-------------------------------------------------------------------------------
-- Statistiques descriptives
-------------------------------------------------------------------------------

SELECT preusuel,
       LENGTH(preusuel)
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '2003';

SELECT MIN(LENGTH(preusuel)),
       MAX(LENGTH(preusuel)),
       AVG(LENGTH(preusuel))
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '2003';

SELECT preusuel
  FROM prenom
 WHERE annais = '2003'
   AND LENGTH(preusuel) = (SELECT MAX(LENGTH(preusuel)) 
                             FROM prenom 
                            WHERE annais = '2003');

SELECT annais,
       preusuel,
       LENGTH(preusuel)
  FROM prenom p1
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais BETWEEN '2015' AND '2022'
   AND LENGTH(preusuel) = (SELECT MAX(LENGTH(preusuel)) 
                             FROM prenom p2
                            WHERE preusuel <> '_PRENOMS_RARES'
                              AND p1.annais = p2.annais)
 ORDER BY annais;

SELECT annais,
       ROUND(AVG(LENGTH(preusuel)),1)
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
 GROUP BY annais
 ORDER BY annais;

-------------------------------------------------------------------------------
-- Jérôme
-------------------------------------------------------------------------------

SELECT DISTINCT annais
  FROM prenom
 WHERE annais <> 'XXXX'
   AND preusuel = 'JÉRÔME'
 ORDER BY annais DESC;

SELECT *
  FROM prenom
 WHERE annais <> 'XXXX'
   AND strip_accents(preusuel) = 'JEROME'
 ORDER BY annais DESC;

-- JEROME regroupés
SELECT strip_accents(preusuel),
       annais,
       SUM(nombre)
  FROM prenom
 WHERE annais <> 'XXXX'
   AND strip_accents(preusuel) = 'JEROME'
 GROUP BY strip_accents(preusuel),
          annais;
 ORDER BY annais DESC;

-------------------------------------------------------------------------------
-- Suivi temporel
-------------------------------------------------------------------------------

-- Nombre de naissances par année
SELECT annais,
       SUM(nombre) AS nb_naissances,
       COUNT(1) AS nb_prenoms
  FROM prenom
 WHERE annais <> 'XXXX'
   AND annais >= '2000'
 GROUP BY annais
 ORDER BY annais DESC;

-- Nombre de filles et garçons
SELECT annais,
       SUM(nombre) FILTER (WHERE sexe = 1) AS nb_garcons,
       SUM(nombre) FILTER (WHERE sexe = 2) AS nb_filles
  FROM prenom
 WHERE annais <> 'XXXX'
   AND annais >= '2000'
 GROUP BY annais
 ORDER BY annais DESC;


-------------------------------------------------------------------------------
-- Prénoms composés
-------------------------------------------------------------------------------

SELECT preusuel
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND annais BETWEEN '2000' AND '2009';

SELECT preusuel,
       SUM(nombre) AS nb_donnes
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND annais BETWEEN '2000' AND '2009'
 GROUP BY preusuel
 ORDER BY nb_donnes DESC;

-- Jean
SELECT preusuel,
       SUM(nombre) AS nb_donnes,
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND preusuel LIKE '%JEAN%'
   AND annais BETWEEN '2000' AND '2009'
 GROUP BY preusuel
 ORDER BY nb_donnes DESC;

-- Jean seulement
SELECT preusuel,
       SUM(nombre) AS nb_donnes,
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND preusuel LIKE '%JEAN%'
   AND (split_part(preusuel, '-', 1) = 'JEAN' OR split_part(preusuel, '-', 2) = 'JEAN')
   AND annais BETWEEN '2000' AND '2009'
 GROUP BY preusuel
 ORDER BY nb_donnes DESC;


-------------------------------------------------------------------------------
-- Cette année-là
-------------------------------------------------------------------------------

-- Nombre de prénoms distincts en 2016
SELECT COUNT(distinct preusuel) AS nb_prenoms,
       COUNT(DISTINCT preusuel) FILTER (WHERE sexe = 2) AS prenoms_filles,
       COUNT(DISTINCT preusuel) FILTER (WHERE sexe = 1) AS prenoms_garcons,
       prenoms_filles + prenoms_garcons
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '1962';

-- Prénoms 1962 donnés à des filles et des garçons
SELECT preusuel,
       SUM(nombre) AS total,
       SUM(nombre) FILTER (WHERE sexe = 2) AS total_filles,
       SUM(nombre) FILTER (WHERE sexe = 1) AS total_garcons
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '1962'
 GROUP BY preusuel
 HAVING COUNT(DISTINCT sexe) = 2  -- Le prénom doit avoir été donné aux deux sexes
ORDER BY total DESC;

-- Prénoms plus donnés aux filles
SELECT preusuel,
       SUM(nombre) AS total,
       SUM(nombre) FILTER (WHERE sexe = 2) AS total_filles,
       SUM(nombre) FILTER (WHERE sexe = 1) AS total_garcons,
       total_filles > total_garcons
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '1962'
 GROUP BY preusuel
 HAVING COUNT(DISTINCT sexe) = 2  -- Le prénom doit avoir été donné aux deux sexes
    AND total_filles > total_garcons  -- Plus donné aux filles
ORDER BY total DESC;



-------------------------------------------------------------------------------
-- Fichier des individus
-------------------------------------------------------------------------------

CREATE OR REPLACE VIEW individus AS
FROM 'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20231023-122841/fd-indcvi-2020.parquet'; 

SELECT COUNT(1)
  FROM individus;

SELECT SUM(ipondi)::INT
  FROM individus;

SELECT *
  FROM individus
 LIMIT 10;

CREATE OR REPLACE VIEW variables_individus AS
FROM 'https://static.data.gouv.fr/resources/recensement-de-la-population-fichiers-detail-individus-localises-au-canton-ou-ville-2020-1/20231025-082910/dictionnaire-variables-indcvi-2020.csv'

SELECT *
  FROM variables_individus;

SELECT *
  FROM variables_individus
 WHERE lib_var ILIKE '%partem%';

SELECT dept,
       SUM(ipondi)::INT AS nb_hab
  FROM individus
 GROUP BY dept
 ORDER BY 1;

SELECT dept,
       SUM(ipondi) FILTER(WHERE sexe = 1)::INT AS hommes,
       SUM(ipondi) FILTER(WHERE sexe = 2)::INT AS femmes
  FROM individus
 WHERE ager20 = 29
 GROUP BY dept
 ORDER BY 1;