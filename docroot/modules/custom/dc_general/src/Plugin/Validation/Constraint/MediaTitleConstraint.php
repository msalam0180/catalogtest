<?php

namespace Drupal\dc_general\Plugin\Validation\Constraint;

use Symfony\Component\Validator\Constraint;

/**
 * Enforces unique media titles.
 *
 * @Constraint(
 *   id = "MediaTitleConstraint",
 *   label = @Translation("Enforces unique media titles", context="Validation"),
 *   type = "entity"
 * )
 */
class MediaTitleConstraint extends Constraint {

}