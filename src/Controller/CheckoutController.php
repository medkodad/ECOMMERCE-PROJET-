<?php

namespace App\Controller;

use App\Entity\Order;
use App\Form\OrderType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class CheckoutController extends AbstractController
{
    #[Route('/checkout', name: 'checkout')]
    public function index(Request $request, EntityManagerInterface $em): Response
    {
        // Create a new Order (user will be set later, e.g., after login)
        $order = new Order();
        $form = $this->createForm(OrderType::class, $order);

        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            // Here you could set additional fields like user, reference, total, status
            // For simplicity we set a placeholder reference and status
            $order->setReference('ORD-'.uniqid());
            $order->setStatus('pending');
            $order->setTotal(0); // total will be calculated later from cart items

            $em->persist($order);
            $em->flush();

            $this->addFlash('success', 'Order created successfully!');
            // Redirect to a success page or back to the cart summary
            return $this->redirectToRoute('checkout_success');
        }

        return $this->render('checkout/index.html.twig', [
            'checkoutForm' => $form->createView(),
        ]);
    }

    #[Route('/checkout/success', name: 'checkout_success')]
    public function success(): Response
    {
        return $this->render('checkout/success.html.twig');
    }
}
?>
