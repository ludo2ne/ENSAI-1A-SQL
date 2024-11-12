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
-- 2016
-------------------------------------------------------------------------------

-- Nombre de prénoms distincts en 2016
SELECT COUNT(distinct preusuel) AS nb_prenoms,
       COUNT(DISTINCT preusuel) FILTER (WHERE sexe = 2) AS prenoms_filles,
       COUNT(DISTINCT preusuel) FILTER (WHERE sexe = 1) AS prenoms_garcons,
       prenoms_filles + prenoms_garcons
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '2016';

-- Prénoms 2016 donnés à des filles et des garçons
SELECT preusuel,
       SUM(nombre) AS total,
       SUM(nombre) FILTER (WHERE sexe = 2) AS total_filles,
       SUM(nombre) FILTER (WHERE sexe = 1) AS total_garcons
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2016'
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
   AND annais = '2016'
 GROUP BY preusuel
 HAVING COUNT(DISTINCT sexe) = 2  -- Le prénom doit avoir été donné aux deux sexes
    AND total_filles > total_garcons  -- Plus donné aux filles
ORDER BY total DESC;
