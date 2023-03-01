<?php
namespace Drupal\dc_general\Plugin\Validation\Constraint;

use Drupal\Core\Config\ConfigFactory;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\Core\StringTranslation\TranslationInterface;
use Drupal\media\MediaInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;
use Drupal\Core\DependencyInjection\ContainerInjectionInterface;

/**
 * Validates the MediaTitleConstraint constraint.
 */
class MediaTitleConstraintValidator extends ConstraintValidator implements ContainerInjectionInterface {

  use StringTranslationTrait;

  /**
   * Entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Config factory.
   *
   * @var \Drupal\Core\Config\ConfigFactory
   */
  protected $configFactory;

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('entity_type.manager'),
      $container->get('config.factory'),
      $container->get('string_translation')
    );
  }

    /**
   * Constructs a new MediaTitleConstraintValidator.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entityTypeManager
   *   Entity type manager service.
   * @param \Drupal\Core\Config\ConfigFactory $configFactory
   *   Config factory service.
   * @param \Drupal\Core\StringTranslation\TranslationInterface $stringTranslation
   *   The string translation.
   */
  public function __construct(EntityTypeManagerInterface $entityTypeManager, ConfigFactory $configFactory, TranslationInterface $stringTranslation) {
    $this->entityTypeManager = $entityTypeManager;
    $this->configFactory = $configFactory;
    $this->stringTranslation = $stringTranslation;
  }

  /**
   * {@inheritdoc}
   */
  public function validate($items, Constraint $constraint) {
    if ($items->isEmpty()) {
      return;
    }

    // Get the user entered title.
    $value_title = $items->value;
    if (empty($value_title)) {
      return;
    }

    // Get host media.
    $media = $items->getEntity();
    if (!$media instanceof MediaInterface) {
      return;
    }

    // Get host media type.
    $media_type = $media->bundle();
    if (empty($media_type)) {
      return;
    }

    $mediaStorage = $this->entityTypeManager->getStorage('media');

    $properties = ['name' => $value_title];
    $properties['bundle'] = $media_type;
    $medias = $mediaStorage->loadByProperties($properties);
    // Remove current media form list.
    if (isset($medias[$media->id()])) {
      unset($medias[$media->id()]);
    }
    // Show error.
    if (!empty($medias)) {
      $message = $this->t("The name must be unique. Other media is already using this name: <a target='_blank' href='@mediaurl'>@name</a>", ['@mediaurl'=> reset($medias)->toUrl()->toString(), '@name' => $value_title]);
      $this->context->addViolation($message);
    }

  }

}