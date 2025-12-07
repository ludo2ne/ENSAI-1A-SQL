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
HAVING COUNT(1) > 1;


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
  JOIN nba.team t ON t.id = g.team_id::int
 WHERE season_id = '22020'
   AND t.nickname = 'Jazz';


-- Sur une seule ligne
SELECT COUNT(1)                           AS nb_matchs,
       COUNT(*) FILTER (WHERE g.wl = 'W') AS victoire,
       COUNT(*) FILTER (WHERE g.wl = 'L') AS defaite
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
 WHERE g.season_id = '22020'
   AND t.nickname = 'Jazz';


-- Classement Ouest
SELECT t.nickname                         AS equipe,
       COUNT(1)                           AS nb_matchs,
       COUNT(*) FILTER (WHERE g.wl = 'W') AS victoire,
       COUNT(*) FILTER (WHERE g.wl = 'L') AS defaite
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
 WHERE g.season_id = '22020'
   AND t.conference = 'West'
 GROUP BY t.id, t.nickname
  ORDER BY victoire DESC;


-- Matchs Jazz en Playoff
SELECT g.*
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
 WHERE season_id = '42020'
   AND t.nickname = 'Jazz';


-- Score et adversaires
SELECT t.full_name,
       g.pts || ' -' || gop.pts   AS score,
       top.full_name              AS adversaires,
       g.wl
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
  JOIN nba.game gop ON gop.game_id = g.game_id AND gop.team_id <> g.team_id
  JOIN nba.team top ON gop.team_id::int = top.id
 WHERE g.season_id = '42020'
   AND t.nickname = 'Jazz';


-- Score de match
SELECT t.full_name,      
       COUNT(*) FILTER (WHERE g.wl = 'W') || ' - ' || COUNT(*) FILTER (WHERE g.wl = 'L') AS score,
       top.full_name              AS adversaires
  FROM nba.game g
  JOIN nba.team t ON t.id = g.team_id::int
  JOIN nba.game gop ON gop.game_id = g.game_id AND gop.team_id <> g.team_id
  JOIN nba.team top ON gop.team_id::int = top.id
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
  JOIN nba.game g ON g.game_id = psm.gameid AND t.id = g.team_id::int
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
  JOIN nba.game g ON g.game_id = psm.gameid AND t.id = g.team_id::int
  JOIN nba.game gop ON gop.game_id = g.game_id AND g.team_id <> gop.team_id
  JOIN nba.team top ON top.id = gop.team_id::int
 WHERE psm.minutes <> ''
   AND CAST(SPLIT_PART(psm.minutes, ':', 1) AS integer) > 9
   AND g.wl = 'W'
 ORDER BY psm.plusminuspoints;


------------------------------------------------------
-- Classement par saison
------------------------------------------------------

SELECT t.full_name AS team,
       COUNT(*) FILTER (WHERE g.wl = 'W') AS wins,
       COUNT(*) FILTER (WHERE g.wl = 'L') AS losses,
       ROUND(COUNT(*) FILTER (WHERE g.wl = 'W')::numeric / COUNT(*), 3) AS win_pct
  FROM nba.game g
  JOIN nba.team t ON g.team_id::int = t.id
 WHERE g.season_id = '22008'
   AND g.season_type = 'Regular Season'
   AND t.conference = 'West'
 GROUP BY t.full_name
 ORDER BY win_pct DESC;



WITH 
last_playoff_games_by_season AS (
    SELECT season_id, MAX(game_id) AS last_game_id
      FROM nba.game
     WHERE season_type = 'Playoffs'
     GROUP BY season_id
),
winner_by_season AS (
    SELECT g.season_id, 
           g.team_id
      FROM nba.game g
      JOIN last_playoff_games_by_season lpg ON g.season_id = lpg.season_id AND g.game_id = lpg.last_game_id
     WHERE g.wl = 'W'
),
conf_rank AS (
    SELECT g.season_id,
           t.conference,
           g.team_id::int AS team_id,
           COUNT(*) FILTER (WHERE wl='W') AS wins,
           COUNT(*) FILTER (WHERE wl='L') AS losses,
           RANK() OVER (
               PARTITION BY g.season_id, t.conference
               ORDER BY COUNT(*) FILTER (WHERE wl='W')::numeric / COUNT(*) DESC
           ) AS conf_rank
      FROM nba.game g
      JOIN nba.team t ON g.team_id::int = t.id
     WHERE g.season_type = 'Regular Season'
    GROUP BY g.season_id, t.conference, g.team_id
)
SELECT RIGHT(w.season_id, 4) AS Season,
       t.full_name AS champion_team,
       t.id,
       t.conference,
       r.conf_rank AS regular_season_rank
  FROM winner_by_season w
  JOIN nba.team t ON w.team_id::int = t.id
  JOIN conf_rank r ON r.team_id = t.id AND RIGHT(r.season_id, 4) = RIGHT(w.season_id, 4)
ORDER BY w.season_id;
