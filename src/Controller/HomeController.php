<?php
namespace App\Controller;
use App\Repository\CategoryRepository;
use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'home')]
    public function index(CategoryRepository $catRepo, ProductRepository $prodRepo): Response
    {
        return $this->render('home/index.html.twig', [
            'categories' => $catRepo->findAll(),
            'featured_products' => $prodRepo->findBy([], null, 8),
        ]);
    }
}
