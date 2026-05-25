<?php
namespace App\Controller;
use App\Repository\CategoryRepository;
use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class CategoryController extends AbstractController
{
    #[Route('/categories', name: 'categories')]
    public function index(CategoryRepository $repo): Response
    {
        return $this->render('category/index.html.twig', ['categories' => $repo->findAll()]);
    }

    #[Route('/category/{id}/products', name: 'category_products')]
    public function products(int $id, CategoryRepository $catRepo, ProductRepository $prodRepo): Response
    {
        $category = $catRepo->find($id);
        if (!$category) throw $this->createNotFoundException();
        return $this->render('category/products.html.twig', [
            'category' => $category,
            'products' => $prodRepo->findByCategory($id),
        ]);
    }
}
