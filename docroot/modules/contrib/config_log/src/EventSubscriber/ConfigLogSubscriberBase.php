<?php

/**
 * @file
 * Contains \Drupal\config\ConfigSubscriberBase.
 */

namespace Drupal\config_log\EventSubscriber;

use Drupal\Core\Config\ConfigFactoryInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

/**
 * Config subscriber.
 */
abstract class ConfigLogSubscriberBase implements EventSubscriberInterface {
  /**
   * The Config.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * {@inheritdoc}
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory services.
   */
  public function __construct(ConfigFactoryInterface $config_factory) {
    $this->configFactory = $config_factory;
  }

  /**
   * Returns whether the subscriber is enabled.
   *
   * @return bool
   *   The config is enabled.
   */
  public function isEnabled() {
    $log_destination = $this->configFactory->get('config_log.settings')->get('log_destination');
    if (!empty($log_destination) && empty($log_destination[static::$type])) {
      return FALSE;
    }
    return TRUE;
  }

  /**
   * Returns whether the config import should be ignored.
   *
   * @return bool
   *   Config import logging status.
   */
  public function isConfigImportIgnored() {
    if ($this->configFactory->get('config_log.settings')->get('ignore_config_import')) {
      return TRUE;
    }
    return FALSE;
  }

  /**
   * Returns whether the config_name is ignored.
   *
   * @param string $config_name
   *   The config name variable.
   *
   * @return bool
   *   Config is ignored.
   */
  public function isIgnored($config_name) {
    $ignored_entities = $this->configFactory->get('config_log.settings')->get('log_ignored_config');
    if (!empty($ignored_entities)) {
      foreach ($ignored_entities as $ignore) {
        if (fnmatch($ignore, $config_name)) {
          return TRUE;
        }
      }
    }
    return FALSE;
  }

}
