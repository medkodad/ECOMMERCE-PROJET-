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
