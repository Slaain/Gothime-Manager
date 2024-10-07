DROP TABLE IF EXISTS workingtime;
DROP TABLE IF EXISTS clocks;
DROP TABLE IF EXISTS users;

-- Création de la base de données
CREATE DATABASE time_manager_db;

-- Se connecter à la base de données créée
\c time_manager_db;

-- Création de la table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,             -- Identifiant de l'utilisateur
    username VARCHAR(255) NOT NULL,    -- Nom d'utilisateur
    email VARCHAR(255) NOT NULL,       -- Adresse email
    CONSTRAINT unique_email UNIQUE (email) -- Contrainte d'unicité sur l'email
);

-- Création de la table clocks
CREATE TABLE clocks (
    id SERIAL PRIMARY KEY,             -- Identifiant unique de l'enregistrement
    time TIMESTAMP NOT NULL,           -- Heure de l'enregistrement
    status BOOLEAN NOT NULL,           -- Statut (true = clock in, false = clock out)
    user_id INT NOT NULL,              -- Identifiant de l'utilisateur
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) -- Clé étrangère vers users
);

-- Création de la table workingtime
CREATE TABLE workingtime (
    id SERIAL PRIMARY KEY,             -- Identifiant unique de l'enregistrement
    start TIMESTAMP NOT NULL,          -- Heure de début
    "end" TIMESTAMP NOT NULL,          -- Heure de fin
    user_id INT NOT NULL,              -- Identifiant de l'utilisateur
    CONSTRAINT fk_user_workingtime FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insertion de fausses données dans la table users
INSERT INTO users (username, email) VALUES 
('JohnDoe', 'john.doe@example.com'),
('JaneDoe', 'jane.doe@example.com'),
('AliceWonder', 'alice.wonder@example.com'),
('BobBuilder', 'bob.builder@example.com');

-- Insertion de fausses données dans la table clocks
INSERT INTO clocks (time, status, user_id) VALUES 
('2024-10-07 08:00:00', true, 1),  -- JohnDoe clock in
('2024-10-07 17:00:00', false, 1), -- JohnDoe clock out
('2024-10-07 09:00:00', true, 2),  -- JaneDoe clock in
('2024-10-07 18:00:00', false, 2), -- JaneDoe clock out
('2024-10-07 08:30:00', true, 3),  -- AliceWonder clock in
('2024-10-07 17:30:00', false, 3), -- AliceWonder clock out
('2024-10-07 09:30:00', true, 4),  -- BobBuilder clock in
('2024-10-07 18:30:00', false, 4); -- BobBuilder clock out

-- Insertion de fausses données dans la table workingtime
INSERT INTO workingtime (start, "end", user_id) VALUES 
('2024-10-07 08:00:00', '2024-10-07 17:00:00', 1), -- JohnDoe working time
('2024-10-07 09:00:00', '2024-10-07 18:00:00', 2), -- JaneDoe working time
('2024-10-07 08:30:00', '2024-10-07 17:30:00', 3), -- AliceWonder working time
('2024-10-07 09:30:00', '2024-10-07 18:30:00', 4); -- BobBuilder working time
