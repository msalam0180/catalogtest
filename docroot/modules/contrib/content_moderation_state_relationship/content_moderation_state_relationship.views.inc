<?php

/**
 * @file
 * Views hooks file.
 */

use Drupal\content_moderation_state_relationship\ViewsData;

/**
 * Implements hook_views_data_alter().
 */
function content_moderation_state_relationship_views_data_alter(&$data) {
  (new ViewsData(
    \Drupal::service('entity_type.manager'),
    \Drupal::service('content_moderation.moderation_information')
  ))->alterViewsData($data);
}
