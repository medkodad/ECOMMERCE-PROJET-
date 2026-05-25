<?php

namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;

class OrderType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('address', TextType::class, [
                'label' => 'Adresse de livraison',
                'attr' => ['placeholder' => '123 Rue Exemple', 'class' => 'form-control']
            ])
            ->add('city', TextType::class, [
                'label' => 'Ville',
                'attr' => ['placeholder' => 'Casablanca', 'class' => 'form-control']
            ])
            ->add('postalCode', TextType::class, [
                'label' => 'Code postal',
                'attr' => ['placeholder' => '10000', 'class' => 'form-control']
            ]);
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([]);
    }
}
?>
