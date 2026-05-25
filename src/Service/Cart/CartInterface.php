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
