<?php
namespace App\Controller;
use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class ProductController extends AbstractController
{
    #[Route('/product/{id}', name: 'product_show')]
    public function show(int $id, ProductRepository $repo): Response
    {
        $product = $repo->find($id);
        if (!$product) throw $this->createNotFoundException();
        return $this->render('product/show.html.twig', ['product' => $product]);
    }

    #[Route('/search', name: 'product_search')]
    public function search(Request $request, ProductRepository $repo): Response
    {
        $q = $request->query->get('q', '');
        return $this->render('product/search.html.twig', [
            'products' => $q ? $repo->search($q) : [],
            'query' => $q,
        ]);
    }
}
