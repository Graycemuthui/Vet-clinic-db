/* Database schema to keep the structure of entire database. */
-- Create table for animals
CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL NOT NULL,
    species VARCHAR(100),
    PRIMARY KEY(id)
);

-- Create table for owners
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY(id)  
);

-- Create table for species
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

-- Remove column species
ALTER TABLE animals DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);
-- animals_species_id_fkey" FOREIGN KEY (species_id) REFERENCES species(id)

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD COLUMN owners_id INT REFERENCES owners(id);
-- animals_owners_id_fkey" FOREIGN KEY (owners_id) REFERENCES owners(id)


-- JOIN TABLES
-- Create the vets to store vets.
CREATE TABLE vets(
    id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    name VARCHAR NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE,
    PRIMARY KEY (id)
);

-- Create a join table to store species and vets.
CREATE TABLE specialization(
    species_id INT REFERENCES species(id),
    vet_id INT REFERENCES vets(id)
);

-- Create a join table to store animals and vets.
CREATE TABLE visits(
    animal_id INT REFERENCES animals(id),
    vet_id INT REFERENCES vets(id),
    date_of_visit DATE
);

-- Database Performance Audit

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

ALTER TABLE owners ALTER COLUMN age DROP NOT NULL;

CREATE INDEX animal_id ON visits (animal_id);

CREATE INDEX vet_id ON visits (vet_id);

CREATE INDEX owner_email ON owners (email);
