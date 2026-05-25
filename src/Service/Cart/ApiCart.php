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
