<?php

namespace Drupal\comment_delete;

use Drupal\comment\CommentInterface;
use Drupal\Component\Plugin\Exception\InvalidPluginDefinitionException;
use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Core\Database\Connection;
use Drupal\Core\Entity\EntityFieldManagerInterface;
use Drupal\Core\Entity\EntityStorageException;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Messenger\MessengerInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;

/**
 * Provides comment delete manager.
 */
class CommentDeleteManager implements CommentDeleteManagerInterface {

  use StringTranslationTrait;

  /**
   * The database connection.
   *
   * @var \Drupal\Core\Database\Connection
   */
  protected Connection $connection;

  /**
   * The messenger.
   *
   * @var \Drupal\Core\Messenger\MessengerInterface
   */
  protected MessengerInterface $messenger;

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected EntityTypeManagerInterface $entityTypeManager;

  /**
   * The entity field manager.
   *
   * @var \Drupal\Core\Entity\EntityFieldManagerInterface
   */
  protected EntityFieldManagerInterface $entityFieldManager;

  /**
   * The comment thread manager.
   *
   * @var \Drupal\comment_delete\CommentThreadManagerInterface
   */
  protected CommentThreadManagerInterface $commentThreadManager;

  /**
   * The comment entity.
   *
   * @var \Drupal\comment\CommentInterface
   */
  protected CommentInterface $comment;

  /**
   * The comment delete configuration.
   *
   * @var array
   */
  protected array $config;

  /**
   * CommentDeleteManager constructor.
   *
   * @param \Drupal\Core\Database\Connection $connection
   *   The database connection.
   * @param \Drupal\Core\Messenger\MessengerInterface $messenger
   *   The messenger.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entityTypeManager
   *   The entity type manager.
   * @param \Drupal\Core\Entity\EntityFieldManagerInterface $entityFieldManager
   *   The entity field manager.
   * @param \Drupal\comment_delete\CommentThreadManagerInterface $commentThreadManager
   *   The comment thread manager.
   */
  public function __construct(Connection $connection, MessengerInterface $messenger, EntityTypeManagerInterface $entityTypeManager, EntityFieldManagerInterface $entityFieldManager, CommentThreadManagerInterface $commentThreadManager) {
    $this->connection = $connection;
    $this->messenger = $messenger;
    $this->entityTypeManager = $entityTypeManager;
    $this->entityFieldManager = $entityFieldManager;
    $this->commentThreadManager = $commentThreadManager;
  }

  /**
   * {@inheritdoc}
   */
  public function getConfig(CommentInterface $comment = NULL): array {
    if (!$comment) {
      $comment = $this->comment;
    }
    try {
      /** @var \Drupal\Core\Entity\FieldableEntityInterface $commentedEntity */
      $commentedEntity = $this->entityTypeManager->getStorage($comment->getCommentedEntityTypeId())
        ->load($comment->getCommentedEntityId());
    }
    catch (InvalidPluginDefinitionException | PluginNotFoundException $e) {
      return [];
    }
    /** @var \Drupal\field\FieldConfigInterface $fieldDefinition */
    $fieldDefinition = $commentedEntity->getFieldDefinition($comment->getFieldName());
    $config = $fieldDefinition->getThirdPartySettings('comment_delete');
    $config['commented_entity'] = $commentedEntity;
    return $config;
  }

  /**
   * {@inheritdoc}
   */
  public function delete(CommentInterface $comment, string $op): void {
    $this->comment = $comment;
    $this->config = $this->getConfig();

    switch ($op) {
      case 'hard':
        $this->hardDelete();
        break;

      case 'hard_partial':
        $this->moveReplies()->hardDelete(TRUE);
        break;

      case 'soft':
        $this->softDelete();
        break;
    }

    if (trim($this->config['message'][$op])) {
      $this->messenger->addStatus($this->config['message'][$op]);
    }
  }

  /**
   * {@inheritdoc}
   */
  public function moveReplies(): CommentDeleteManagerInterface {
    $storage = $this->entityTypeManager->getStorage('comment');

    // Get the comments immediate replies. Each is reassigned up one thread
    // level or parent comment is entirely removed when at the topmost level.
    if ($ids = $storage->getQuery()->accessCheck(FALSE)->condition('pid', $this->comment->id())->execute()) {
      foreach ($storage->loadMultiple($ids) as $reply) {
        /** @var \Drupal\comment\CommentInterface $reply */
        try {
          if ($this->comment->hasParentComment() && ($pid = $this->comment->getParentComment()->id())) {
            $reply->set('pid', $pid);
          }
          else {
            $reply->set('pid', NULL);
          }
          $reply->save();
        }
        catch (EntityStorageException $e) {
          watchdog_exception('comment_delete', $e);
        }
      }
    }

    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function hardDelete(bool $thread = FALSE): CommentDeleteManagerInterface {
    try {
      $this->comment->delete();
      if ($thread) {
        $this->commentThreadManager->calculate($this->config['commented_entity']);
      }
    }
    catch (EntityStorageException $e) {
      watchdog_exception('comment_delete', $e);
    }
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function softDelete(): CommentDeleteManagerInterface {
    $storage = $this->entityTypeManager->getStorage('comment');

    // Hard delete if the comment has no immediate replies.
    if (!$storage->getQuery()->accessCheck(FALSE)->condition('pid', $this->comment->id())->execute()) {
      return $this->hardDelete();
    }

    if ($this->config['mode'] === 'unpublished') {
      try {
        $this->comment->setUnpublished();
        $this->comment->save();
      }
      catch (EntityStorageException $e) {
        watchdog_exception('comment_delete', $e);
      }
    }
    else {
      $baseFields = array_keys($this->entityFieldManager->getBaseFieldDefinitions('comment'));
      $fields = array_diff(array_keys($this->comment->getFields(FALSE)), $baseFields);
      $fields[] = 'subject';

      // Unset all field values.
      foreach ($this->comment->getTranslationLanguages() as $translation) {
        /** @var \Drupal\comment\CommentInterface $entity */
        $entity = $this->comment->getTranslation($translation->getId());
        if ($this->config['anonymize']) {
          $entity->setOwnerId(0);
        }
        foreach ($fields as $field) {
          $entity->set($field, NULL);
        }
        try {
          $entity->save();
        }
        catch (EntityStorageException $e) {
          watchdog_exception('comment_delete', $e);
        }
      }
    }

    return $this;
  }

}
