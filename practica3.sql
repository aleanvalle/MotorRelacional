-- 3.2.1 simple
SELECT POPULATION
FROM COUNTRY 
WHERE NAME = 'Argentina';

-- 3.2.2 simple
SELECT DISTINCT continent 
FROM country;

-- 3.2.3 simple
SELECT NAME
FROM COUNTRY
WHERE CONTINENT = 'South America' 
	AND POPULATION > 15000000;
	
-- 3.2.4 simple
SELECT NAME
FROM COUNTRY
ORDER BY GNP ASC LIMIT 10;

-- 3.2.5 simple
SELECT GOVERNMENTFORM, COUNT(NAME)
FROM COUNTRY
GROUP BY GOVERNMENTFORM;

-- 3.2.6 simple
SELECT CONTINENT, SUM(SURFACEAREA) AS SURFACE
FROM COUNTRY
GROUP BY CONTINENT
ORDER BY SURFACE DESC;

-- 3.2.7 simple
SELECT CONTINENT, COUNT(NAME)
FROM COUNTRY
WHERE POPULATION > 20000000
GROUP BY CONTINENT
HAVING COUNT(NAME) > 15;

-- 3.2.1 subquery
-- Devuelve el pais con menor expectativa de vida
SELECT NAME, LIFEEXPECTANCY
FROM COUNTRY
WHERE LIFEEXPECTANCY = (
	SELECT MIN(LIFEEXPECTANCY) 
	FROM COUNTRY);

-- 3.2.2 subquery
SELECT NAME, LIFEEXPECTANCY
FROM COUNTRY
WHERE LIFEEXPECTANCY = (
	SELECT MIN(LIFEEXPECTANCY) 
	FROM COUNTRY) 
OR LIFEEXPECTANCY = (
	SELECT MAX(LIFEEXPECTANCY) 
	FROM COUNTRY);
	
-- 3.2.3 subquery
SELECT NAME, INDEPYEAR
FROM COUNTRY
WHERE CONTINENT = (
	SELECT CONTINENT 
	FROM COUNTRY 
	WHERE INDEPYEAR = (
		SELECT MAX(INDEPYEAR) 
		FROM COUNTRY));

-- 3.2.4 subquery
SELECT CONTINENT
FROM COUNTRY 
GROUP BY CONTINENT 
ORDER BY SUM(GNP) DESC LIMIT 3;

-- 3.2.1 joins
SELECT CO.NAME, CL.LANGUAGE
FROM COUNTRY AS CO, COUNTRYLANGUAGE AS CL
WHERE CO.CODE = CL.COUNTRYCODE 
AND CO.CONTINENT = 'Oceania';

-- 3.2.2 joins
SELECT CO.NAME, COUNT(CL.COUNTRYCODE) AS LANGUAGES
FROM COUNTRY AS CO, COUNTRYLANGUAGE AS CL
WHERE CO.CODE = CL.COUNTRYCODE
GROUP BY CO.NAME
HAVING COUNT(CL.COUNTRYCODE) > 1
ORDER BY LANGUAGES DESC;

-- 3.2.3 joins
SELECT DISTINCT CL.LANGUAGE
FROM COUNTRY AS CO, COUNTRYLANGUAGE AS CL
WHERE CO.CODE = CL.COUNTRYCODE 
AND CO.CONTINENT = (
	SELECT CONTINENT 
	FROM COUNTRY 
	GROUP BY CONTINENT 
	HAVING CONTINENT <> 'Antarctica' 
	ORDER BY SUM(GNP) ASC LIMIT 1);
	
-- 3.2.4 joins
SELECT CO.NAME, CO.POPULATION, SUM(CI.POPULATION) AS URBAN_POPULATION, SUM(CI.POPULATION) * 100 / CO.POPULATION AS URBAN_PERCENT
FROM COUNTRY AS CO, CITY AS CI
WHERE CO.CODE = CI.COUNTRYCODE 
GROUP BY CO.CODE
ORDER BY URBAN_PERCENT DESC;

-- 3.3
-- Creacion de la tabla
DROP TABLE STATS;
CREATE TABLE STATS (countrycode character(3) NOT NULL PRIMARY KEY, lenguas integer, pop_urbana integer);

-- Se insertan los codigos y la cantidades de lenguas
INSERT INTO stats
SELECT CO.CODE AS COUNTRYCODE, COUNT(CL.COUNTRYCODE) AS LENGUAS
FROM COUNTRY AS CO, COUNTRYLANGUAGE AS CL
WHERE CO.CODE = CL.COUNTRYCODE
GROUP BY CO.CODE;

-- Se actualiza la tabla con la poblacion urbana
UPDATE STATS
SET COUNTRYCODE = SUBQUERY.COUNTRYCODE,
	POP_URBANA = SUBQUERY.POP_URBANA
FROM
	(SELECT CO.CODE AS COUNTRYCODE, SUM(CI.POPULATION) AS POP_URBANA
	FROM COUNTRY AS CO, CITY AS CI
	WHERE CO.CODE = CI.COUNTRYCODE 
	GROUP BY CO.CODE) AS SUBQUERY
WHERE STATS.COUNTRYCODE = SUBQUERY.COUNTRYCODE;

select * from stats;


