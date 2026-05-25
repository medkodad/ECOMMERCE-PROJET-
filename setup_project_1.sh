#!/bin/bash
set -e
PROJECT_DIR="$HOME/ecommerce_projet_ehei"
cd "$PROJECT_DIR"

echo "🚀 Setup EHEI E-Commerce Symfony..."

# ─── docker-compose.yml ───────────────────────────────────────────────────────
cat > docker-compose.yml << 'EOF'
services:
  database:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ecommerce_ehei
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
EOF

# ─── .env (DATABASE_URL) ──────────────────────────────────────────────────────
sed -i 's|DATABASE_URL=.*|DATABASE_URL="mysql://root:root@127.0.0.1:3306/ecommerce_ehei?serverVersion=8.0"|' .env

# ─── Install packages ─────────────────────────────────────────────────────────
composer require --ignore-platform-reqs symfony/orm-pack symfony/security-bundle \
  symfony/form symfony/validator symfony/twig-bundle \
  symfony/asset twig/extra-bundle --no-interaction

echo "✅ Packages installed"

# ─── ENTITIES ─────────────────────────────────────────────────────────────────
mkdir -p src/Entity src/Repository

cat > src/Entity/Category.php << 'EOF'
<?php
namespace App\Entity;
use App\Repository\CategoryRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: CategoryRepository::class)]
class Category
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(type: 'text', nullable: true)]
    private ?string $description = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $icon = null;

    #[ORM\OneToMany(mappedBy: 'category', targetEntity: Product::class)]
    private Collection $products;

    public function __construct() { $this->products = new ArrayCollection(); }
    public function getId(): ?int { return $this->id; }
    public function getName(): ?string { return $this->name; }
    public function setName(string $name): self { $this->name = $name; return $this; }
    public function getDescription(): ?string { return $this->description; }
    public function setDescription(?string $d): self { $this->description = $d; return $this; }
    public function getIcon(): ?string { return $this->icon; }
    public function setIcon(?string $i): self { $this->icon = $i; return $this; }
    public function getProducts(): Collection { return $this->products; }
}
EOF

cat > src/Entity/Product.php << 'EOF'
<?php
namespace App\Entity;
use App\Repository\ProductRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ProductRepository::class)]
class Product
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(type: 'text')]
    private ?string $description = null;

    #[ORM\Column]
    private ?float $price = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $image = null;

    #[ORM\Column(nullable: true)]
    private ?int $stock = null;

    #[ORM\ManyToOne(inversedBy: 'products')]
    private ?Category $category = null;

    public function getId(): ?int { return $this->id; }
    public function getName(): ?string { return $this->name; }
    public function setName(string $n): self { $this->name = $n; return $this; }
    public function getDescription(): ?string { return $this->description; }
    public function setDescription(string $d): self { $this->description = $d; return $this; }
    public function getPrice(): ?float { return $this->price; }
    public function setPrice(float $p): self { $this->price = $p; return $this; }
    public function getImage(): ?string { return $this->image; }
    public function setImage(?string $i): self { $this->image = $i; return $this; }
    public function getStock(): ?int { return $this->stock; }
    public function setStock(?int $s): self { $this->stock = $s; return $this; }
    public function getCategory(): ?Category { return $this->category; }
    public function setCategory(?Category $c): self { $this->category = $c; return $this; }
}
EOF

cat > src/Entity/Cart.php << 'EOF'
<?php
namespace App\Entity;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class Cart
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\OneToMany(mappedBy: 'cart', targetEntity: CartItem::class, cascade: ['persist', 'remove'])]
    private Collection $items;

    public function __construct() { $this->items = new ArrayCollection(); }
    public function getId(): ?int { return $this->id; }
    public function getItems(): Collection { return $this->items; }
    public function addItem(CartItem $item): self { if (!$this->items->contains($item)) { $this->items[] = $item; $item->setCart($this); } return $this; }
    public function getTotal(): float { return array_sum(array_map(fn($i) => $i->getProduct()->getPrice() * $i->getQuantity(), $this->items->toArray())); }
    public function getCount(): int { return array_sum(array_map(fn($i) => $i->getQuantity(), $this->items->toArray())); }
}
EOF

cat > src/Entity/CartItem.php << 'EOF'
<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class CartItem
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne]
    private ?Product $product = null;

    #[ORM\Column]
    private int $quantity = 1;

    #[ORM\ManyToOne(inversedBy: 'items')]
    private ?Cart $cart = null;

    public function getId(): ?int { return $this->id; }
    public function getProduct(): ?Product { return $this->product; }
    public function setProduct(?Product $p): self { $this->product = $p; return $this; }
    public function getQuantity(): int { return $this->quantity; }
    public function setQuantity(int $q): self { $this->quantity = $q; return $this; }
    public function getCart(): ?Cart { return $this->cart; }
    public function setCart(?Cart $c): self { $this->cart = $c; return $this; }
}
EOF

cat > src/Entity/User.php << 'EOF'
<?php
namespace App\Entity;
use App\Repository\UserRepository;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface;
use Symfony\Component\Security\Core\User\UserInterface;

#[ORM\Entity(repositoryClass: UserRepository::class)]
#[ORM\UniqueConstraint(name: 'UNIQ_EMAIL', fields: ['email'])]
class User implements UserInterface, PasswordAuthenticatedUserInterface
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 180)]
    private ?string $email = null;

    #[ORM\Column]
    private array $roles = [];

    #[ORM\Column]
    private ?string $password = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $fullName = null;

    public function getId(): ?int { return $this->id; }
    public function getEmail(): ?string { return $this->email; }
    public function setEmail(string $e): self { $this->email = $e; return $this; }
    public function getUserIdentifier(): string { return (string) $this->email; }
    public function getRoles(): array { $r = $this->roles; $r[] = 'ROLE_USER'; return array_unique($r); }
    public function setRoles(array $r): self { $this->roles = $r; return $this; }
    public function getPassword(): ?string { return $this->password; }
    public function setPassword(string $p): self { $this->password = $p; return $this; }
    public function getFullName(): ?string { return $this->fullName; }
    public function setFullName(?string $n): self { $this->fullName = $n; return $this; }
    public function eraseCredentials(): void {}
}
EOF

echo "✅ Entities created"

# ─── REPOSITORIES ─────────────────────────────────────────────────────────────
cat > src/Repository/CategoryRepository.php << 'EOF'
<?php
namespace App\Repository;
use App\Entity\Category;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class CategoryRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry) { parent::__construct($registry, Category::class); }
}
EOF

cat > src/Repository/ProductRepository.php << 'EOF'
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
EOF

cat > src/Repository/UserRepository.php << 'EOF'
<?php
namespace App\Repository;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface;
use Symfony\Component\Security\Core\User\PasswordUpgraderInterface;

class UserRepository extends ServiceEntityRepository implements PasswordUpgraderInterface
{
    public function __construct(ManagerRegistry $registry) { parent::__construct($registry, User::class); }
    public function upgradePassword(PasswordAuthenticatedUserInterface $user, string $newHashedPassword): void
    {
        if (!$user instanceof User) throw new UnsupportedUserException(sprintf('Instances of "%s" are not supported.', $user::class));
        $user->setPassword($newHashedPassword);
        $this->getEntityManager()->persist($user);
        $this->getEntityManager()->flush();
    }
}
EOF

echo "✅ Repositories created"

# ─── SERVICES (SOLID) ─────────────────────────────────────────────────────────
mkdir -p src/Service/Cart

cat > src/Service/Cart/CartInterface.php << 'EOF'
<?php
namespace App\Service\Cart;
use App\Entity\Cart;
use App\Entity\CartItem;

interface CartInterface
{
    public function add(CartItem $item, Cart $cart): Cart;
    public function remove(int $productId, Cart $cart): Cart;
    public function getCart(string $identifier): Cart;
    public function clearCart(string $identifier): void;
}
EOF

cat > src/Service/Cart/SessionCart.php << 'EOF'
<?php
namespace App\Service\Cart;
use App\Entity\Cart;
use App\Entity\CartItem;
use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\RequestStack;

class SessionCart implements CartInterface
{
    public function __construct(
        private RequestStack $requestStack,
        private EntityManagerInterface $em
    ) {}

    private function getSession() { return $this->requestStack->getSession(); }

    public function add(CartItem $item, Cart $cart): Cart
    {
        $items = $this->getSession()->get('cart', []);
        $pid = $item->getProduct()->getId();
        if (isset($items[$pid])) {
            $items[$pid]['qty'] += $item->getQuantity();
        } else {
            $items[$pid] = ['product_id' => $pid, 'qty' => $item->getQuantity()];
        }
        $this->getSession()->set('cart', $items);
        return $this->getCart('session');
    }

    public function remove(int $productId, Cart $cart): Cart
    {
        $items = $this->getSession()->get('cart', []);
        unset($items[$productId]);
        $this->getSession()->set('cart', $items);
        return $this->getCart('session');
    }

    public function getCart(string $identifier): Cart
    {
        $cart = new Cart();
        $items = $this->getSession()->get('cart', []);
        foreach ($items as $data) {
            $product = $this->em->getRepository(Product::class)->find($data['product_id']);
            if ($product) {
                $item = new CartItem();
                $item->setProduct($product)->setQuantity($data['qty']);
                $cart->addItem($item);
            }
        }
        return $cart;
    }

    public function clearCart(string $identifier): void
    {
        $this->getSession()->remove('cart');
    }
}
EOF

cat > src/Service/Cart/ApiCart.php << 'EOF'
<?php
namespace App\Service\Cart;
use App\Entity\Cart;
use App\Entity\CartItem;

class ApiCart implements CartInterface
{
    public function add(CartItem $item, Cart $cart): Cart { return $cart; }
    public function remove(int $productId, Cart $cart): Cart { return $cart; }
    public function getCart(string $identifier): Cart { return new Cart(); }
    public function clearCart(string $identifier): void {}
}
EOF

cat > src/Service/Cart/CartHandler.php << 'EOF'
<?php
namespace App\Service\Cart;
use App\Entity\Cart;
use App\Entity\CartItem;

class CartHandler
{
    public function __construct(private CartInterface $cartService) {}

    public function getCart(): Cart { return $this->cartService->getCart('session'); }
    public function addProduct(CartItem $item): Cart { return $this->cartService->add($item, $this->getCart()); }
    public function removeProduct(int $productId): Cart { return $this->cartService->remove($productId, $this->getCart()); }
    public function clear(): void { $this->cartService->clearCart('session'); }
}
EOF

echo "✅ Services created"

# ─── CONTROLLERS ──────────────────────────────────────────────────────────────
mkdir -p src/Controller

cat > src/Controller/HomeController.php << 'EOF'
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
EOF

cat > src/Controller/ProductController.php << 'EOF'
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
EOF

cat > src/Controller/CategoryController.php << 'EOF'
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
EOF

cat > src/Controller/CartController.php << 'EOF'
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
EOF

cat > src/Controller/SecurityController.php << 'EOF'
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
EOF

cat > src/Controller/RegistrationController.php << 'EOF'
<?php
namespace App\Controller;
use App\Entity\User;
use App\Form\RegistrationFormType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;

final class RegistrationController extends AbstractController
{
    #[Route('/register', name: 'app_register')]
    public function register(Request $request, UserPasswordHasherInterface $hasher, EntityManagerInterface $em): Response
    {
        if ($this->getUser()) return $this->redirectToRoute('home');
        $user = new User();
        $form = $this->createForm(RegistrationFormType::class, $user);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $user->setPassword($hasher->hashPassword($user, $form->get('plainPassword')->getData()));
            $em->persist($user);
            $em->flush();
            $this->addFlash('success', '🎉 Compte créé! Connectez-vous.');
            return $this->redirectToRoute('app_login');
        }
        return $this->render('security/register.html.twig', ['form' => $form->createView()]);
    }
}
EOF

cat > src/Controller/ProfileController.php << 'EOF'
<?php
namespace App\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_USER')]
final class ProfileController extends AbstractController
{
    #[Route('/profile', name: 'profile')]
    public function index(): Response
    {
        return $this->render('profile/index.html.twig', ['user' => $this->getUser()]);
    }
}
EOF

echo "✅ Controllers created"

# ─── FORMS ────────────────────────────────────────────────────────────────────
mkdir -p src/Form

cat > src/Form/RegistrationFormType.php << 'EOF'
<?php
namespace App\Form;
use App\Entity\User;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\NotBlank;

class RegistrationFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('fullName', TextType::class, ['label' => 'Nom complet', 'attr' => ['placeholder' => 'Votre nom']])
            ->add('email', EmailType::class, ['label' => 'Email', 'attr' => ['placeholder' => 'email@example.com']])
            ->add('plainPassword', RepeatedType::class, [
                'type' => PasswordType::class,
                'mapped' => false,
                'first_options' => ['label' => 'Mot de passe', 'attr' => ['placeholder' => '••••••••']],
                'second_options' => ['label' => 'Confirmer', 'attr' => ['placeholder' => '••••••••']],
                'constraints' => [new NotBlank(), new Length(['min' => 6])],
            ]);
    }
    public function configureOptions(OptionsResolver $resolver): void { $resolver->setDefaults(['data_class' => User::class]); }
}
EOF

echo "✅ Forms created"

# ─── SECURITY CONFIG ──────────────────────────────────────────────────────────
cat > config/packages/security.yaml << 'EOF'
security:
    password_hashers:
        Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface: 'auto'
    providers:
        app_user_provider:
            entity:
                class: App\Entity\User
                property: email
    firewalls:
        dev:
            pattern: ^/(_(profiler|wdt)|css|images|js)/
            security: false
        main:
            lazy: true
            provider: app_user_provider
            form_login:
                login_path: app_login
                check_path: app_login
                default_target_path: home
            logout:
                path: app_logout
                target: home
    access_control:
        - { path: ^/profile, roles: ROLE_USER }
EOF

echo "✅ Security configured"

# ─── SERVICES CONFIG ──────────────────────────────────────────────────────────
cat >> config/services.yaml << 'EOF'

    App\Service\Cart\CartInterface:
        alias: App\Service\Cart\SessionCart

    App\Service\Cart\CartHandler:
        arguments:
            $cartService: '@App\Service\Cart\SessionCart'
EOF

echo "✅ Services configured"

# ─── TEMPLATES ────────────────────────────────────────────────────────────────
mkdir -p templates/{home,product,category,cart,security,profile}
