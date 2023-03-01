<?php

namespace Drupal\dc_general\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Block\BlockPluginInterface;
use Drupal\Core\Form\FormBuilderInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Access\AccessResult;
use Drupal\Core\Cache\Cache;

/**
 * Provides a 'FeedbackLinkBlock' Block.
 *
 * @Block(
 *   id = "feedbacklinkblock_block",
 *   admin_label = @Translation("Feedback Link block"),
 * )
 */
class FeedbackLinkBlock extends BlockBase {

  /**
   * {@inheritdoc}
   */
  public function build() {
    $config = $this->getConfiguration();
    $Feedback_Button_Label = isset($config['Feedback_Button_Label']) ? $config['Feedback_Button_Label'] : '';
    return [
      '#markup' => '<a class="use-ajax feedbackButton" data-dialog-type="modal" href="/contact/feedback" data-dialog-options="{&quot;width&quot;:600, &quot;dialogClass&quot;: &quot;feedbackModal&quot;}" target="_blank">' . $Feedback_Button_Label . ' <i class="fas fa-question-circle"></i></a>',
    ];
  }
  // in plain HTML -> <a class="use-ajax feedbackButton" data-dialog-type="modal" href="/contact/feedback" data-dialog-options="{&quot;width&quot;:600, &quot;dialogClass&quot;: &quot;feedbackModal&quot;}" target="_blank">Feedback <i class="fas fa-question-circle"></i></a>

   /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $form = parent::blockForm($form, $form_state);

    // Retrieve existing configuration for this block.
    $config = $this->getConfiguration();

    // Add a form field to the existing block configuration form.
    $form['Feedback_Button_Label'] = [
      '#type' => 'textfield',
      '#title' => t('Feedback Button Label'),
      '#default_value' => isset($config['Feedback_Button_Label']) ? $config['Feedback_Button_Label'] : '',
    ];
    
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    // Save our custom settings when the form is submitted.
    $this->setConfigurationValue('Feedback_Button_Label', $form_state->getValue('Feedback_Button_Label'));
  }

}

