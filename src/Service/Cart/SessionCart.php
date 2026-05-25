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
