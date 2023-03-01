<?php

namespace Drupal\dc_forum\Plugin\Action;

use Drupal\Core\Action\ActionBase;
use Drupal\Core\Session\AccountInterface;
use Drupal\comment\Plugin\Field\FieldType\CommentItemInterface;

/**
 * Push term in front.
 *
 * @Action(
 *   id = "action_disable_comments_action",
 *   label = @Translation("Disable Comments"),
 *   type = "node"
 * )
 */
class DisableCommentsAction extends ActionBase {

  /**
   * {@inheritdoc}
   */
  public function execute($entity = NULL) {
    /** @var \Drupal\node\Entity\Node $entity */
    $entity->get('comment_forum')->status = CommentItemInterface::CLOSED;
    $entity->save();
  }

  /**
   * {@inheritdoc}
   */
  public function access($object, AccountInterface $account = NULL, $return_as_object = FALSE) {
    // Roles we're allowing.
    $allowed_roles = [
      'administrator',
      'content_approver',
      'sitebuilder',
      'forum_moderator',
    ];

    // If there current user has one of the roles allowed, proceed.
    if (count(array_intersect($account->getRoles(), $allowed_roles)) > 0) {
      return TRUE;
    }

    // User is not authorized.
    return FALSE;
  }

}
