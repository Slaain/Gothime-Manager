CREATE DATABASE time_manager_db;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,             -- Identifiant  de l'utilisateur
    username VARCHAR(255) NOT NULL,    -- Nom d'utilisateur
    email VARCHAR(255) NOT NULL        -- Adresse email
);
 
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);
 
CREATE TABLE clocks (
    id SERIAL PRIMARY KEY,             -- Identifiant unique de l'enregistrement
    time TIMESTAMP NOT NULL,           -- Heure de l'enregistrement
    status BOOLEAN NOT NULL,           -- Statut (true = clock in, false = clock out)
    user_id INT NOT NULL,              -- Identifiant de l'utilisateur
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) -- Clé étrangère vers users
);
 
CREATE TABLE workingtime (
    id SERIAL PRIMARY KEY,             -- Identifiant unique de l'enregistrement
    start TIMESTAMP NOT NULL,          -- Heure de début (obligatoire)
    "end" TIMESTAMP NOT NULL,          -- Heure de fin (obligatoire)
    user_id INT NOT NULL,              -- Identifiant de l'utilisateur (obligatoire)
    CONSTRAINT fk_user_workingtime FOREIGN KEY (user_id) REFERENCES users(id)
);