<?php

namespace App\Controller\Admin;

use App\Entity\Category;
use App\Entity\Order;
use App\Entity\Product;
use App\Entity\User;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class DashboardController extends AbstractDashboardController
{
    private EntityManagerInterface $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    #[Route('/admin', name: 'admin')]
    public function index(): Response
    {
        $stats = [
            'categories' => $this->entityManager->getRepository(Category::class)->count([]),
            'products' => $this->entityManager->getRepository(Product::class)->count([]),
            'orders' => $this->entityManager->getRepository(Order::class)->count([]),
            'users' => $this->entityManager->getRepository(User::class)->count([]),
        ];

        return $this->render('admin/dashboard.html.twig', [
            'stats' => $stats,
        ]);
    }

    public function configureDashboard(): Dashboard
    {
        return Dashboard::new()
            ->setTitle('EHEI Shop Admin');
    }

    public function configureMenuItems(): iterable
    {
        yield MenuItem::linkToDashboard('Dashboard', 'fa fa-home');
        yield MenuItem::linkToCrud('Categories', 'fas fa-list', Category::class);
        yield MenuItem::linkToCrud('Products', 'fas fa-box', Product::class);
        yield MenuItem::linkToCrud('Orders', 'fas fa-shopping-cart', Order::class);
        yield MenuItem::linkToCrud('Users', 'fas fa-users', User::class);
        yield MenuItem::linkToRoute('Back to website', 'fas fa-arrow-left', 'home');
    }
}
