<?php
namespace App\Controller;
use App\Entity\CartItem;
use App\Repository\ProductRepository;
use App\Service\Cart\CartHandler;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class CartController extends AbstractController
{
    public function __construct(private CartHandler $cartHandler) {}

    #[Route('/cart', name: 'cart_show')]
    public function show(): Response
    {
        return $this->render('cart/show.html.twig', ['cart' => $this->cartHandler->getCart()]);
    }

    #[Route('/cart/add/{id}', name: 'cart_add', methods: ['POST'])]
    public function add(int $id, ProductRepository $repo, Request $request): Response
    {
        $product = $repo->find($id);
        if (!$product) throw $this->createNotFoundException();
        $item = new CartItem();
        $item->setProduct($product)->setQuantity((int)$request->request->get('quantity', 1));
        $this->cartHandler->addProduct($item);
        $this->addFlash('success', '✅ Produit ajouté au panier!');
        return $this->redirectToRoute('cart_show');
    }

    #[Route('/cart/remove/{id}', name: 'cart_remove')]
    public function remove(int $id): Response
    {
        $this->cartHandler->removeProduct($id);
        $this->addFlash('info', 'Produit retiré du panier.');
        return $this->redirectToRoute('cart_show');
    }

    #[Route('/cart/clear', name: 'cart_clear')]
    public function clear(): Response
    {
        $this->cartHandler->clear();
        return $this->redirectToRoute('cart_show');
    }
}
