<?php

namespace App\Form;

use App\Entity\CartItem;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\Min;
use Symfony\Component\Validator\Constraints\NotBlank;

class AddToCartType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('quantity', IntegerType::class, [
                'data' => 1,
                'constraints' => [
                    new NotBlank([
                        'message' => 'Please specify a quantity',
                    ]),
                    new Min([
                        'value' => 1,
                        'message' => 'Quantity must be at least {{ limit }}',
                    ]),
                ],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => CartItem::class,
        ]);
    }
}
