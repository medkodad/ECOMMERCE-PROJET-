<?php

namespace App\DTO;

class CartData
{
    public function __construct(
        public readonly array $items,
        public readonly float $totalPrice,
        public readonly int $totalQuantity
    ) {
    }
}
