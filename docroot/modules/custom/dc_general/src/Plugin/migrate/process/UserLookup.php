<?php

namespace Drupal\dc_general\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\dc_general\Plugin\migrate\process\UserLookup.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * Returns uid of user based on an user email
 *
 * @MigrateProcessPlugin(
 *   id = "user_lookup"
 * )
 */
class UserLookup extends ProcessPluginBase
{
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property)
  {
    if (empty($value)) {
      // Skip this item if there's no value.
      throw new MigrateSkipProcessException();
    }
    $user = \Drupal::database()->query('SELECT uid from users_field_data WHERE LOWER(name) = LOWER(:name)',[':name'=> strtolower($value)])->fetchField();
    if (!empty($user)) {
      return $user;
    }
    return null;
  }
}
