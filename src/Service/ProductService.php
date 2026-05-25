<?php

namespace App\Service;

use App\Entity\Product;
use App\Repository\ProductRepository;

class ProductService
{
    public function __construct(
        private ProductRepository $productRepository
    ) {
    }

    /**
     * @return Product[]
     */
    public function getAllProducts(): array
    {
        return $this->productRepository->findAll();
    }

    public function getProductById(int $id): ?Product
    {
        return $this->productRepository->find($id);
    }
}
