# 🛒 E-Commerce Symfony Project

Ce projet est une application d'e-commerce complète développée avec **Symfony**, conçue pour offrir une expérience d'achat en ligne fluide et une interface d'administration simple.

## 🚀 Fonctionnalités principales

* **Catalogue de produits** : Affichage des produits par catégories avec détails (prix, stock, description).
* **Panier d'achat** : Ajout, suppression et gestion des quantités d'articles dans le panier.
* **Commandes** : Processus de validation de commande simple.
* **Espace Administrateur** : Interface de gestion complète propulsée par *EasyAdmin* pour gérer :
  * Les catégories
  * Les produits
  * Les utilisateurs
  * Les commandes
* **Fixtures de démonstration** : Jeu de données prêt à l'emploi (catégories, produits) pour tester rapidement l'application.

## 🛠️ Technologies utilisées

* **Framework** : Symfony 7 / PHP 8.2+
* **Base de données** : MySQL (gérée via Docker Compose)
* **ORM** : Doctrine
* **Administration** : EasyAdmin Bundle
* **Stylisme** : Tailwind CSS / Bootstrap (selon configuration) & Twig

## ⚙️ Installation et Démarrage local

Suivez ces étapes pour installer et lancer le projet sur votre machine locale.

### Prérequis
* [PHP 8.2+](https://www.php.net/)
* [Composer](https://getcomposer.org/)
* [Docker Desktop](https://www.docker.com/) (pour la base de données)
* [Symfony CLI](https://symfony.com/download)

### 1. Cloner le dépôt
```bash
git clone https://github.com/votre-nom-utilisateur/ecommerce_projet_ehei.git
cd ecommerce_projet_ehei
```

### 2. Démarrer la base de données (Docker)
Assurez-vous que Docker tourne, puis lancez le conteneur MySQL :
```bash
docker compose up -d
```

### 3. Installer les dépendances
```bash
composer install
```
*(Si vous rencontrez une erreur de version PHP, vous pouvez utiliser `composer install --ignore-platform-reqs`)*

### 4. Préparer la base de données
Créez la base de données, appliquez les migrations et chargez les données de test (Fixtures) :
```bash
php bin/console doctrine:database:create
php bin/console doctrine:migrations:migrate
php bin/console doctrine:fixtures:load
```

### 5. Lancer le serveur local Symfony
```bash
symfony server:start -d
```

L'application sera accessible sur : **http://localhost:8000**


## 🤝 Contribution

Les pull requests sont les bienvenues. Pour les changements majeurs, veuillez ouvrir une issue d'abord pour discuter de ce que vous aimeriez changer.

---

