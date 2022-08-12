/*Queries that provide answers to the questions from all projects.*/

-- CREATE TABLES. 

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';  

-- List the name of all animals born between 2016 and 2019.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                -- 
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = 'true' AND escape_attempts < '3';

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg  > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered IS TRUE;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals where date_of_birth > '2022-01-01';

-- UPDATE TABLES.

-- UPDATE the animals table by setting the species column to unspecified, then roll back the change
 ALTER TABLE animals RENAME COLUMN species TO unspecified;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg  = (weight_kg * (-1));

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg = -1;

-- How many animals are there
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape
SELECT MIN(escape_attempts) FROM animals;

-- What is the average weight of animals
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals
SELECT MAX(escape_attempts) FROM animals WHERE neutered = 'true' OR 'false';

-- What is the minimum and maximum weight of each type of animal
SELECT MAX(weight_kg), MIN(weight_kg) FROM animals;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY animals;

-- JOIN TABLES

-- What animals belong to Melody Pond
SELECT name FROM animals JOIN owners ON animals.owners_id = owners.id WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.id = 1;

-- List all owners and their animals, remember to include those that don't own any animal
SELECT owners.id, owners.full_name, animals.name As Animals FROM owners FULL OUTER JOIN animals ON owners.id = owners_id;

-- How many animals are there per species
SELECT species.name AS species, COUNT(*) FROM animals JOIN species ON species.id = species_id GROUP BY species;

-- List all Digimon owned by Jennifer Orwell
SELECT species.name, animals.name, owners.full_name FROM animals
INNER JOIN species ON species.id = species_id AND species.name = 'Digimon'
INNER JOIN owners ON owners.id = owners_id AND owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name FROM animals INNER JOIN owners ON owners.id = owners_id AND owners.full_name = 'Dean Winchester' WHERE animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name AS fullName, COUNT(*) FROM owners INNER JOIN animals ON owners.id = owners_id GROUP BY fullName ORDER BY count DESC;

-- JOIN TABLES
-- Who was the last animal seen by William Tatcher
SELECT animals.name FROM animals 
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'William Tatcher'
AND visits.date_of_visit = (SELECT MAX(visits.date_of_visit) FROM visits JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'William Tatcher');

  -- How many different animals did Stephanie Mendez see
SELECT DISTINCT COUNT(animals.name) FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets
FULL OUTER JOIN specialization ON vets.id = specialization.vet_id
FULL OUTER JOIN species ON species.id = specialization.species_id
ORDER BY vets.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets
SELECT animals.name, COUNT(animals.name) AS total_visits FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name ORDER BY total_visits ASC;

-- Who was Maisy Smith's first visit
SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'AND visits.date_of_visit = (SELECT MIN(visits.date_of_visit) FROM visits
JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'Maisy Smith');

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
animals.name as "Animals_name",
animals.date_of_birth as date_of_birth_of_animal,
vets.name as Vet_name,
species.name as Species,
visits.date_of_visit as Date_of_visit
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id
JOIN species on species.id = animals.species_id
WHERE Date_of_visit = ( SELECT MAX(Date_of_visit) FROM visits JOIN vets ON vets.id = visits.vet_id );

--  How many visits were with a vet that did not specialize in that animal's species
SELECT COUNT(vets.name) FROM vets FULL
JOIN specialization ON specialization.vet_id = vets.id FULL
JOIN visits ON visits.vet_id = vets.id
where specialization.vet_id is null;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "Species name", COUNT(*) FROM animals
JOIN visits on visits.animal_id = animals.id
JOIN vets on vets.id = visits.vet_id
JOIN species on species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP by species.name ORDER BY count DESC lIMIT 1;
