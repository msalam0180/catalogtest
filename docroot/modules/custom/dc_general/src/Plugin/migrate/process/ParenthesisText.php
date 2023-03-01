<?php

namespace Drupal\dc_general\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\dc_general\Plugin\migrate\process\ParenthesisText.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * Returns an array of text in parenthesis.
 *
 * @see \Drupal\migrate\Plugin\MigrateProcessInterface
 *
 * @MigrateProcessPlugin(
 *   id = "parenthesis_text"
 * )
 */
class ParenthesisText extends ProcessPluginBase
{

    /**
   * {@inheritdoc}
   */
    public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) 
    {
        $returnVar = null;
        if (empty($value)) {
            // Skip this item if there's no value.
            throw new MigrateSkipProcessException();
        }
        if (str_contains($value, '(') && str_contains($value, ')')) {
            preg_match_all( '!\(([^\)]+)\)!', $value, $match );
            $returnVar = $match[1];
        }
        if (empty($returnVar)) $returnVar = array($value);
        
        return $returnVar;
    }
}
