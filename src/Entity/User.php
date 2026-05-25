<?php
namespace App\Entity;
use App\Repository\UserRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
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

    #[ORM\OneToMany(mappedBy: 'user', targetEntity: Order::class)]
    private Collection $orders;

    public function __construct()
    {
        $this->orders = new ArrayCollection();
    }


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

    /**
     * @return Collection<int, Order>
     */
    public function getOrders(): Collection
    {
        return $this->orders;
    }

    public function addOrder(Order $order): static
    {
        if (!$this->orders->contains($order)) {
            $this->orders->add($order);
            $order->setUser($this);
        }

        return $this;
    }

    public function removeOrder(Order $order): static
    {
        if ($this->orders->removeElement($order)) {
            // set the owning side to null (unless already changed)
            if ($order->getUser() === $this) {
                $order->setUser(null);
            }
        }

        return $this;
    }
}
