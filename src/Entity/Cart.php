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
