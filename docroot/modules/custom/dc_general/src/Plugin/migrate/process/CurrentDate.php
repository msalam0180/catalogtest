<?php

namespace Drupal\dc_general\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\dc_general\Plugin\migrate\process\CurrentDate.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use DateTime;
use DateTimeZone;

/**
 * Returns current date
 *
 * @MigrateProcessPlugin(
 *   id = "current_date"
 * )
 */
class CurrentDate extends ProcessPluginBase
{
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property)
  {
    $dt = new DateTime("now", new DateTimeZone("UTC"));
    return date_format($dt, 'Y-m-d\TH:i:s');
  }
}
