<?php
namespace App\DataFixtures;
use App\Entity\Category;
use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $categoriesData = [
            ['name' => 'Électronique', 'icon' => '💻', 'description' => 'Gadgets et appareils électroniques'],
            ['name' => 'Vêtements', 'icon' => '👕', 'description' => 'Mode pour hommes et femmes'],
            ['name' => 'Maison', 'icon' => '🏠', 'description' => 'Décoration et ameublement'],
            ['name' => 'Livres', 'icon' => '📚', 'description' => 'Romans, essais, et plus'],
            ['name' => 'Sport', 'icon' => '⚽', 'description' => 'Équipements sportifs'],
        ];

        $categories = [];
        foreach ($categoriesData as $data) {
            $category = new Category();
            $category->setName($data['name']);
            $category->setIcon($data['icon']);
            $category->setDescription($data['description']);
            $manager->persist($category);
            $categories[] = $category;
        }

        $productsData = [
            ['name' => 'PC Portable Gamer', 'price' => 12000, 'stock' => 5, 'desc' => 'PC ultra performant.', 'cat_idx' => 0],
            ['name' => 'Smartphone 5G', 'price' => 5000, 'stock' => 15, 'desc' => 'Dernier smartphone.', 'cat_idx' => 0],
            ['name' => 'Casque Sans Fil', 'price' => 800, 'stock' => 20, 'desc' => 'Son HD et réduction de bruit.', 'cat_idx' => 0],
            ['name' => 'T-shirt Basique', 'price' => 150, 'stock' => 50, 'desc' => 'T-shirt en coton bio.', 'cat_idx' => 1],
            ['name' => 'Veste en Cuir', 'price' => 1200, 'stock' => 10, 'desc' => 'Veste élégante.', 'cat_idx' => 1],
            ['name' => 'Lampe de Bureau', 'price' => 300, 'stock' => 30, 'desc' => 'Lampe LED moderne.', 'cat_idx' => 2],
            ['name' => 'Canapé 3 Places', 'price' => 4500, 'stock' => 3, 'desc' => 'Canapé confortable.', 'cat_idx' => 2],
            ['name' => 'Roman Science-Fiction', 'price' => 120, 'stock' => 100, 'desc' => 'Bestseller de l\'année.', 'cat_idx' => 3],
            ['name' => 'Livre de Recettes', 'price' => 200, 'stock' => 40, 'desc' => 'Cuisiner comme un chef.', 'cat_idx' => 3],
            ['name' => 'Ballon de Football', 'price' => 250, 'stock' => 25, 'desc' => 'Ballon officiel.', 'cat_idx' => 4],
            ['name' => 'Tapis de Yoga', 'price' => 180, 'stock' => 60, 'desc' => 'Tapis antidérapant.', 'cat_idx' => 4],
            ['name' => 'Haltères 5kg', 'price' => 400, 'stock' => 15, 'desc' => 'Paire d\'haltères.', 'cat_idx' => 4],
        ];

        foreach ($productsData as $data) {
            $product = new Product();
            $product->setName($data['name']);
            $product->setPrice($data['price']);
            $product->setStock($data['stock']);
            $product->setDescription($data['desc']);
            $product->setCategory($categories[$data['cat_idx']]);
            $manager->persist($product);
        }

        $manager->flush();
    }
}
