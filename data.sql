/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Agumon', date '2020-02-03', '0' , 'true', '10.23');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Pikachu', date '2021-01-07', '1', 'false', '15.04');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Devimon', date '2017-04-12', '5', 'true', '11');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Gabumon', '2018/11/15', '2', 'true', '8.0');

-- INSERTING DATA TO THE ANIMALS TABLE
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Charmander', '2020/02/8', '0', 'false', '-11');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Plantmon', '2021/11/5', '2', 'true', '-5.7');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES ('Squirtle', '1993/04/2', '3', 'false', '-12.13');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Angemon', '2005/06/12', '1', 'true', '-45');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Boarmon', '2005/06/07', '7', 'true', '20.4');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
 VALUES ('Blossom', '1998/10/13', '3', 'true', '17');
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES ('Ditto', '2022/05/14', '4', 'true', '22');

-- INSERTING DATA TO THE OWNERS TABLE
INSERT INTO owners (full_name, age) 
VALUES ('Sam Smith', '34');
INSERT INTO owners (full_name, age)
 VALUES ('Jennifer Orwell', '19');
INSERT INTO owners (full_name, age)
 VALUES ('Bob', '45');
INSERT INTO owners (full_name, age) 
VALUES ('Melody Pond', '77');
INSERT INTO owners (full_name, age)
 VALUES ('Dean Winchester', '14');
INSERT INTO owners (full_name, age) 
VALUES ('Jodie Whittaker', '38');

-- INSERTING DATA TO THE SPECIES TABLE
INSERT INTO species (name)
 VALUES ('Pokemon');
INSERT INTO species (name) 
VALUES ('Digimon');

UPDATE species
 SET species.name = 'Pokemon' 
 where species.hgqid = 2; 

-- If the name ends in "mon" it will be Digimon
UPDATE animals 
SET species_id = 2
 WHERE name LIKE '%mon';

-- All other animals are Pokemon
UPDATE animals
SET species_id = 1
 WHERE species_id IS NULL;

-- Sam Smith owns Agumon.
UPDATE animals 
SET owners_id = 1 
WHERE name = 'Agumon';

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals 
SET owners_id = 2 
WHERE name IN ('Gabumon', 'Pikachu');

-- Bob owns Devimon and Plantmon
UPDATE animals 
SET owners_id = 3
 WHERE name IN ('Devimon', 'Plantmon');

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals
 SET owners_id = 4 
 WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals 
SET owners_id = 5
 WHERE name IN ('Angemon', 'Boarmon');

-- INSERTING DATA TO VETS TABLE
INSERT INTO vets (name, age, date_of_graduation)
VALUES('William Tatcher', 45, '2000-04-23'),
      ('Maisy Smith', 26, '2019-01-17'),
      ('Stephanie Mendez', 64, '1981-05-04'),
      ('Jack Harkness', 38, '2008-06-08');

-- INSERTING DATA TO SPECIALITIES.
INSERT INTO specialization (species_id, vet_id)
VALUES(1, 1),
      (2, 3),
      (1, 3),
      (2, 4);

INSERT INTO visits(animal_id, vet_id, date_of_visit)
VALUES(1, 1, '2020-05-24'),
      (1, 3, '2020-07-22'),
      (2, 4, '2021-02-02'),
      (3, 2, '2020-01-05'),
      (3, 2, '2020-03-08'),
      (3, 2, '2020-05-14'),
      (4, 3, '2021-05-04'),
      (5, 4, '2021-02-24'),
      (6, 2, '2019-12-21'),
      (6, 1, '2020-08-10'),
      (6, 2, '2021-04-07'),
      (7, 3, '2019-09-29'),
      (8, 4, '2020-10-03'),
      (8, 4, '2020-11-04'),
      (9, 2, '2019-01-24'),
      (9, 2, '2019-05-15'),
      (9, 2, '2020-02-27'),
      (9, 2, '2020-08-03'),
      (10, 3, '2020-05-24'),
      (10, 1, '2021-01-11');

-- DATABASE PERFORMANCE AUDIT

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) 
SELECT * FROM (SELECT id FROM animals) animal_ids,
(SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
INSERT INTO owners (full_name, email)
SELECT 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

--  change the age null constraint
alter table owners alter column age drop not null;

