
CREATE DATABASE bibliotheque
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bibliotheque;

CREATE TABLE auteur (
  id  INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ouvrage (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  titre      VARCHAR(200) NOT NULL,
  disponible BOOLEAN NOT NULL DEFAULT TRUE,
  auteur_id  INT NOT NULL,

  CONSTRAINT fk_ouvrage_auteur
    FOREIGN KEY (auteur_id)
    REFERENCES auteur(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE abonne (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nom   VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE emprunt (
  ouvrage_id INT NOT NULL,
  abonne_id  INT NOT NULL,
  date_debut DATE NOT NULL,
  date_fin   DATE,

  PRIMARY KEY (ouvrage_id, abonne_id, date_debut),

  CONSTRAINT fk_emprunt_ouvrage
    FOREIGN KEY (ouvrage_id)
    REFERENCES ouvrage(id)
    ON DELETE RESTRICT,

  CONSTRAINT fk_emprunt_abonne
    FOREIGN KEY (abonne_id)
    REFERENCES abonne(id)
    ON DELETE CASCADE,

  CONSTRAINT ck_dates
    CHECK (date_fin IS NULL OR date_fin >= date_debut)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 0;


SELECT titre
FROM ouvrage
WHERE disponible = TRUE;

SELECT *
FROM abonne
WHERE email LIKE '%@gmail.com';

SELECT *
FROM emprunt
WHERE date_fin IS NULL;

SELECT a.nom AS abonne, o.titre
FROM emprunt e
JOIN abonne a  ON e.abonne_id = a.id
JOIN ouvrage o ON e.ouvrage_id = o.id;

SELECT a.nom, COUNT(*) AS total_emprunts
FROM emprunt e
JOIN abonne a ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT au.nom, COUNT(o.id) AS nb_ouvrages
FROM auteur au
LEFT JOIN ouvrage o ON o.auteur_id = au.id
GROUP BY au.id, au.nom
ORDER BY nb_ouvrages DESC;

SELECT au.nom, COUNT(o.id) AS nb_ouvrages
FROM auteur au
JOIN ouvrage o ON o.auteur_id = au.id
GROUP BY au.id, au.nom
HAVING COUNT(o.id) >= 3;

UPDATE ouvrage
SET disponible = FALSE
WHERE id = 1;

DELETE FROM emprunt
WHERE date_fin < '2025-01-01';

UPDATE emprunt
SET date_fin = CURDATE()
WHERE ouvrage_id = 1
  AND abonne_id = 2
  AND date_fin IS NULL;

START TRANSACTION;

INSERT INTO abonne (nom, email)
VALUES ('Nadia', 'nadia@mail.com');

INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
SELECT 1, LAST_INSERT_ID(), CURDATE()
WHERE (SELECT disponible FROM ouvrage WHERE id = 1) = TRUE;

INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
SELECT 2, LAST_INSERT_ID(), CURDATE()
WHERE (SELECT disponible FROM ouvrage WHERE id = 2) = TRUE;

COMMIT;

INSERT INTO ouvrage (slug, titre, disponible, auteur_id)
VALUES ('les-miserables', 'Les Misérables', TRUE, 1)
ON DUPLICATE KEY UPDATE
titre = VALUES(titre),
disponible = VALUES(disponible);

DELIMITER $$

CREATE PROCEDURE creer_emprunt (
  IN p_ouvrage_id INT,
  IN p_abonne_id  INT
)
BEGIN
  IF (SELECT disponible FROM ouvrage WHERE id = p_ouvrage_id) = TRUE THEN
    INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
    VALUES (p_ouvrage_id, p_abonne_id, CURDATE());

    UPDATE ouvrage
    SET disponible = FALSE
    WHERE id = p_ouvrage_id;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ouvrage non disponible';
  END IF;
END$$

DELIMITER ;
