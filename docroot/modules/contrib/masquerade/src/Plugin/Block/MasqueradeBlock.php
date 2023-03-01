<?php

namespace Drupal\masquerade\Plugin\Block;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Cache\Cache;
use Drupal\Core\Form\FormBuilderInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\Session\AccountProxyInterface;
use Drupal\masquerade\Form\MasqueradeForm;
use Drupal\masquerade\Masquerade;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Url;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'Masquerade' block.
 *
 * @Block(
 *   id = "masquerade",
 *   admin_label = @Translation("Masquerade"),
 *   category = @Translation("Forms"),
 * )
 */
class MasqueradeBlock extends BlockBase implements ContainerFactoryPluginInterface {

  /**
   * The form builder service.
   *
   * @var \Drupal\Core\Form\FormBuilderInterface
   */
  protected $formBuilder;

  /**
   * The masquerade service.
   *
   * @var \Drupal\masquerade\Masquerade
   */
  protected $masquerade;

  /**
   * The current user.
   *
   * @var \Drupal\Core\Session\AccountProxyInterface
   */
  protected $currentUser;

  /**
   * Constructs a new MasqueradeBlock object.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin_id for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Form\FormBuilderInterface $form_builder
   *   The form builder service.
   * @param \Drupal\masquerade\Masquerade $masquerade
   *   The masquerade service.
   * @param \Drupal\Core\Session\AccountProxyInterface $current_user
   *   The current user.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, FormBuilderInterface $form_builder, Masquerade $masquerade, AccountProxyInterface $current_user) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);

    $this->formBuilder = $form_builder;
    $this->masquerade = $masquerade;
    $this->currentUser = $current_user;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('form_builder'),
      $container->get('masquerade'),
      $container->get('current_user')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $form = parent::blockForm($form, $form_state);
    $config = $this->getConfiguration();
    $form['show_unmasquerade_link'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Show unmasquerade link in block'),
      '#description' => $this->t('If checked, this block will show a "Switch back" link when the user is masquerading.'),
      '#default_value' => isset($config['show_unmasquerade_link']) ? $config['show_unmasquerade_link'] : '',
    ];
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    parent::blockSubmit($form, $form_state);
    $values = $form_state->getValues();
    $this->configuration['show_unmasquerade_link'] = $values['show_unmasquerade_link'];
  }

  /**
   * {@inheritdoc}
   */
  protected function blockAccess(AccountInterface $account) {
    if ($account->isAnonymous()) {
      // Do not allow masquerade as anonymous user, use private browsing.
      return AccessResult::forbidden();
    }
    if ($this->masquerade->isMasquerading()) {
      $config = $this->getConfiguration();
      if (empty($config['show_unmasquerade_link'])) {
        $access = AccessResult::forbidden();
      }
      else {
        $access = AccessResult::allowed();
      }
      return $access->addCacheContexts(['session.is_masquerading']);
    }
    // Display block for all users that has any of masquerade permissions.
    return AccessResult::allowedIfHasPermissions($account, $this->masquerade->getPermissions(), 'OR')
      ->addCacheContexts(['session.is_masquerading']);
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheContexts() {
    return Cache::mergeContexts(parent::getCacheContexts(), ['session.is_masquerading']);
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    if ($this->masquerade->isMasquerading()) {
      $config = $this->getConfiguration();
      if (empty($config['show_unmasquerade_link'])) {
        return [];
      }
      $url = Url::fromRoute('masquerade.unmasquerade')->toString();
      return [
        '#type' => 'markup',
        '#markup' => $this->t('You are masquerading as %name. <a href="@url">Switch back</a>.', ['%name' => $this->currentUser->getDisplayName(), '@url' => $url]),
        '#cache' => ['contexts' => ['session']],
      ];
    }
    return $this->formBuilder->getForm(MasqueradeForm::class);
  }

}
