<?php
namespace App\Service\Cart;
use App\Entity\Cart;
use App\Entity\CartItem;

class CartHandler
{
    public function __construct(
        #[\Symfony\Component\DependencyInjection\Attribute\Autowire(service: SessionCart::class)]
        private CartInterface $cartService
    ) {}

    public function getCart(): Cart { return $this->cartService->getCart('session'); }
    public function addProduct(CartItem $item): Cart { return $this->cartService->add($item, $this->getCart()); }
    public function removeProduct(int $productId): Cart { return $this->cartService->remove($productId, $this->getCart()); }
    public function clear(): void { $this->cartService->clearCart('session'); }
}
