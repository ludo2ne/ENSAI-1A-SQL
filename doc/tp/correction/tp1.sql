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

-- Listez les prénoms féminins commençant par la lettre Q
SELECT *
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
   AND sexe = 2
   AND preusuel LIKE 'Q%';

-- Compter le nombre de prénoms commençant par chaque lettre
SELECT SUBSTRING(preusuel, 1, 1) AS lettre,
       COUNT(1)
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
 GROUP BY lettre
 ORDER BY 1;

-- Bonus : différenciez filles et gaçons
SELECT SUBSTRING(preusuel, 1, 1) AS lettre, --preusuel[:1],
       COUNT(1) FILTER (WHERE sexe = 1) AS garcon,
       COUNT(1) FILTER (WHERE sexe = 2) AS fille
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais <> 'XXXX'
   AND annais = '2022'
 GROUP BY lettre
 ORDER BY 1;


-------------------------------------------------------------------------------
-- Statistiques descriptives
-------------------------------------------------------------------------------

-- Affichez pour l'année 2003, les prénoms et leurs nombres de caractères
SELECT preusuel,
       LENGTH(preusuel)
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '2003';


-- Nombres de caractères minimum, maximum et moyen parmi les prénoms de 2003
SELECT MIN(LENGTH(preusuel)),
       MAX(LENGTH(preusuel)),
       AVG(LENGTH(preusuel))
  FROM prenom
 WHERE preusuel <> '_PRENOMS_RARES'
   AND annais = '2003';


-- Listez les 3 prénoms de 2003 ayant le nombre de caractères maximum
-- step1 : taille max en 2003
SELECT MAX(LENGTH(preusuel))
  FROM prenom
 WHERE annais = '2003';

-- step2 : utiliser ce résultat dans une sous-requête
SELECT preusuel
  FROM prenom
 WHERE annais = '2003'
   AND LENGTH(preusuel) = (SELECT MAX(LENGTH(preusuel)) 
                             FROM prenom 
                            WHERE annais = '2003');


-- afficher pour chaque année entre 2015 et 2022 le ou les prénoms avec le plus de caractères
-- step1 : taille max par année
SELECT p2.annais,
       MAX(LENGTH(p2.preusuel))
  FROM prenom p2
  WHERE p2.annais BETWEEN '2015' AND '2022'
  GROUP BY p2.annais
  ORDER BY 1;

-- step2 : utiliser la requête ci-dessus comme sous requête et faire le lien avec le champ annais
SELECT p1.annais,
       p1.preusuel,
       LENGTH(p1.preusuel)
  FROM prenom p1
 WHERE p1.preusuel <> '_PRENOMS_RARES'
   AND p1.annais BETWEEN '2015' AND '2022'
   AND LENGTH(preusuel) = (SELECT MAX(LENGTH(p2.preusuel)) 
                             FROM prenom p2
                            WHERE p2.preusuel <> '_PRENOMS_RARES'
                              AND p1.annais = p2.annais)
 ORDER BY annais;


-- Affichez pour chaque année la taille moyenne des prénom
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

-- années où le prénom JÉRÔME a été donné
SELECT DISTINCT annais
  FROM prenom
 WHERE annais <> 'XXXX'
   AND preusuel = 'JÉRÔME'
 ORDER BY annais DESC;

-- JEROME avec d'autres accents / sans accent
SELECT *
  FROM prenom
 WHERE annais <> 'XXXX'
   AND strip_accents(preusuel) = 'JEROME'
 ORDER BY annais DESC;

-- nombre de fois où le prénom JEROME a été donné, quelle que soit l'accentuation
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

-- prénoms composés entre les années 2000 et 2009 incluses
SELECT preusuel
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND annais BETWEEN '2000' AND '2009';

-- affichez également le nombre de fois où ils ont été donnés, trié en décroissant
SELECT preusuel,
       SUM(nombre) AS nb_donnes
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND annais BETWEEN '2000' AND '2009'
 GROUP BY preusuel
 ORDER BY nb_donnes DESC;

-- Prénoms composés contenant JEAN
SELECT preusuel,
       SUM(nombre) AS nb_donnes,
  FROM prenom
 WHERE preusuel LIKE '%-%'
   AND preusuel LIKE '%JEAN%'
   AND annais BETWEEN '2000' AND '2009'
 GROUP BY preusuel
 ORDER BY nb_donnes DESC;

-- Pour retirer les JEANNE...
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
SELECT COUNT(DISTINCT preusuel) AS nb_prenoms,
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


-- nombre d'individus
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

-- nombre d'habitants par départements
SELECT dept,
       SUM(ipondi)::INT AS nb_hab
  FROM individus
 GROUP BY dept
 ORDER BY 1;

-- nombre d'habitants par départements par sexe entre 25 et 29 ans
SELECT dept,
       SUM(ipondi) FILTER(WHERE sexe = 1)::INT AS hommes,
       SUM(ipondi) FILTER(WHERE sexe = 2)::INT AS femmes
  FROM individus
 WHERE ager20 = 29
 GROUP BY dept
 ORDER BY 1;