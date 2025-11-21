-- id de l'équipe des Spurs de San Antonio
SELECT *
  FROM nba.team
 WHERE nickname = 'Spurs';


-- Listez tous les matchs des Spurs de la saison réguliere 2024-2025
SELECT *
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
 WHERE t.nickname = 'Spurs'
   AND season_id = '22024';


-- Clé primaire possible game
SELECT team_id,
       game_id
  FROM nba.game
 GROUP BY team_id,
          game_id
HAVING COUNT(1) > 1;


-- Joueurs des Spurs
SELECT *
  FROM nba.player p
  JOIN nba.team t ON t.id::int = p.team_id
 WHERE t.nickname = 'Spurs';


-- Vérifiez que tous les id de la table team sont convertibles en entiers
SELECT CAST(id AS INTEGER)
  FROM nba.team;


-- Modifier le type de la colonne
ALTER TABLE nba.team
    ALTER COLUMN id TYPE integer
    USING CAST(id AS integer);


-- Stats joueurs spurs saison 2024
SELECT p.display_first_last,
       rss.*
  FROM nba.regular_season_stat rss
  JOIN nba.team t ON t.id = rss.team_id
  JOIN nba.player p ON p.person_id = rss.player_id
 WHERE rss.season_id = '22024'
   AND t.nickname = 'Spurs';


-- Stats joueur par match
SELECT p.display_first_last,
       psm.*
  FROM nba.player_stat_match psm
  JOIN nba.team t ON t.id = psm.teamid
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE t.nickname = 'Spurs'
   AND psm.minutes <> '';


-- Doublons dans la table
SELECT gameid,
       personid,
       COUNT(1)
  FROM nba.player_stat_match
 GROUP BY gameid,
          personid
HAVING COUNT(1) > 1


-- stats des joueurs par match de toutes les saisons ?
SELECT DISTINCT season_id
  FROM nba.player_stat_match psm
  JOIN nba.game g ON g.game_id = psm.gameid;


------------------------------------------------------
-- Matchs et classements
------------------------------------------------------

SELECT *
  FROM nba.game
 WHERE season_id = '22020';


-- Nombre de matchs
SELECT COUNT(1)
  FROM nba.game
 WHERE season_id = '22020';


-- Matchs de saison régulière et de playoff
SELECT season_type,
       COUNT(1)
  FROM nba.game
 WHERE season_id IN ('22020', '42020')
 GROUP BY season_type;


-- Matchs Utah Jazz
SELECT g.*
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
 WHERE season_id = '22020'
   AND t.nickname = 'Jazz';


-- Sur une seule ligne
SELECT COUNT(1)                           AS nb_matchs,
       COUNT(*) FILTER (WHERE g.wl = 'W') AS victoire,
       COUNT(*) FILTER (WHERE g.wl = 'L') AS defaite
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
 WHERE g.season_id = '22020'
   AND t.nickname = 'Jazz';


-- Classement Ouest
SELECT t.nickname                         AS equipe,
       COUNT(1)                           AS nb_matchs,
       COUNT(*) FILTER (WHERE g.wl = 'W') AS victoire,
       COUNT(*) FILTER (WHERE g.wl = 'L') AS defaite
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
 WHERE g.season_id = '22020'
   AND t.conference = 'West'
 GROUP BY t.id, t.nickname
  ORDER BY victoire DESC;


-- Matchs Jazz en Playoff
SELECT g.*
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
 WHERE season_id = '42020'
   AND t.nickname = 'Jazz';


-- Score et adversaires
SELECT t.full_name,
       g.pts || ' -' || gop.pts   AS score,
       top.full_name              AS adversaires,
       g.wl
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
  JOIN nba.game gop ON gop.game_id = g.game_id AND gop.team_id <> g.team_id
  JOIN nba.team top ON gop.team_id = top.id
 WHERE g.season_id = '42020'
   AND t.nickname = 'Jazz';


-- Score de match
SELECT t.full_name,      
       COUNT(*) FILTER (WHERE g.wl = 'W') || ' - ' || COUNT(*) FILTER (WHERE g.wl = 'L') AS score,
       top.full_name              AS adversaires
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
  JOIN nba.game gop ON gop.game_id = g.game_id AND gop.team_id <> g.team_id
  JOIN nba.team top ON gop.team_id = top.id
 WHERE g.season_id = '42020'
   AND t.nickname = 'Jazz'
 GROUP BY t.full_name, top.full_name;


-- 1. Trouver le dernier match de la saison de Playoff
-- 2. Trouver les 2 équipes ayant joué cette finale (vainqueur et finaliste)
-- 3. Trouver les autres matchs de la finale et calculer le score


------------------------------------------------------
-- Triple zéro
------------------------------------------------------

-- Stats par match des joueurs
SELECT p.display_first_last,
       psm.*
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid;


-- Avec au moins 10 min de jeu
SELECT p.display_first_last,
       psm.*
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9;


-- Stats utiles
SELECT p.display_first_last    AS joueur,
       psm.minutes,
       psm.points,
       psm.reboundstotal       AS rebonds,
       psm.steals              AS interceptions,
       psm.blocks              AS contres,
       psm.assists             AS passes_decisives
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9;


-- Quintuple zero
SELECT p.display_first_last    AS joueur,
       psm.minutes,
       psm.points,
       psm.reboundstotal       AS rebonds,
       psm.steals              AS interceptions,
       psm.blocks              AS contres,
       psm.assists             AS passes_decisives
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
 ORDER BY psm.points + psm.reboundstotal + psm.steals + psm.blocks + psm.assists;


-- Quadruple zero
SELECT p.display_first_last    AS joueur,
       psm.minutes,
       psm.points,
       psm.reboundstotal       AS rebonds,
       psm.steals              AS interceptions,
       psm.blocks              AS contres,
       psm.assists             AS passes_decisives
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND psm.points = 0
   AND (
       (CASE WHEN psm.reboundstotal = 0 THEN 1 ELSE 0 END) +
       (CASE WHEN psm.steals = 0 THEN 1 ELSE 0 END) +
       (CASE WHEN psm.blocks = 0 THEN 1 ELSE 0 END) +
       (CASE WHEN psm.assists = 0 THEN 1 ELSE 0 END)
      ) = 3;


-- 0 points
SELECT p.display_first_last    AS joueur,
       COUNT(1)                AS nb_zero
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND psm.points = 0
 GROUP BY p.person_id, p.display_first_last
 ORDER BY 2 DESC
 LIMIT 1;


-- Pire shooter d'un match
SELECT p.display_first_last    AS joueur,
       psm.minutes,
       psm.fieldgoalsattempted,
       psm.freethrowsattempted
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND psm.points = 0
 ORDER BY psm.fieldgoalsattempted + psm.freethrowsattempted DESC;


--Expulsions
SELECT p.display_first_last    AS joueur,
       COUNT(1)                AS nb_expulsions
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND psm.foulspersonal >= 6
 GROUP BY p.person_id, p.display_first_last
 ORDER BY 2 DESC
 LIMIT 10;


-- plus de turnover que de points marqués
SELECT p.display_first_last    AS joueur,
       psm.minutes,
       psm.points,
       psm.turnovers           
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND psm.turnovers > psm.points
 ORDER BY psm.turnovers - psm.points DESC;


-- Quel joueur a eu la pire influence sur un seul match
SELECT p.display_first_last AS joueur,
       psm.plusminuspoints,
       psm.minutes
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 ORDER BY psm.plusminuspoints ASC
 LIMIT 1;


-- joueurs qui ont le plus grand nombre de matchs avec une influence négative sur l'équipe
SELECT p.display_first_last AS joueur,
       COUNT(CASE WHEN psm.plusminuspoints > 0 THEN 1 END) AS nb_plus,
       COUNT(CASE WHEN psm.plusminuspoints < 0 THEN 1 END) AS nb_moins
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
 GROUP BY p.person_id, p.display_first_last
 ORDER BY 3 DESC;


-- Quel joueur a eu la pire influence, et pourtant son équipe a gagné
SELECT p.display_first_last AS joueur,     
       psm.plusminuspoints
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
  JOIN nba.team t ON t.id::int = psm.teamid
  JOIN nba.game g ON g.game_id = psm.gameid AND t.id = g.team_id
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND g.wl = 'W'
 ORDER BY psm.plusminuspoints;


-- Ajoutez les deux équipes et le score du match
SELECT p.display_first_last AS joueur,     
       psm.plusminuspoints,
       t.full_name          AS equipe_joueur,
       g.pts || ' - ' || gop.pts AS score,
       top.full_name        AS equipe_adverse       
  FROM nba.player_stat_match psm
  JOIN nba.player p ON p.person_id = psm.personid
  JOIN nba.team t ON t.id::int = psm.teamid
  JOIN nba.game g ON g.game_id = psm.gameid AND t.id = g.team_id
  JOIN nba.game gop ON gop.game_id = g.game_id AND g.team_id <> gop.team_id
  JOIN nba.team top ON top.id = gop.team_id
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND g.wl = 'W'
 ORDER BY psm.plusminuspoints;





------------------------------------------------------
-- Classement 2024
------------------------------------------------------

-- Tous les matchs
SELECT t.full_name,
       g.*
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id
 WHERE season_id = '22024'
 ORDER BY g.team_id,
          g.game_date;
















-- Pour chaque match affichez les colonnes suivantes
  -- jour du match au format YYYY-MM-DD
  -- équipe domicile
  -- score, par exemple *121 - 102*
  -- équipe extérieur
SELECT TO_CHAR(g.game_date, 'YYYY-MM-DD') AS match_date,
       g.team_name_home AS home_team,
       g.pts_home::int || ' - ' || g.pts_away::int AS score,
       g.team_name_away AS away_team
FROM game g
JOIN team t 
    ON t.id = g.team_id_home OR t.id = g.team_id_away
WHERE g.season_id = '22022'
  AND t.full_name = 'San Antonio Spurs'
ORDER BY game_date;


-- Ajoutez une colonne pour afficher si les Spurs ont gagné
-- Ajoutez deux colonnes de victoires et défaites cumulatives
SELECT TO_CHAR(g.game_date, 'YYYY-MM-DD') AS match_date,
       g.team_name_home AS home_team,
       g.pts_home::int || ' - ' || g.pts_away::int AS score,
       g.team_name_away AS away_team,
    CASE 
        WHEN t.full_name = g.team_name_home AND g.pts_home > g.pts_away THEN 1
        WHEN t.full_name = g.team_name_away AND g.pts_away > g.pts_home THEN 1
        ELSE 0
    END AS spurs_win,
    SUM(
        CASE 
            WHEN t.full_name = g.team_name_home AND g.pts_home > g.pts_away THEN 1
            WHEN t.full_name = g.team_name_away AND g.pts_away > g.pts_home THEN 1
            ELSE 0
        END
    ) OVER (ORDER BY g.game_date) AS cumulative_wins,
    SUM(
        CASE 
            WHEN t.full_name = g.team_name_home AND g.pts_home < g.pts_away THEN 1
            WHEN t.full_name = g.team_name_away AND g.pts_away < g.pts_home THEN 1
            ELSE 0
        END
    ) OVER (ORDER BY g.game_date) AS cumulative_defeats
FROM game g
JOIN team t 
    ON t.id = g.team_id_home OR t.id = g.team_id_away
WHERE g.season_id = '22022'
  AND t.full_name = 'San Antonio Spurs'
ORDER BY game_date;


--
-- Classement
-- 

-- Listez tous les matchs de la saison 2022-2023
SELECT *
  FROM game g
 WHERE g.season_id = '22022';

-- Gardez uniquement trois colonnes game_id, team_id_home, victoire
SELECT g.game_id,
       g.team_id_home AS team_id,
       CASE WHEN g.pts_home > g.pts_away THEN 1 ELSE 0 END AS victoire
  FROM game g
 WHERE g.season_id = '22022';

-- Créez une vue game_2022
CREATE VIEW game_2022 AS
SELECT g.game_id,
       g.team_id_home AS team_id,
       CASE WHEN g.pts_home > g.pts_away THEN 1 ELSE 0 END AS victoire
  FROM game g
 WHERE g.season_id = '22022'
UNION
SELECT g.game_id,
       g.team_id_away AS team_id,
       CASE WHEN g.pts_home < g.pts_away THEN 1 ELSE 0 END AS victoire
  FROM game g
 WHERE g.season_id = '22022';

-- Vérifications
SELECT game_id,
       team_id
  FROM game_2022
 GROUP BY game_id,
          team_id
HAVING COUNT(1) > 1;

SELECT game_id
  FROM game_2022
 GROUP BY game_id
HAVING COUNT(1) <> 2;

-- Classements
SELECT t.nickname AS equipe,
       COUNT(*) AS matchs_joues,
       SUM(g.victoire) AS victoires,
       COUNT(*) - SUM(g.victoire) AS defaites,
       ROUND(SUM(g.victoire)::numeric / COUNT(*) * 100, 2) AS pourcentage_victoire
  FROM game_2022 g
  JOIN team t ON g.team_id = t.id
 WHERE t.conference = 'West'
 GROUP BY t.nickname
 ORDER BY pourcentage_victoire DESC, victoires DESC;
