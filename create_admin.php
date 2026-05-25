<?php
require __DIR__.'/vendor/autoload.php';

use App\Kernel;
use App\Entity\User;
use Symfony\Component\Dotenv\Dotenv;

(new Dotenv())->bootEnv(__DIR__.'/.env');
$kernel = new Kernel($_SERVER['APP_ENV'], (bool) $_SERVER['APP_DEBUG']);
$kernel->boot();

$em = $kernel->getContainer()->get('doctrine')->getManager();

$user = $em->getRepository(User::class)->findOneBy(['email' => 'admin@gmail.com']);

if (!$user) {
    $user = new User();
    $user->setEmail('admin@gmail.com');
}

$user->setFullName('Super Admin');
$user->setRoles(['ROLE_ADMIN']);
$user->setPassword(password_hash('admin123', PASSWORD_BCRYPT));

$em->persist($user);
$em->flush();

echo "Admin user ready.\n";
