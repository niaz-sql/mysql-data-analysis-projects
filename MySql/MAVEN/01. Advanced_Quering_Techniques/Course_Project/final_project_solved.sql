-- PART I: SCHOOL ANALYSIS
-- 1. View the schools and school details tables
SELECT *
FROM schools

SELECT *
FROM school_details
-- 2. In each decade, how many schools were there that produced players?
SELECT FLOOR(yearID /10) *10 AS decades, count(DISTINCT(schoolID)) AS school_count
FROM schools
GROUP BY FLOOR(yearID /10) *10
ORDER BY decades

-- 3. What are the names of the top 5 schools that produced the most players?
WITH top_5_School AS (SELECT  schoolID, COUNT(Distinct playerID) AS tot_players
								FROM schools
								GROUP BY schoolID
								ORDER BY tot_players DESC
								LIMIT  5)
SELECT ts.schoolID, ts.tot_players, sd.name_full
                                FROM top_5_School AS ts
                                INNER JOIN school_details AS sd
                                ON ts.schoolID = sd.schoolID                                


-- 4. For each decade, what were the names of the top 3 schools that produced the most players?
WITH fin_table AS (SELECT FLOOR(yearID /10) *10 AS decades, schoolID, count(DISTINCT(playerID)) AS player_count,
					ROW_NUMBER() OVER (PARTITION BY FLOOR(yearID /10) *10 ORDER BY count(DISTINCT(playerID)) DESC) AS rank_no
					FROM schools
					GROUP BY decades, schoolID
					ORDER BY decades, player_count DESC),
                   top_school AS( SELECT decades, schoolID, player_count, rank_no
									FROM fin_table
									WHERE rank_no <=3)
                                    SELECT ts.decades, ts.schoolID,  sd.name_full, ts.player_count, rank_no
                                    FROM top_school AS ts
                                    INNER JOIN school_details AS sd
                                ON ts.schoolID  = sd.schoolID    


-- PART II: SALARY ANALYSIS
-- 1. View the salaries table
SELECT *
FROM salaries

-- 2. Return the top 20% of teams in terms of average annual spending

                           
WITH m_table AS (SELECT teamID, yearID, sum(salary) AS tot_sal
						FROM salaries
						GROUP BY teamID, yearID
						ORDER BY  teamID, yearID),
                         nt_calc AS (SELECT teamID, avg(tot_sal) AS avg_sal, NTILE (5) OVER (ORDER BY avg(tot_sal) DESC) ntile_dev
									FROM m_table
                                    GROUP BY teamID)
                                    SELECT teamID, ROUND(avg_sal/1000000,2) AS avg_sal_mil
                                    FROM nt_calc
                                    WHERE ntile_dev =1
                        
                        
                     
-- 3. For each team, show the cumulative sum of spending over the years
WITH main_table AS (SELECT teamID, yearID, sum(salary) AS tot_sal
					FROM salaries
					GROUP BY teamID, yearID
					ORDER BY teamID, yearID)
                    SELECT teamID, yearID, ROUND(tot_sal/ 1000000, 2) AS tot_sal_mil ,ROUND(SUM(tot_sal) OVER (PARTITION BY teamID ORDER BY yearID )/1000000,2) AS run_sum_mil
                    FROM main_table
-- 4. Return the first year that each team's cumulative spending surpassed 1 billion

WITH main_table AS (SELECT teamID, yearID, sum(salary) AS tot_sal
					FROM salaries
					GROUP BY teamID, yearID
					ORDER BY teamID, yearID),
	run_sum_table AS(SELECT teamID, yearID, ROUND(tot_sal/ 1000000, 2) AS tot_sal_mil ,ROUND(SUM(tot_sal) OVER (PARTITION BY teamID ORDER BY yearID )/1000000,2) AS run_sum_mil
                    FROM main_table),
	bil_table AS (SELECT * 
                    FROM run_sum_table
                    WHERE run_sum_mil> 1000),
	year_table AS (SELECT teamID, yearID , run_sum_mil ,
                    ROW_NUMBER () OVER (PARTITION BY teamID ORDER BY  yearID ASC) AS rn
                    FROM bil_table)
                    SELECT teamID, yearID, run_sum_mil
                    FROM year_table
                    WHERE rn =1

-- PART III: PLAYER CAREER ANALYSIS
-- 1. View the players table and find the number of players in the table
SELECT COUNT(DISTINCT playerID) total_players
FROM players
-- 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). Sort from longest career to shortest career.
SELECT Distinct playerID, CAST(CONCAT(birthYear,'-', birthMonth,'-', birthDay) AS DATE) AS birthDay, debut, finalGame, 
DATEDIFF( debut, CAST(CONCAT(birthYear,'-', birthMonth,'-', birthDay) AS DATE))/365 AS age_at_debut,
DATEDIFF( finalGame, CAST(CONCAT(birthYear,'-', birthMonth,'-', birthDay) AS DATE))/365 AS age_at_last_game,
DATEDIFF( finalGame, debut)/365 AS carrier_length
FROM players
ORDER BY DATEDIFF( finalGame, debut)/365 DESC
-- 3. What team did each player play on for their starting and ending years?

SELECT distinct p.playerID,  s.teamID, year(debut) starting_year,
 s2.teamID, year(finalGame) ending_year
FROM players AS p
INNER JOIN salaries AS s
ON p.playerID = s.playerID AND year(p.debut) = s.yearID
INNER JOIN salaries AS s2
ON p.playerID = s2.playerID AND year(p.finalGame) = s2.yearID


-- 4. How many players started and ended on the same team and also played for over a decade?
SELECT *
FROM salaries

WITH m_table AS(SELECT DISTINCT p.playerID,  
						year (debut) starting_year, 
						s.teamID AS starting_team, 
						year (finalGame) ending_year, 
						s2.teamID AS ending_team
				FROM players AS p
				INNER JOIN salaries AS s
				ON p.playerID = s.playerID
				AND year(p.debut) = s.yearID
				INNER JOIN salaries AS s2
				ON  p.playerID = s2.playerID
				AND year(p.finalGame) = s2.yearID),
                cte AS (SELECT *
							FROM m_table
							WHERE starting_team = ending_team AND ending_year - starting_year >10)
                            SELECT p.nameGiven 
                            FROM cte as c
                            INNER JOIN players AS p
                            WHERE c.playerID  = p.playerID
              

-- PART IV: PLAYER COMPARISON ANALYSIS
-- 1. View the players table
SELECT *
FROM players

-- 2. Which players have the same birthday?
WITH m_table AS (SELECT DISTINCT  CAST(CONCAT(birthYear,'-', birthMonth,'-', birthDay) AS DATE) AS birthDay, nameGiven
				FROM players)
                SELECT birthday, GROUP_CONCAT( nameGiven SEPARATOR ', ') AS all_name
                FROM m_table
                GROUP BY birthday
               


-- 3. Create a summary table that shows for each team, what percent of players bat right, left and both
SELECT	s.teamID,
		ROUND(SUM(CASE WHEN p.bats = 'R' THEN 1 ELSE 0 END) / COUNT(s.playerID) * 100, 1) AS bats_right,
        ROUND(SUM(CASE WHEN p.bats = 'L' THEN 1 ELSE 0 END) / COUNT(s.playerID) * 100, 1) AS bats_left,
        ROUND(SUM(CASE WHEN p.bats = 'B' THEN 1 ELSE 0 END) / COUNT(s.playerID) * 100, 1) AS bats_both
FROM	salaries s LEFT JOIN players p
		ON s.playerID = p.playerID
GROUP BY s.teamID;

-- 4. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
WITH hw AS (SELECT	FLOOR(YEAR(debut) / 10) * 10 AS decade,
					AVG(height) AS avg_height, AVG(weight) AS avg_weight
			FROM	players
			GROUP BY decade)
            
SELECT	decade,
		avg_height - LAG(avg_height) OVER(ORDER BY decade) AS height_diff,
        avg_weight - LAG(avg_weight) OVER(ORDER BY decade) AS weight_diff
FROM	hw
WHERE	decade IS NOT NULL;

/* Datetime functions vary widely by RDBMS:

- MySQL:		TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), debut)
- Oracle:		MONTHS_BETWEEN(TO_DATE(birthYear || '-' || birthMonth || '-' || birthDay, 'YYYY-MM-DD'), debut) / 12
- PostgreSQL:	DATE_PART('year', debut) - DATE_PART('year', TO_DATE(birthYear || '-' || birthMonth || '-' || birthDay, 'YYYY-MM-DD'))
- SQL Server:	DATEDIFF(YEAR, CAST(birthYear + '-' + birthMonth + '-' + birthDay AS DATE), debut)
- SQLite:		CAST((STRFTIME('%Y', debut) - STRFTIME('%Y', birthYear || '-' || birthMonth || '-' || birthDay)) AS INTEGER)

*/

/* These functions vary by RDBMS:

String concatenation:
- MySQL & SQL Server: CONCAT(birthYear, '-', birthMonth, '-', birthDay)
- Oracle, PostgreSQL & SQLite: birthYear || '-' || birthMonth || '-' || birthDay

Group concatenation:
- MySQL:		GROUP_CONCAT(nameGiven SEPARATOR ', ')
- Oracle:		LISTAGG(nameGiven, ', ') WITHIN GROUP (ORDER BY nameGiven)
- PostgreSQL:	STRING_AGG(nameGiven, ', ' ORDER BY nameGiven)
- SQL Server:	STRING_AGG(nameGiven, ', ') WITHIN GROUP (ORDER BY nameGiven)
- SQLite:		GROUP_CONCAT(nameGiven, ', ')

*/