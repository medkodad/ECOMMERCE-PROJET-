<?php
namespace App\Form;
use App\Entity\User;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\NotBlank;

class RegistrationFormType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('fullName', TextType::class, ['label' => 'Nom complet', 'attr' => ['placeholder' => 'Votre nom']])
            ->add('email', EmailType::class, ['label' => 'Email', 'attr' => ['placeholder' => 'email@example.com']])
            ->add('plainPassword', RepeatedType::class, [
                'type' => PasswordType::class,
                'mapped' => false,
                'first_options' => ['label' => 'Mot de passe', 'attr' => ['placeholder' => '••••••••']],
                'second_options' => ['label' => 'Confirmer', 'attr' => ['placeholder' => '••••••••']],
                'constraints' => [new NotBlank(), new Length(['min' => 6])],
            ]);
    }
    public function configureOptions(OptionsResolver $resolver): void { $resolver->setDefaults(['data_class' => User::class]); }
}
