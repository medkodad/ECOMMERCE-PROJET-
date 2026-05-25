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
