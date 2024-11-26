





---------------------------------------------------------------
-- Communes
---------------------------------------------------------------



CREATE OR REPLACE VIEW commune AS
FROM 'https://www.insee.fr/fr/statistiques/fichier/7766585/v_commune_2024.csv';


SELECT reg
  FROM commune
 WHERE NCC = 'MAMOUDZOU';

SELECT COUNT(1)
  FROM commune
 WHERE dep = '973';

SELECT COUNT(1)
  FROM commune
 WHERE dep IN ('02','60','80')
   AND NCC LIKE '%L%L%L%L%';

SELECT dep,
       COUNT(1) AS nb_communes
  FROM commune
 WHERE dep IS NOT NULL
 GROUP BY dep
HAVING nb_communes >= 500
 ORDER BY 2 DESC;

SELECT *
  FROM commune
 WHERE LENGTH(ncc) = (SELECT max(LENGTH(ncc))
                        FROM commune);



---------------------------------------------------------------
-- Prenom
---------------------------------------------------------------

prenom = "Katia"
annee_debut, annee_fin = 2005, 2020

df_prenom_annee = df\
    .filter((pl.col("annais") != "XXXX"))\
    .filter((pl.col("preusuel") == prenom.upper()) & 
            (pl.col("annais").cast(pl.Int32) >= annee_debut) & 
            (pl.col("annais").cast(pl.Int32) <= annee_fin))\
    .group_by("annais")\
    .agg(pl.col("nombre").sum().alias("nombre_total"))\
    .sort("annais")

print(df_prenom_annee)