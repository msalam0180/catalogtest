<?php

namespace Drupal\dc_feeds\EventSubscriber;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\feeds\Event\CleanEvent;
use Drupal\feeds\Event\EntityEvent;
use Drupal\feeds\Event\FeedsEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

/**
 *
 */
class ParagraphFeedSubscriber implements EventSubscriberInterface {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected EntityTypeManagerInterface $entityTypeManager;

  /**
   * Retrieve entity type manager service from constructor.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_typed_manager
   */
  public function __construct(EntityTypeManagerInterface $entity_typed_manager) {
    $this->entityTypeManager = $entity_typed_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function getSubscribedEvents() {
    $events = [];
    $events[FeedsEvents::PROCESS_ENTITY_PRESAVE][] = 'presave';
    $events[FeedsEvents::PROCESS_ENTITY_POSTSAVE][] = 'postsave';
    $events[FeedsEvents::CLEAN][] = 'clean';
    return $events;
  }

  /**
   * Acts on presaving an entity.
   *
   * @param EntityEvent $event
   *
   * @return EntityEvent $event
   */
  public function presave(EntityEvent $event) {
  }

  public function clean(CleanEvent $event) {
    $entity = $event->getEntity();
    $entity->state = 'clean';
    return $event;
  }

  /**
   * Acts on presaving an entity.
   *
   * @param EntityEvent $event
   *
   * @return EntityEvent|void $event
   */
  public function postsave(EntityEvent $event) {
    $feed = $event->getFeed();
    $feeds = ['feeds_feed_type'];
    $id = $feed->getType()->getEntityTypeId();
    $entity = $event->getEntity();
    $entityType = $entity->getEntityType()->id();
    if (in_array($id, $feeds) && $entityType == 'paragraph') {
      $parent_field_name = $entity->parent_field_name->value;
      $parent_id = $entity->parent_id->value;
      if (!$parent_id) {
        return;
      }
      $vid = $this->entityTypeManager
        ->getStorage('node')
        ->getLatestRevisionId($parent_id);
      if (!$vid) {
        return;
      }
      $part = $this->entityTypeManager
        ->getStorage('node')
        ->loadRevision($vid);
      $paragraph_references = $part->get($parent_field_name)
        ->referencedEntities();
      $paragraph_references_id = [];
      if ($paragraph_references) {
        foreach ($paragraph_references as $paragraph_reference) {
          $paragraph_references_id[] = $paragraph_reference->id();
        }
      }
      if (!in_array($entity->id(), $paragraph_references_id)) {
        if ($part) {
          $part->{$parent_field_name}[] = $entity;
          $part->save();
        }
      }
    }
  }

}
