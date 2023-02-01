/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM dbo.mxmh_survey_results$


-- ** Checking number of people in each age group

SELECT Age, COUNT(Age) AS Num_People_Per_Age
FROM dbo.mxmh_survey_results$
GROUP BY Age
ORDER BY Num_People_Per_Age DESC


-- Checking the most popular streaming service PER AGE GROUP

SELECT Age, [Primary streaming service], COUNT([Primary streaming service]) OVER (PARTITION BY Age) AS Num_of_users_per_age_group 
FROM dbo.mxmh_survey_results$
GROUP BY Age, [Primary streaming service]
ORDER BY  Num_of_users_per_age_group DESC

-- ** Checking most popular streaming service

SELECT [Primary streaming service], COUNT([Primary streaming service]) AS Num_of_users
FROM dbo.mxmh_survey_results$
WHERE [Primary streaming service] IS NOT NULL
GROUP BY [Primary streaming service]
ORDER BY Num_of_users DESC;

-- ** CHECK AGE GROUP WITH MOST LISTENING TIME
SELECT DISTINCT Age,  SUM([Hours per day]) OVER (PARTITION BY Age) As Music_Hours_per_age_group
FROM dbo.mxmh_survey_results$
GROUP BY Age,[Hours per day]
ORDER BY Music_Hours_per_age_group DESC


-- ** USE FAVOURITE GENRE TO SEE GROUPS LEAST LIKELY TO EXPERIENCE ANXIETY, DEPPRESSION, INSOMNIA AND OCD
SELECT  [Fav genre], SUM(Anxiety) AS Anxiety_Sum_by_Genre, SUM(Depression) AS Depression_Sum_by_Genre, SUM(Insomnia) AS Insomnia_Sum_by_Genre, SUM(OCD) AS OCD_Sum_by_Genre
FROM dbo.mxmh_survey_results$
GROUP BY [Fav genre]
ORDER BY Anxiety_Sum_by_Genre DESC

-- EXPLORE GROUPS  WHO EXPERIENCE IMPROVEMENT TO MENTAL HEALTH WHEN LISTENING TO MUSIC
SELECT [Hours per day],[Fav genre],[Music effects],[While working],Instrumentalist, Composer
FROM dbo.mxmh_survey_results$

--** HOW MANY PEOPLE WHO LISTEN TO MUSIC WHILE WORKING EXPERIENCE IMPROVEMENTS IN MENTAL HEALTH CONDITIONS
WITH IMPROVEMENT_COUNT AS(
	SELECT [Music effects],[While working], COUNT([Music effects]) OVER (PARTITION BY [While working]) AS Num_of_improvements_While_working,
	Instrumentalist, COUNT([Music effects]) OVER (PARTITION BY Instrumentalist) AS Num_of_improvements_for_Instrumentalists,
	Composer, COUNT([Music effects]) OVER (PARTITION BY Composer) AS Num_of_improvements_for_Composers
	FROM dbo.mxmh_survey_results$
	WHERE [Music effects]='Improve'	
)
SELECT [While working], Num_of_improvements_While_working, Instrumentalist, Num_of_improvements_for_Instrumentalists,Composer, Num_of_improvements_for_Composers
FROM IMPROVEMENT_COUNT
WHERE [While working] IS NOT NULL AND Instrumentalist IS NOT NULL
GROUP BY [While working],Num_of_improvements_While_working, Instrumentalist, Num_of_improvements_for_Instrumentalists, Composer,Num_of_improvements_for_Composers




