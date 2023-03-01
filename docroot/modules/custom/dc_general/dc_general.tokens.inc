<?php

use Drupal\Core\Render\BubbleableMetadata;
use Drupal\Core\Entity\RevisionLogInterface;

/**
 * Implements hook_token_info_alter().
 */
function dc_general_token_info_alter($info) {
  $info['node']['revision-created'] = [
    'name' => t('Revision created time'),
    'description' => t('The time the latest revision was created.'),
    'type' => 'date',
  ];
  $info['node']['revision-log'] = [
    'name' => t('Revision log'),
    'description' => t('Log message for the most recent changes.'),
  ];
  $info['node']['revision-user'] = [
    'name' => t('Revision user'),
    'description' => t('The revision author.'),
    'type' => 'user',
  ];
  // \Drupal::logger('debugging')->warning(print_r($info['node'], TRUE));
}

/**
 * Implements hook_tokens().
 */
function dc_general_tokens($type, $tokens, array $data, array $options, BubbleableMetadata $bubbleable_metadata) {
  $replacements = [];
  // \Drupal::logger('debugging')->warning(print_r($data[$type], TRUE));
  if (isset($data[$type]) && $data[$type] instanceof RevisionLogInterface) {
    /** @var \Drupal\Core\Entity\RevisionLogInterface $entity */
    $entity = $data[$type];
    foreach ($tokens as $name => $original) {
      switch ($name) {
        case 'revision-created':
          $date_format = DateFormat::load('medium');
          $bubbleable_metadata->addCacheableDependency($date_format);
          $replacements[$original] = \Drupal::service('date.formatter')->format($entity->getRevisionCreationTime(), 'medium');
          break;

        case 'revision-log':
          $replacements[$original] = $entity->getRevisionLogMessage();
          break;

        case 'revision-user':
          // Chained tokens below.
          $author = $entity->getRevisionUser();
          $replacements[$original] = $author->getDisplayName();
          $bubbleable_metadata->addCacheableDependency($author);
          break;
      }
    }

    // Chained tokens.
    $token = \Drupal::token();
    if ($author_tokens = $token->findWithPrefix($tokens, 'revision-user')) {
      $replacements += $token->generate('user', $author_tokens, ['user' => $entity->getRevisionUser()], $options, $bubbleable_metadata);
    }
    if ($created_tokens = $token->findWithPrefix($tokens, 'revision-created')) {
      $replacements += $token->generate('date', $created_tokens, ['date' => $entity->getRevisionCreationTime()], $options, $bubbleable_metadata);
    }
  }

  return $replacements;
}