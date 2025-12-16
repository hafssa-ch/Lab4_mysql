# Lab 4 – Opérations CRUD avancées

## Objectifs
- Maîtriser INSERT, UPDATE, DELETE
- Respecter l’intégrité référentielle
- Utiliser les transactions (COMMIT / ROLLBACK)
- Requêtes avancées : jointures, agrégations, procédures

## Prérequis
- Base `bibliotheque` existante avec tables : `auteur`, `ouvrage`, `abonne`, `emprunt`

## Contenu
### Lab
- Ajouter des auteurs, ouvrages et abonnés
- Créer et clôturer des emprunts
- Mettre à jour la disponibilité d’un ouvrage
- Supprimer auteurs/ouvrages/abonnés en respectant les contraintes
- Exemples de transactions atomiques
- 
  <img width="285" height="93" alt="image" src="https://github.com/user-attachments/assets/bf4252bd-1645-41ee-8e8d-921e5fdecf00" />

<img width="371" height="147" alt="image" src="https://github.com/user-attachments/assets/70ebb36a-c598-4cec-91db-658d31924c03" />

<img width="1137" height="40" alt="image" src="https://github.com/user-attachments/assets/342c9ef6-b784-4e49-94ea-dde835964f81" />

### Exercice
- Création du schéma avec clés primaires, étrangères, CHECK, UNIQUE
- Sélections et filtres (ouvrages disponibles, abonnés Gmail, emprunts en cours)
- Agrégations et groupements (nombre d’emprunts par abonné, nombre d’ouvrages par auteur)
- Transactions avancées, `INSERT ... ON DUPLICATE KEY UPDATE`, procédures stockées

## Livrables
- `lab4_crud.sql` : script complet
- Captures d’écran : INSERT, UPDATE, erreur DELETE, transactions
- Exercice.sql
- README
