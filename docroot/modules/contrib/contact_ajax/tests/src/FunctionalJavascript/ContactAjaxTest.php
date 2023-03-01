<?php

namespace Drupal\Tests\contact_ajax\FunctionalJavascript;

use Drupal\FunctionalJavascriptTests\WebDriverTestBase;


/**
 * Tests contact form ajax submission.
 *
 * @group contact_ajax
 */
class ContactAjaxTest extends WebDriverTestBase {

  /**
   * {@inheritdoc}
   */
  protected $defaultTheme = 'stark';

  /**
   * Modules to enable.
   *
   * @var array
   */
  public static $modules = [
    'node',
    'text',
    'block',
    'contact',
    'contact_test',
    'field_ui',
    'contact_ajax',
  ];

  /**
   * Tests contact messages submitted through contact form.
   */
  public function testContactAjax() {
    $this->drupalPlaceBlock('system_breadcrumb_block');
    $this->drupalPlaceBlock('local_actions_block');
    $this->drupalPlaceBlock('page_title_block');

    // Create and login administrative user.
    $admin_user = $this->drupalCreateUser([
      'access site-wide contact form',
      'administer contact forms',
      'administer users',
      'administer account settings',
      'administer contact_message fields',
      'administer contact_message form display',
      'administer contact_message display',
    ]);
    $this->drupalLogin($admin_user);

    // Test if ajax settings has been added.
    $this->drupalGet('admin/structure/contact/add');
    $this->assertSession()->pageTextContains(t('Ajax Form'));

    $this->configureContactAjax();
    $this->sendContactAjax();
  }

  /**
   * Add a contact form for each confirmation_type available.
   */
  public function configureContactAjax() {

    $common = [
      'label' => 'test_label',
      'recipients' => 'simpletest@example.com',
      'reply' => '',
      'selected' => TRUE,
      'contact_ajax_enabled' => TRUE,
    ];

    // Create a basic ajac contact.
    $edit = [];
    $edit['id'] = 'test_id';
    $edit['contact_ajax_confirmation_type'] = CONTACT_AJAX_LOAD_DEFAULT_MESSAGE;
    $this->createContactAjaxForm($common, $edit);

    // Add a new contact form to test the custom message confirmation type
    // this form should be reload a custom text.
    $edit = [];
    $edit['id'] = 'test_custom_message_id';
    $edit['contact_ajax_confirmation_type'] = CONTACT_AJAX_LOAD_FROM_MESSAGE;
    $edit['contact_ajax_load_from_message[value]'] = '<div><b>test ajax message</b></div>';
    $this->createContactAjaxForm($common, $edit);

    // Add a new contact form to test the node content confirmation type
    // this form should be reload a node content.
    $edit = [];
    $edit['id'] = 'test_node_content';
    $edit['contact_ajax_confirmation_type'] = CONTACT_AJAX_LOAD_FROM_URI;
    // Create a content type.
    $this->drupalCreateContentType(['type' => 'article', 'name' => 'Article']);
    $node = $this->drupalCreateNode([
      'title' => 'test ajax title',
      'type' => 'article',
    ]);
    $edit['contact_ajax_load_from_uri'] = 'test ajax title (' . $node->id() . ')';
    $this->createContactAjaxForm($common, $edit);

    // Create a form that reload the content on another div element.
    $edit = [];
    $edit['id'] = 'test_load_other_element';
    $edit['contact_ajax_confirmation_type'] = CONTACT_AJAX_LOAD_DEFAULT_MESSAGE;
    $edit['contact_ajax_prefix_id'] = 'ajax-contact-prefix';
    $edit['contact_ajax_render_selector'] = '#ajax-contact-prefix';
    $this->createContactAjaxForm($common, $edit);

    // Create a form that reload the content without the form.
    $edit = [];
    $edit['id'] = 'test_load_with_validation_errors';
    $edit['contact_ajax_confirmation_type'] = CONTACT_AJAX_LOAD_DEFAULT_MESSAGE;
    $this->createContactAjaxForm($common, $edit);

    // Ensure that anonymous can submit site-wide contact form.
    user_role_grant_permissions(ANONYMOUS_ID, ['access site-wide contact form']);
    $this->drupalLogout();
  }

  /**
   * Create a contact form.
   */
  public function createContactAjaxForm($common, $edit) {
    $assert = $this->assertSession();

    $message = 'Your message has been sent.';
    // 8.2.x added the message field, which is by default empty. Conditionally
    // submit it if the field can be found.
    $this->drupalGet('admin/structure/contact/add');
    if ($this->xpath($this->constructFieldXpath('name', 'message'))) {
      $edit['message'] = $message;
    }

    // First submit the common configs. Because 'id' fields and ajax
    // 'advanced settings' are not available until this first step is done, we
    // can't submit all at once.
    $this->drupalPostForm(NULL, $common, t('Save'));

    // Open the advanced settings.
    $this->click('#edit-advanced summary');
    $assert->waitForElementVisible('css', '[name="contact_ajax_prefix_id"]');
    // Make sure the id field is visible.
    $assert->waitForElementVisible('css', '[name="id"]');

    // Post the full form.
    $this->drupalPostForm(NULL, $common + $edit, t('Save'));

    $assert->pageTextContains(t('Contact form test_label has been added.'));
  }

  /**
   * Send each contact form testing respect and the confirmation_type.
   */
  public function sendContactAjax() {
    $assert = $this->assertSession();

    // Build common data for tests.
    $edit = [];
    $edit['name'] = 'Test name';
    $edit['mail'] = 'simpletest@example.com';
    $edit['subject[0][value]'] = 'test subject';
    $edit['message[0][value]'] = 'test message';

    // Send form reload the same form.
    $form_id = 'test_id';
    $this->drupalGet('contact/' . $form_id);
    $this->drupalPostForm(NULL, $edit, t('Send message'));
    $assert->assertWaitOnAjaxRequest();
    $assert->pageTextContains('Your message has been sent.', '[OK] Your message has been sent.');

    // Submit form reload custom message.
    $form_id = 'test_custom_message_id';
    $this->drupalGet('contact/' . $form_id);
    $this->drupalPostForm(NULL, $edit, t('Send message'));
    $assert->assertWaitOnAjaxRequest();
    $assert->pageTextContains('test ajax message', '[OK] test ajax message.');

    // Send form reload another node.
    $form_id = 'test_node_content';
    $this->drupalGet('contact/' . $form_id);
    $this->drupalPostForm(NULL, $edit, t('Send message'));
    $assert->assertWaitOnAjaxRequest();
    $assert->pageTextContains('test ajax title', '[OK] test ajax title');

    // Send form reload another element.
    $form_id = 'test_load_other_element';
    $this->drupalGet('contact/' . $form_id);
    $assert->responseContains('id="ajax-contact-prefix"', '[OK] ajax prefix wrapper added');
    $this->drupalPostForm(NULL, $edit, t('Send message'));
    $assert->assertWaitOnAjaxRequest();
    $assert->pageTextContains('Your message has been sent.', '[OK] Your message has been sent.');
    $assert->responseNotContains('<form', '[OK] Form has been removed.');

    // Send uncomplete form shows validation errors.
    unset($edit['name']);
    $form_id = 'test_load_with_validation_errors';
    $this->drupalGet('contact/' . $form_id);
    $this->drupalPostForm(NULL, $edit, t('Send message'));
    $assert->assertWaitOnAjaxRequest();
    $assert->pageTextContains('Your name field is required.', '[OK] test render with form errors.');
  }
}
