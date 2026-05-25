<?php
namespace App\Repository;
use App\Entity\Product;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class ProductRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry) { parent::__construct($registry, Product::class); }
    public function findByCategory(int $categoryId): array
    {
        return $this->createQueryBuilder('p')
            ->andWhere('p.category = :cat')
            ->setParameter('cat', $categoryId)
            ->getQuery()->getResult();
    }
    public function search(string $q): array
    {
        return $this->createQueryBuilder('p')
            ->andWhere('p.name LIKE :q OR p.description LIKE :q')
            ->setParameter('q', '%'.$q.'%')
            ->getQuery()->getResult();
    }
}
