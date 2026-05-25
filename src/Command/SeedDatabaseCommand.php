<?php

namespace App\Command;

use App\Entity\Category;
use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:seed-database',
    description: 'Seed the database with default categories and products',
)]
class SeedDatabaseCommand extends Command
{
    public function __construct(
        private EntityManagerInterface $entityManager
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $existing = $this->entityManager->getRepository(Category::class)->findOneBy([]);
        if ($existing) {
            $io->warning('Database already has data. Seeding skipped.');
            return Command::SUCCESS;
        }

        $io->info('Starting database seeding...');

        $categoriesData = [
            'Ordinateurs' => [
                ['name' => 'MacBook Pro M3', 'price' => 24999.0, 'desc' => 'Le tout dernier MacBook Pro équipé de la puce Apple Silicon M3, 16 Go de RAM, SSD 512 Go.'],
                ['name' => 'Lenovo Legion 5', 'price' => 15499.0, 'desc' => 'PC Portable Gamer ultra performant avec Ryzen 7, RTX 4060, 16 Go de RAM et SSD 1 To.'],
                ['name' => 'Dell XPS 13', 'price' => 18999.0, 'desc' => 'L\'ultra-portable par excellence. Écran InfinityEdge tactile 13.4 pouces, Intel Core i7, SSD 512 Go.'],
            ],
            'Téléphones' => [
                ['name' => 'iPhone 15 Pro', 'price' => 13999.0, 'desc' => 'Le nec plus ultra d\'Apple avec châssis en titane, puce A17 Pro et système photo révolutionnaire.'],
                ['name' => 'Samsung Galaxy S24', 'price' => 11499.0, 'desc' => 'Smartphone d\'exception doté de l\'IA Samsung, d\'un écran Dynamic AMOLED 2X et d\'un zoom optique.'],
                ['name' => 'Google Pixel 8', 'price' => 8999.0, 'desc' => 'Le smartphone de Google avec puce Tensor G3, expérience Android pure et traitement photo IA inégalé.'],
            ],
            'Accessoires' => [
                ['name' => 'AirPods Pro 2', 'price' => 2799.0, 'desc' => 'Écouteurs sans fil avec réduction de bruit active deux fois plus performante et audio spatial personnalisé.'],
                ['name' => 'Sony WH-1000XM5', 'price' => 3999.0, 'desc' => 'Casque sans fil à réduction de bruit de référence. Confort absolu et autonomie de 30 heures.'],
                ['name' => 'Logitech MX Master 3S', 'price' => 1199.0, 'desc' => 'Souris ergonomique sans fil haute précision, capteur 8K DPI et défilement MagSpeed ultra rapide.'],
            ]
        ];

        foreach ($categoriesData as $catName => $products) {
            $category = new Category();
            $category->setName($catName);
            $this->entityManager->persist($category);

            foreach ($products as $prodData) {
                $product = new Product();
                $product->setName($prodData['name']);
                $product->setPrice($prodData['price']);
                $product->setDescription($prodData['desc']);
                $product->setCategory($category);
                $this->entityManager->persist($product);
            }
        }

        $this->entityManager->flush();

        $io->success('Database successfully seeded with default categories and products!');

        return Command::SUCCESS;
    }
}
