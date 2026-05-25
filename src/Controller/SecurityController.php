<?php
namespace App\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;

final class SecurityController extends AbstractController
{
    #[Route('/login', name: 'app_login')]
    public function login(AuthenticationUtils $auth): Response
    {
        if ($this->getUser()) return $this->redirectToRoute('home');
        return $this->render('security/login.html.twig', [
            'last_username' => $auth->getLastUsername(),
            'error' => $auth->getLastAuthenticationError(),
        ]);
    }

    #[Route('/logout', name: 'app_logout')]
    public function logout(): never { throw new \LogicException('Intercepted by firewall.'); }
}
