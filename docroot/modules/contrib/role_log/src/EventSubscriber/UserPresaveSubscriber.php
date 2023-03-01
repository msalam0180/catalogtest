<?php

namespace Drupal\role_log\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Drupal\role_log\Event\UserPresaveEvent;
use Psr\Log\LoggerInterface;
use Drupal\user\Entity\User;

/**
 * Monitors all user save events and logs any role/status changes to watchdog.
 */
class UserPresaveSubscriber implements EventSubscriberInterface {

  /**
   * The logger interface object.
   *
   * @var \Psr\Log\LoggerInterface
   */
  protected $logger;

  /**
   * Constructs a logger object.
   *
   * @param \Psr\Log\LoggerInterface $logger
   *   A LoggerInterface object.
   */
  public function __construct(LoggerInterface $logger) {
    $this->logger = $logger;
  }

  /**
   * {@inheritdoc}
   */
  public static function getSubscribedEvents() {
    $events[UserPresaveEvent::USER_PRESAVE][] = ['onUserPresave'];
    return $events;
  }

  /**
   * Get the user being saved and see if there are role changes to log.
   *
   * @param \Drupal\role_log\Event\UserPresaveEvent $event
   *   A UserPresaveEvent event.
   */
  public function onUserPresave(UserPresaveEvent $event) {
    $user = $event->getUser();
    $this->logRoleChanges($user);
    $this->logStatusChanges($user);
  }

  /**
   * Log role changes.
   *
   * @param \Drupal\user\Entity\User $user
   *   A user entity.
   */
  protected function logRoleChanges(User $user) {
    // This is an update to an existing user.
    if ($user->original) {
      $original = $user->original;
      $old_roles = $original->getRoles();
      $new_roles = $user->getRoles();

      // Only log saves of existing users if there are role changes.
      if ($old_roles != $new_roles) {

        $this->logger->info("Roles for user %name (UID %uid) changed from %old to %new.", [
          '%old' => '[' . implode(", ", $old_roles) . ']',
          '%new' => '[' . implode(", ", $new_roles) . ']',
          '%uid' => $user->id(),
          '%name' => $user->getAccountName(),
        ]);
      }

    }
    // This is a new user.
    else {
      $new_roles = $user->getRoles();
      // New user hasn't been saved yet, so default role shows as anonymous
      // not authenticated.
      $new_roles = str_replace("anonymous", "authenticated", $new_roles);
      $this->logger->info("New user: %name created with roles %new.", [
        '%new' => '[' . implode(", ", $new_roles) . ']',
        '%name' => $user->getAccountName(),
      ]);
    }

  }

  /**
   * Log status changes.
   *
   * @param \Drupal\user\Entity\User $user
   *   A user entity.
   */
  protected function logStatusChanges(User $user) {
    // This is an update to an existing user.
    if ($user->original) {
      $original = $user->original;
      $old_status = ($original->isActive() ? 'active' : 'blocked');
      $new_status = ($user->isActive() ? 'active' : 'blocked');

      // Only log saves of existing users if there are status changes.
      if ($old_status != $new_status) {

        $this->logger->info("Status for user %name (UID %uid) changed from %old to %new.", [
          '%old' => $old_status,
          '%new' => $new_status,
          '%uid' => $user->id(),
          '%name' => $user->getAccountName(),
        ]);
      }

    }
    // This is a new user.
    else {
      $new_status = ($user->isActive() ? 'active' : 'blocked');
      $this->logger->info("New user: %name created with %new status.", [
        '%new' => $new_status,
        '%name' => $user->getAccountName(),
      ]);
    }

  }

}
