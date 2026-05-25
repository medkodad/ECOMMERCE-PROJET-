<?php

namespace App\Controller;

use App\Entity\Order;
use App\Entity\OrderItem;
use App\Service\Cart\CartHandler;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_USER')]
class OrderController extends AbstractController
{
    #[Route('/cart/checkout', name: 'cart_checkout', methods: ['POST'])]
    public function checkout(CartHandler $cartHandler, EntityManagerInterface $em): Response
    {
        $cart = $cartHandler->getCart();

        if ($cart->getItems()->isEmpty()) {
            $this->addFlash('danger', 'Votre panier est vide.');
            return $this->redirectToRoute('cart_show');
        }

        $order = new Order();
        $order->setUser($this->getUser());
        $order->setReference(uniqid('ORD-'));
        $order->setStatus('PENDING');
        $order->setTotal($cart->getTotal());

        foreach ($cart->getItems() as $cartItem) {
            $orderItem = new OrderItem();
            $orderItem->setProduct($cartItem->getProduct());
            $orderItem->setQuantity($cartItem->getQuantity());
            $orderItem->setPrice($cartItem->getProduct()->getPrice());
            
            $order->addOrderItem($orderItem);
            $em->persist($orderItem);
        }

        $em->persist($order);
        $em->flush();

        $cartHandler->clear();

        return $this->redirectToRoute('order_success', ['id' => $order->getId()]);
    }

    #[Route('/order/success/{id}', name: 'order_success')]
    public function success(Order $order): Response
    {
        if ($order->getUser() !== $this->getUser()) {
            throw $this->createAccessDeniedException();
        }

        return $this->render('order/success.html.twig', [
            'order' => $order
        ]);
    }
}
