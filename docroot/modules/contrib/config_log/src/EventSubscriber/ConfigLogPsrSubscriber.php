<?php

/**
 * @file
 * Contains \Drupal\config_log\ConfigPsrSubscriber.
 */

namespace Drupal\config_log\EventSubscriber;

use Drupal\Component\Utility\DiffArray;
use Drupal\Core\Config\Config;
use Drupal\Core\Config\ConfigCrudEvent;
use Drupal\Core\Config\ConfigEvents;
use Drupal\Core\Config\ConfigFactory;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Config\ConfigImporterEvent;
use Psr\Log\LoggerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

/**
 * Config subscriber.
 */
class ConfigLogPsrSubscriber extends ConfigLogSubscriberBase {

  /**
   * The log logger.
   *
   * @var \Psr\Log\LoggerInterface
   */
  protected $logger;

  /**
   * The type of the subscriber.
   *
   * @var string
   */
  public static $type = 'default';

  /**
   * {@inheritdoc}
   *
   * @param \Psr\Log\LoggerInterface $logger
   *   The log logger.
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory services.
   */
  public function __construct(LoggerInterface $logger, ConfigFactoryInterface $config_factory) {
    $this->logger = $logger;
    parent::__construct($config_factory);
  }

  /**
   * {@inheritdoc}
   */
  static function getSubscribedEvents() {
    $events[ConfigEvents::SAVE][] = ['onConfigSave', 20];
    $events[ConfigEvents::DELETE][] = ['onConfigSave', 20];
    $events[ConfigEvents::IMPORT][] = ['onConfigImport', 20];
    return $events;
  }

  /**
   * Save config.
   *
   * @param \Drupal\Core\Config\ConfigCrudEvent $event
   *   The config crud event.
   */
  public function onConfigSave(ConfigCrudEvent $event) {
    if (!$this->isEnabled()) {
      return;
    }
    $config = $event->getConfig();
    if ($this->isIgnored($config->getName())) {
      return;
    }
    $diff = DiffArray::diffAssocRecursive($config->get(), $config->getOriginal());
    $this->logConfigChanges($config, $diff);
  }

  /**
   * The config change.
   *
   * @param \Drupal\Core\Config\Config $config
   *   The configuration.
   * @param array $diff
   *   The diff array.
   * @param string $subkey
   *   The config subkey.
   */
  protected function logConfigChanges(Config $config, array $diff, string $subkey = '') {
    foreach ($diff as $key => $value) {
      $full_key = $key;
      if ($subkey) {
        $full_key = $this->joinKey($subkey, $key);
      }

      if (is_array($value)) {
        $this->logConfigChanges($config, $diff[$key], $full_key);
      }
      else {
        $this->logger->info("Configuration changed: %key changed from %original to %value", [
          '%key' => $this->joinKey($config->getName(), $full_key),
          '%original' => $this->format($config->getOriginal($full_key)),
          '%value' => $this->format($value),
        ]);
      }
    }
  }

  /**
   * React to configuration ConfigEvent::IMPORT events.
   *
   * @param \Drupal\Core\Config\ConfigImporterEvent $event
   *   The event to process.
   */
  public function onConfigImport(ConfigImporterEvent $event) {
    if (!$this->isEnabled() || $this->isConfigImportIgnored()) {
      return;
    }

    // Get the changelist and insert records for each change if not ignored.
    foreach ($event->getChangelist() as $operation => $config_names) {
      array_map(
        function ($config_name) use ($operation) {
          if (!$this->isIgnored($config_name)) {
            $this->logger->info("Configuration %operation: %key", ['%key' => $config_name, '%operation' => $operation]);
          }
        },
        $config_names
      );
    }
  }

  /**
   * The format value.
   *
   * @param mixed $value
   *   The value.
   *
   * @return mixed
   *   Return format.
   */
  private function format($value) {
    if ($value === NULL) {
      return "NULL";
    }

    if ($value === "") {
      return '<empty string>';
    }

    if (is_bool($value)) {
      return ($value ? 'TRUE' : 'FALSE');
    }

    return $value;
  }

  /**
   * The join config keys.
   *
   * @param string $subkey
   *   The sub key.
   * @param string $key
   *   The key.
   *
   * @return string
   *   Merged key.
   */
  private function joinKey($subkey, $key) {
    return $subkey . '.' . $key;
  }

}
