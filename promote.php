<?php
require __DIR__.'/vendor/autoload.php';

use App\Kernel;
use Symfony\Component\Dotenv\Dotenv;

(new Dotenv())->bootEnv(__DIR__.'/.env');
$kernel = new Kernel($_SERVER['APP_ENV'], (bool) $_SERVER['APP_DEBUG']);
$kernel->boot();

$em = $kernel->getContainer()->get('doctrine')->getManager();
$user = $em->getRepository(\App\Entity\User::class)->findOneBy(['email' => 'medkodad0@gmail.com']);
if ($user) {
    $user->setRoles(['ROLE_ADMIN']);
    $em->flush();
    echo "Role updated.\n";
} else {
    echo "User not found.\n";
}
