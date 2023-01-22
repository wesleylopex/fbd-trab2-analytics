-- Available tables
-- circuits
-- constructorResults
-- constructors
-- constructorStandings
-- drivers
-- driverStandings
-- lapTimes
-- pitStops
-- qualifying
-- races
-- results
-- seasons
-- sprintResults
-- status


-- Descricao da consulta: quais pilotos mais ganharam corridas

SELECT COUNT(results.resultId) AS winsCount, CONCAT(drivers.forename, ' ' , drivers.surname)
FROM results
INNER JOIN drivers
ON results.driverId = drivers.driverId AND results.position = 1
GROUP BY drivers.driverId
ORDER BY COUNT(results.resultId) DESC;

-- Descricao da consulta: quais pilotos mais ficaram no pódio

SELECT COUNT(results.resultId) AS podiumCount, CONCAT(drivers.forename, ' ' , drivers.surname)
FROM results
INNER JOIN drivers
ON results.driverId = drivers.driverId AND results.position <= 3
GROUP BY drivers.driverId
ORDER BY COUNT(results.resultId) DESC;


-- Descricao da consulta: quais pilotos mais largaram em primeiro

SELECT CONCAT(drivers.forename, ' ' , drivers.surname), COUNT(qualifying.qualifyId) AS poleCount 
FROM qualifying
INNER JOIN drivers
ON qualifying.driverId = drivers.driverId AND qualifying.position = 1
GROUP BY drivers.driverId
ORDER BY COUNT(qualifying.qualifyId) DESC;


-- Descricao da consulta: quais pilotos nunca largaram em primeiro

SELECT CONCAT(drivers.forename, ' ' , drivers.surname)
FROM drivers
WHERE drivers.driverId NOT IN (SELECT qualifying.driverId FROM qualifying WHERE qualifying.position = 1)
ORDER BY drivers.driverId;


-- Descricao da consulta: quais pilotos nunca correram uma corrida

SELECT CONCAT(drivers.forename, ' ' , drivers.surname)
FROM drivers
WHERE drivers.driverId NOT IN (SELECT results.driverId FROM results)
ORDER BY drivers.driverId;


-- Descricao da consulta: quais construtores mais ganharam corridas

SELECT COUNT(results.resultId) AS winsCount, constructors.name
FROM results
INNER JOIN constructors
ON results.constructorId = constructors.constructorId AND results.position = 1
GROUP BY constructors.constructorId
ORDER BY COUNT(results.resultId) DESC;


-- Descricao da consulta: quais pilotos tiveram acidentes (statusId = 104 OR status = 3), informando o nome do piloto, nome do circuito e país do circuito e data

SELECT CONCAT(drivers.forename, ' ' , drivers.surname) AS driverName, circuits.name AS circuitName, circuits.country AS circuitCountry, status.status, races.date
FROM results
INNER JOIN drivers
ON results.driverId = drivers.driverId
INNER JOIN races
ON races.raceId = results.raceId
INNER JOIN circuits
ON circuits.circuitId = races.circuitId
INNER JOIN status
ON status.statusId = results.statusId
WHERE results.statusId = 104 OR results.statusId = 3
ORDER BY drivers.driverId;


-- Descricao da consulta: quais pilotos que mais tiveram acidentes (statusId = 104 OR status = 3), informando o nome do piloto, numero de acidentes

SELECT CONCAT(drivers.forename, ' ' , drivers.surname) AS driverName, COUNT(results.resultId) AS accidentsCount
FROM results
INNER JOIN drivers
ON results.driverId = drivers.driverId
WHERE results.statusId = 104 OR results.statusId = 3
GROUP BY drivers.driverId
ORDER BY COUNT(results.resultId) DESC;


-- Descricao da consulta: mais acidentes (statusId = 104 OR status = 3) por nacionalidade (drivers.nationality)

SELECT drivers.nationality, COUNT(results.resultId) AS accidentsCount
FROM results
INNER JOIN drivers
ON results.driverId = drivers.driverId
WHERE results.statusId = 104 OR results.statusId = 3
GROUP BY drivers.nationality
ORDER BY COUNT(results.resultId) DESC;
