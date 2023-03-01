<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Context\DrupalContext;
use Behat\MinkExtension\Context\RawMinkContext;
use Drupal\DrupalExtension\Hook\Scope\EntityScope;
use Behat\Mink\Exception\UnsupportedDriverActionException;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Testwork\Hook\Scope\BeforeSuiteScope;


/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements Context
{
  /** @var \Behat\MinkExtension\Context\MinkContext */
  private $minkContext;

    /**
     * @BeforeScenario
     */
    public function gatherContexts(BeforeScenarioScope $scope)
    {
      $environment = $scope->getEnvironment();
      $this->minkContext = $environment->getContext('Drupal\DrupalExtension\Context\MinkContext');
    }

   /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
  }

  /**
   * remove all media which have list page testing
   * before running suite to allow list page tests to run
   * @BeforeSuite
   */
  public static function removeData(BeforeSuiteScope $scope) {
    //remove all content type nodes which have list page testing
    //before running suite to allow list page tests to run
    $types = array('application', 'article', 'chart', 'forum', 'component', 'data_insight', 'data_set', 'forms', 'image', 'platform', 'statistics', 'tools');
    $database = \Drupal::database();
    $storage_handler = \Drupal::entityTypeManager()->getStorage('node');
    do {
      $nids_query = $database->select('node', 'n')
      ->fields('n', array('nid'))
      ->condition('n.type', $types, 'IN')
      ->range(0, 200)
        ->execute();
      $nids = $nids_query->fetchCol();
      $entities = $storage_handler->loadMultiple($nids);
      $storage_handler->delete($entities);
    } while (!empty($nids));
  }

  /**
   * @BeforeSuite
   */
  public static function removeMediaData(BeforeSuiteScope $scope) {
    //remove all content type nodes which have list page testing
    //before running suite to allow list page tests to run
    $types = array('files', 'image');
    $database = \Drupal::database();
    $storage_handler = \Drupal::entityTypeManager()->getStorage('media');
    if ($database->schema()->tableExists('media')) {
      do {
        $mids_query = $database->select('media', 'm')
        ->fields('m', array('mid'))
        ->condition('m.bundle', $types, 'IN')
        ->range(0, 200)
          ->execute();
        $mids = $mids_query->fetchCol();
        $entities = $storage_handler->loadMultiple($mids);
        $storage_handler->delete($entities);
      } while (!empty($mids));
    }
  }

  /**
   * Delete all files before each scenario so that duplicates are not created
   * @BeforeScenario
   */
  public static function removeStaticFiles(BeforeScenarioScope  $scope) {
    do {
      $database = \Drupal::database();
      $query = $database->select('file_managed', 'fm');
      $query->join('file_usage', 'fu', 'fm.fid = fu.fid');
      // Only delete file if its part of node and media entities
      $orGroup = $query->orConditionGroup()
        ->condition('fu.type', 'node', '=')
        ->condition('fu.type', 'media', '=');
      $andGroup = $query->andConditionGroup()
        ->condition($orGroup)
        ->condition('fm.status', 1, '=');
      $query->condition($andGroup);
      $query->fields('fm', ['fid', 'uri']);
      $query->fields('fu', ['type']);
      $query->range(0, 500);
      $result = $query->execute();
      $fids = [];
      foreach ($result as $file) {
        $fids[$file->fid] = $file->fid;
      }
      $files = \Drupal::service('entity_type.manager')->getStorage('file')->loadMultiple($fids);
      \Drupal::service('entity_type.manager')->getStorage('file')->delete($files);
    } while (!empty($fids));
  }

  /**
   * Call this function before nodes are created.
   *
   * @beforeNodeCreate
   */
  public function alterNodeObject(EntityScope $scope)
  {
    $node = $scope->getEntity();
    if (isset($node->field_start_date)) {
      $date = new DateTime($node->field_start_date);
      $node->field_start_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_end_date)) {
      $date = new DateTime($node->field_end_date);
      $node->field_end_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_sec_event_date)) {
      $date = new DateTime($node->field_sec_event_date);
      $node->field_sec_event_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_sec_event_end_date)) {
      $date = new DateTime($node->field_sec_event_end_date);
      $node->field_sec_event_end_date = $date->format('Y-m-d H:i:s');
    }
  }

  /**
   *
   * Clean up of nodes, users, etc. is automatic. But not Terms (or links!). This is a little hacky, all
   * new terms and menu links MUST be prepended with BEHAT.
   *
   * @AfterScenario
   */
  public static function cleanupTerms()
  {
    $tids = \Drupal::entityQuery('taxonomy_term')
      ->condition('name', 'BEHAT', 'STARTS_WITH')
      ->execute();

    $controller = \Drupal::entityTypeManager()->getStorage('taxonomy_term');
    $entities = $controller->loadMultiple($tids);
    $controller->delete($entities);

    $mids = \Drupal::entityQuery('menu_link_content')
      ->condition('title', 'BEHAT', 'STARTS_WITH')
      ->execute();

    $mcontroller = \Drupal::entityTypeManager()->getStorage('menu_link_content');
    $mentities = $mcontroller->loadMultiple($mids);
    $mcontroller->delete($mentities);
  }

  /**
   * @Given I am on page :arg1
   */
  public function iAmOnPage($page)
  {
    $this->visitPath($page);
  }

  /**
   * @Given I navigate to the :page page from the current url
   */
  public function iNavigateToThePageFromCurrentPage($page)
  {
    $currenturl = $this->getSession()->getCurrentUrl();
    $this->visitPath($currenturl . '' . $page);
  }

  /**
   * @Then I should see the logo :arg1 in the header
   */
  public function iShouldSeeTheLogoInTheHeader($arg1)
  {
    throw new PendingException();
  }



  /**
   * @Then I should see the latest press releases in the :arg1 region
   */
  public function iShouldSeeTheLatestPressReleasesInTheRegion($arg1)
  {
    var_export($this);
    throw new PendingException();
  }

  /**
   * @Then I should see the last :arg1 Press Releases in the latest region
   */
  public function iShouldSeeTheLastPressReleasesInTheLatestRegion($arg1)
  {
    $latest = $this->getSession()->getPage()->findAll('css', '.newsroom-latest-pr .item-list ul li');
    $count = 0;

    foreach ($latest as $row) {
      $count++;
    }
    if ($count == 5) {
      return;
    } else {
      throw new \Exception(
        sprintf(
          "Expected latest pr - %s not found on page %s",
          $arg1,
          $this->getSession()->getCurrentUrl()
        )
      );
    }
  }


  /**
   * @Then I should see the menu :arg1 in the :arg2 region
   */
  public function iShouldSeeTheMenuInTheRegion($arg1, $arg2)
  {
    /*left nav mapping for list pages */
    $navmenu = (array(
      "Newsroom" => "#block-newsroomleftnav", "Speech" => "#block-newsroomleftnav", "Fast Answers" => "#block-investorinformationmenu-menu", "Forms" => "#block-filingsmenu",
      "Data" => "#block-about", "Investor Alerts" => "#block-investorinformationmenu", "Reports" => "#block-about"
    ));

    $listnav = $this->getSession()->getPage()->find('css', 'nav');

    if (array_key_exists($arg1, $navmenu)) {

      if ($listnav->findAll('css', $navmenu[$arg1])) {
        return;
      }
    } else {
      throw new \Exception(
        sprintf(
          "Expected %s menu not found on page %s",
          $arg1,
          $this->getSession()->getCurrentUrl()
        )
      );
    }
  }

  /**
   * Click on the element with the provided CSS Selector
   *
   * @Then /^I click on the element with css selector "([^"]*)"$/
   */
  public function iClickOnTheElementWithCSSSelector($cssSelector)
  {
    $element = $this->getSession()->getPage()->find("css", $cssSelector);
    if (null === $element) {
      throw new \InvalidArgumentException(sprintf('Could not evaluate CSS Selector: "%s"', $cssSelector));
    }

    $element->click();
  }

  /**
   * @When I select the option :opt in the heirarchical select :sel
   */
  public function iSelectTheOptionInTheHeirarchicalSelect($opt, $sel)
  {
    $dropDownElement = $this->getSession()->getPage()->find("css", ".control-label:contains('" . $sel . "')");
    $optionElement = $dropDownElement->getParent()->find("css", ".simpler-select:first-child option:contains('" . $opt . "')");

    if (null === $dropDownElement) {
      throw new \InvalidArgumentException(sprintf('Could not find heirarchical select: "%s"', $sel));
    }

    if (null === $optionElement) {
      throw new \InvalidArgumentException(sprintf('Could not find option: "%s"', $opt));
    }

    $dropDownElement->click();
    $optionElement->click();
  }

  /**
   * @When I select the sub-option :opt in the heirarchical select :sel
   */
  public function iSelectTheSubOptionInTheHeirarchicalSelect($opt, $sel)
  {
    $dropDownElement = $this->getSession()->getPage()->find("css", ".control-label:contains('" . $sel . "')");
    $subDropDownElement = $dropDownElement->getParent()->findAll("css", ".select-wrapper")[1];
    $optionElement = $subDropDownElement->find("css", "option:contains('" . $opt . "')");

    if (null === $dropDownElement) {
      throw new \InvalidArgumentException(sprintf('Could not find heirarchical select: "%s"', $sel));
    }

    if (null === $optionElement) {
      throw new \InvalidArgumentException(sprintf('Could not find option: "%s"', $opt));
    }

    $dropDownElement->click();
    $optionElement->focus();
    $optionElement->click();
  }


  /**
   * @Given /^I wait (\d+) seconds$/
   */
  public function iWaitSeconds($seconds)
  {
    sleep($seconds);
  }

  /**
   * Input and select into an autocomplete field
   * @When I select the first autocomplete option for :text on the :autocomplete field
   */
  public function iSelectTheFirstAutocompleteOptionForTextOnTheAutocompleteField($autocomplete, $text)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();
    $field = $this->getSession()->getPage()->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $driver->keyDown($xpath, 40);
    $driver->keyUp($xpath, 40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
       throw new \Exception("Autocomplete result not found");
    } else {
      $result->click();
    }
  }

  /**
   * @Then I should see the field :arg1 is disabled
   */
  public function iSeeTheFieldIsDisabled($arg1){
    $field = $this->getSession()->getPage()->findField($arg1);

    if($field->getAttribute('disabled') == "disabled") {
      return;
    }
    throw new \Exception($arg1. " is not disabled");
  }


  /**
   * Input and select into an autocomplete field
   * @When I select the autocomplete option for :text on the :autocomplete field
   */
  public function iSelectTheAutocompleteOptionForTextOnTheAutocompleteField($autocomplete, $text)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();
    $field = $this->getSession()->getPage()->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $driver->keyDown($xpath, 40);
    $driver->keyUp($xpath, 40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
       throw new \Exception("Autocomplete result not found");
    } else {
      $driver->keyDown($xpath, 40);
      $driver->keyDown($xpath, 9);
    }
  }

  /**
   * Input and select into an autocomplete field with region
   * @When I select the first autocomplete option for :text on the :autocomplete field in the :region region
   */
  public function iSelectTheFirstAutocompleteOptionForTextOnTheAutocompleteFieldRegion($autocomplete, $text, $region)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();
    $regionNode = $session->getPage()->find('region', $region);
    if (!$regionNode) {
      throw new Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
    }
    $field = $regionNode->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $driver->keyDown($xpath, 40);
    $driver->keyUp($xpath, 40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
      throw new \Exception("Autocomplete result not found");
    } else {
      $result->click();
    }
  }
  /**
   * @Then I click :buttonName on the modal :title
   */
  public function iClickButtonOnTheModal($buttonName, $title)
  {
    $modals = $this->getSession()->getPage()->findAll('css', '.ui-dialog');
    if (!empty($modals)) {
      foreach ($modals as $modal) {
        $modalTitle = $modal->find("css", ".ui-dialog-title");
        if ($modal && $modal && $modal->isVisible() && trim($modalTitle->getText()) === $title) {

          //now find the button
          $buttons = $modal->findAll("css", ".button");
          if (!empty($buttons)) {
            foreach ($buttons as $button) {
              if ($button && $button->isVisible() && trim($button->getText()) === $buttonName) {
                $button->click();
              }
            }
          }
        }
      }
    }
  }

  /**
   * @When I switch to the :arg1 selector
   */
  public function iSwitchToTheSelector($arg1)
  {
    $this->getSession()->switchToIframe("entity_browser_iframe_" . $arg1);
  }

  /**
   * @When I switch to the main window
   */
  public function iSwitchToTheMainWindow()
  {
    $this->getSession()->switchToIframe();
  }

  /**
   * @When I check :arg1 on the contact selector
   * arg2 is the iFrame name, contacts and files both use an iFrame
   */
  public function iCheckOnTheSelector($arg1)
  {
    $field = $this->getSession()->getPage()->find("xpath", "//td[contains(., '" . $arg1 . "')]/preceding-sibling::td/div/input");
    if (empty($field)) {
      throw new \Exception("Checkbox not found");
    } else {
      $field->check();
    }
  }

  /**
   * @When I check :arg1 on the files selector
   * arg2 is the iFrame name, contacts and files both use an iFrame
   */
  public function iCheckOnTheFilesSelector($arg1)
  {
    $field = $this->getSession()->getPage()->find("xpath", "//td[contains(., '" . $arg1 . "')]/preceding-sibling::td/div/input");
    if (empty($field)) {
      throw new \Exception("Checkbox not found");
    } else {
      $field->check();
    }
  }

  /**
   * @When I scroll to the bottom
   */
  public function iScrollToThe()
  {
    $this->getSession()->wait(500, ' window.scrollTo(0, document.body.scrollHeight) ');
  }

  /**
   * @When I scroll to the top
   */
  public function iScrollUp()
  {
    $this->getSession()->wait(500, ' window.scrollTo(0, 0) ');
  }

  /**
   * @Then I play the video
   */
  public function iPlayTheVideo()
  {
    sleep(1);
    $isPlaying = $this->getSession()->getPage()->find('css', '.akamai-playing, .vjs-playing');
    if (!$isPlaying) {
      $video = $this->getSession()->getPage()->find('css', '.akamai-video, .limelight-player');
      if ($video && $video->isVisible()) {
        $playButton = $this->getSession()->getPage()->find('css', '.vjs-play-control,.akamai-play-pause');
        if ($playButton && $playButton->isVisible()) {
          $playButton->click();
        } else {
          $video->click();
        }
      }
    }
  }
  /**
   * @Then I should see a video player
   */
  public function iShouldSeeAVideoPlayer()
  {
    sleep(9);

    $video = $this->getSession()->getPage()->find('css', '.akamai-video, .limelight-player');
    if ($video && $video->isVisible()) {
      return;
    }

    throw new \Exception(sprintf("video player not found"));
  }

  /**
   * @Then I wait for the page to be loaded
   */
  public function iWaitForThePageToBeLoaded()
  {
    $this->getSession()->wait(10000, "document.readyState === 'complete'");
  }

  /**
   * @Then I should see the video playing
   */
  public function iShouldSeeTheVideoPlaying()
  {
    $video = $this->getSession()->getPage()->find('css', '.vjs-playing, .akamai-playing');
    if ($video && $video->isVisible()) {
      return;
    }

    throw new \Exception(sprintf("video player not found"));
  }


  /**
   * @Then /^I should see the modal "([^"]*)"$/
   */
  public function iShouldSeeTheModal($title)
  {
    $this->getSession()->wait(20000, '(0 === jQuery.active && 0 === jQuery(\':animated\').length)');
    $modal = $this->getSession()->getPage()->find('css', '.ui-dialog-title');
    if ($modal && $modal->isVisible() && trim($modal->getText()) === $title) {
      return;
    }

    throw new \Exception(sprintf("Modal %s not found", $title));
  }

  /**
   * A function that will allow users to set an option in the drop down publish
   * button on a node create/edit page. Searches by the value of the input.
   *
   * @Given I click the input with the value :arg1
   */
  public function iClickTheInputWithTheValue($arg1)
  {
    $xpath = '//input[@value="' . $arg1 . '"]';
    $pubButton = $this->getSession()->getPage()->findAll('xpath', $xpath);
    if ($pubButton != null) {
      $pubButton[0]->click();
      return;
    } else {
      throw new \Exception(
        sprintf("Expected %s option not found on node", $arg1)
      );
    }
  }

  /**
   * @Given I publish it
   */
  public function iPublishIt()
  {
    $this->iClickTheInputWithTheValue("Save");
    try {
      $this->confirmPopup();
    } catch (Exception $e) {
      // popup not present - this is ok
    }
  }

  /**
   * @when /^(?:|I )confirm the popup$/
   * If you have a popup you MUST use the @javascript tag to run the test
   */
  public function confirmPopup()
  {
    $driver = $this->getSession()->getDriver();
    if ($driver instanceof Behat\Mink\Driver\Selenium2Driver) {
      $this->getSession()->getDriver()->getWebDriverSession()->accept_alert();
    }
  }

  /**
   * This depends on W3Cs online validator, if you can't reach the internet or they change it
   * this will break
   *
   * @Then I should see valid XML
   */
  public function iShouldSeeValidXml()
  {
    $feed = $this->getSession()->getDriver()->getContent();
    $url = 'https://validator.w3.org/feed/check.cgi';
    $data = array('rawdata' => $feed, 'manual' => 1);
    $options = array(
      'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data),
        'ssl' => array(
          'verify_peer' => false,
          'verify_peer_name' => false
        )
      )
    );
    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    if (stristr($result, 'Congratulations') !== false) {
      return;
    } else {
      throw new \Exception("Feed is not valid XML");
    }
  }

  /**
   * @Transform mytime :days
   **/
  public function castDateTime($days)
  {
    $timestamp = new DateTime($days);
    throw new \Exception($timestamp);
  }

  /**
   * @When I scroll :selector into view
   *
   * @param string $selector Allowed selectors: #id, .className, //xpath
   *
   * @throws \Exception
   */
  public function scrollIntoView($selector)
  {
    $locator = substr($selector, 0, 1);

    switch ($locator) {
      case '/': // XPath selector
        $function = <<<JS
(function(){
var elem = document.evaluate("$selector", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
elem.scrollIntoView(false);
})()
JS;
        break;

      case '#': // ID selector
        $selector = substr($selector, 1);
        $function = <<<JS
(function(){
var elem = document.getElementById("$selector");
elem.scrollIntoView(false);
})()
JS;
        break;

      case '.': // Class selector
        $selector = substr($selector, 1);
        $function = <<<JS
(function(){
var elem = document.getElementsByClassName("$selector");
elem[0].scrollIntoView(false);
})()
JS;
        break;
      default:
        throw new \Exception(__METHOD__ . ' Couldn\'t find selector: ' . $selector . ' - Allowed selectors: #id, .className, //xpath');
        break;
    }

    try {
      $this->getSession()->executeScript($function);
    } catch (Exception $e) {
      throw new \Exception(__METHOD__ . ' failed');
    }
  }

  /**
   * @Then I should see the link :first_link before I see the link :second_link in the :view view
   */
  public function iShouldSeeTheLinkBeforeISeeTheLinkInTheView($first_link, $second_link, $view)
  {
    $page = $this->getSession()->getPage();
    $selector = '.view-' . strtolower(str_replace(' ', '-', $view));
    // First, find the view; if it doesn't exist, the scenario fails
    $v = $page->find('css', $selector);
    if (empty($v)) {
      throw new Exception("The view " . $view . " was not found.");
    }
    // use xpath selector with or since view rows can be identified in a variety of ways
    $rows = $v->findAll('xpath', '//tr[@role="row"] | //table[contains(concat(" ", @class, " "), "list")]/tbody/tr | //*[contains(concat(" ", @class, " "), " view-row")] | //div[contains(concat(" ", @class, " "), " item-list")]/ul/li');
    $foundFirst = false;
    $foundinOrder = false;
    // Iterate over the rows of the view
    foreach ($rows as $row) {
      if (!empty($row->findLink($first_link))) {
        $foundFirst = true;
      } elseif ($foundFirst && !empty($row->findLink($second_link))) {
        $foundinOrder = true;
        break;
      }
    }
    if (!$foundinOrder) {
      throw new Exception("The link " . $first_link . " was not found before the link " . $second_link);
    }
  }

  /**
   * @Then I should see the field :field
   */
  public function iShouldSeeTheField($field)
  {
    $page = $this->getSession()->getPage();
    // Get the label first
    $id = "edit-field-" . strtolower(str_replace(' ', '-', $field)) . '-wrapper';
    $label = $page->find('xpath', '//*[@id="' . $id . '"]/div/label');
    // nab the id selector for the field from the 'for' attribute of the label
    $f = $page->find('xpath', '//*[@id="' . $label->getAttribute('for') . '"]');
    if (empty($f) || !$f->isVisible()) {
      throw new Exception("The field " . $field . " is not visible.");
    }
  }

  /**
   * @When I fill in :date_field with the date :date_value
   */
  public function iFillInWithTheDate($date_field, $date_value)
  {
    $page = $this->getSession()->getPage();

    $date = DateTime::createFromFormat('Y-m-d H:i:s', $date_value);

    // Get the fieldset for the date field named in arg1
    $fs = $page->find('named', array('fieldset', $date_field));
    if (empty($fs)) {
      throw new Exception(sprintf("The date field %s is not available.", $date_field));
    }

    // Get the input for date part
    $dateInput = $fs->find('css', '#' . $fs->getAttribute('id') . '-value-date');
    if (empty($dateInput)) {
      throw new Exception(sprintf("The date field %s is not available.", $date_field));
    }

    // Had to change from Y-m-d to m/d/Y due to how Chrome handles date inputs
    $dateInput->setValue(date_format($date, 'm/d/Y'));

    // Get the input for time part
    $timeInput = $fs->find('css', '#' . $fs->getAttribute('id') . '-value-time');
    if (!empty($dateInput)) {
      $timeInput->setValue(date_format($date, 'H:i:sA'));
    }
  }

  /**
   * @Then I should see the :block block in the :region region
   */
  public function iShouldSeeTheBlockInTheRegion($block, $region)
  {
    $session = $this->getSession();
    $page = $session->getPage();
    $regionNode = $page->find('region', $region);
    if (!$regionNode) {
      throw new Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
    }

    $class = strtolower(str_replace([':', ' '], '-', $block));
    $blockNode = $regionNode->find('css', '.' . $class);
    if (!$blockNode) {
      // Try something a little different
      $class = strtolower(str_replace(' ', '_', str_replace(': ', '-', $block)));
      $blockNode = $regionNode->find('css', '.' . $class);
      if (!$blockNode) {
        throw new Exception(sprintf('The block %s not found in region %s on page %s.', $block, $region, $session->getCurrentUrl()));
      }
    }
  }

  /**
   * @Then I should see the statistics guide titled :title
   */
  public function iShouldSeeTheStatisticsGuideTitled($title)
  {
    $page = $this->getSession()->getPage();
    $headers = $page->findAll('css', 'h3.ui-accordion-header');
    $found = false;
    foreach ($headers as $h) {
      if ($h->getText() == $title) {
        $found = true;
        break;
      }
    }
    if (!$found) {
      throw new Exception(sprintf('The statistics guide %s was not found on page %s', $title, $this->getSession()->getCurrentUrl()));
    }
  }

  /**
   * @Then I should see the text :first_text before I see the text :second_text in the :view view
   */
  public function iShouldSeeTheTextBeforeISeeTheTextInTheView($first_text, $second_text, $view)
  {
    $page = $this->getSession()->getPage();
    $selector = '.view-' . strtolower(str_replace(' ', '-', $view));
    // First, find the view; if it doesn't exist, the scenario fails
    $v = $page->find('css', $selector);
    if (empty($v)) {
      throw new Exception("The view " . $view . " was not found.");
    }
    $rows = $v->findAll('xpath', '//tr[@role="row"] | //h3[contains(concat(" ", @class, " "), " ui-accordion-header ")] | //div[contains(concat(" ", @class, " "), " item-list")]/ul/li');
    $foundFirst = false;
    $foundinOrder = false;
    // Iterate over the rows of the view
    foreach ($rows as $row) {
      if ($row->has('named', array('content', $first_text))) {
        $foundFirst = true;
      } elseif ($foundFirst && $row->has('named', array('content', $second_text))) {
        $foundinOrder = true;
        break;
      }
    }
    if (!$foundinOrder) {
      throw new Exception(sprintf("The text %s was not found before the text %s in view %s.", $first_text, $second_text, $view));
    }
  }

  /**
   * @When I visit :url for term :term from taxonomy :taxonomy
   */
  public function iVisitForTermFromTaxonomy($url, $term, $taxonomy)
  {
    $tid = _sec_taxonomy_get_taxonomy_term_id($taxonomy, $term);
    $sessionUrl = $this->getSession()->getCurrentUrl();
    $parsedUrl = parse_url($sessionUrl);
    $newUrl = sprintf('%s://%s:%s%s?tid=%s', $parsedUrl['scheme'], $parsedUrl['host'], $parsedUrl['port'], $url, $tid);
    $this->getSession()->visit($newUrl);
  }

  /**
   * @When /^I clear drupal cache$/
   */
  public function clearDrupalCache()
  {
    $this->visitPath("/admin/config/development/performance");
    $this->getSession()->getPage()->pressButton('edit-clear');
  }

  /**
   * @When /^the link should open in a new tab$/
   */
  public function linkShouldOpenInNewTab()
  {
    $session     = $this->getSession();
    $windowNames = $session->getWindowNames();
    if (sizeof($windowNames) < 2) {
      throw new \ErrorException("Expected to see at least 2 windows opened");
    }
    //Switch to that window
    $session->switchToWindow($windowNames[1]);
  }

  /**
   * @When I drag taxonomy term :arg1 onto :arg2
   */
  public function iDragTaxonomyTermOnto($arg1, $arg2)
  {
    $page = $this->getSession()->getPage();

    $dragged = $page->find('xpath', '//tr/td/a[contains(., "' . $arg1 . '")]/preceding-sibling::a');
    $target = $page->find('xpath', '//tr/td[contains(., "' . $arg2 . '")]/ancestor::tr/following-sibling::tr');

    $session = $this->getSession()->getDriver()->getWebDriverSession();

    $from = $session->element('xpath', $dragged->getXpath());
    $to = $session->element('xpath', $target->getXpath());

    $session->moveto(array('element' => $from->getID()));
    $session->buttondown("");
    $session->moveto(array('element' => $to->getID()));
    $session->buttonup("");
  }

  /**
   * @When I select the option :opt from the jquery select :sel
   */
  public function iSelectTheOptionInTheJquerySelect1($sel, $opt)
  {
    $this->getSession()->executeScript("jQuery('{$sel} option:contains({$opt})').each(function(){if(jQuery(this).text() === '{$opt}'){jQuery('{$sel}').val(jQuery(this).attr('value')).change();}})");
  }

  /**
   * @Given /^I close the current (?:window|tab)$/
   */
  public function closeCurrentWindow()
  {
    $session     = $this->getSession();
    $this->getSession()->executeScript("window.open('','_self').close();");
    $session->stop();
  }

  /**
  * @Given /^I close (?:window|tab) "(\d+)"$/
  */
  public function closeWindowIndex($index)
  {
  $windows = $this->getSession()->getWindowNames();
  if(isset($windows[$index - 1])) {
  $this->getSession()->switchToWindow($windows[$index - 1]);
  $this->getSession()->executeScript("window.open('','_self').close();");
  }
  }

  /**
  * @Given /^I switch to (?:window|tab) "(\d+)"$/
  */
  public function switchWindowIndex($index)
  {
  $windows = $this->getSession()->getWindowNames();
  if(isset($windows[$index - 1])) {
  $this->getSession()->switchToWindow($windows[$index - 1]);
  }
  }

  /**
   * @Then the hyperlink :arg1 should match the Drupal url :arg2
   */
  public function linkShouldMatchTheDrupalUrl($link, $url)
  {
    $linkHandle = $this->getSession()->getPage()->find('named', array('link', $link));
    if (isset($linkHandle)) {
      $linkUrl = $linkHandle->getAttribute('href');
      if (strcmp($url, $linkUrl) == 0) {
        return;
      } else {
        throw new \Exception($link . " link does not match the Drupal Url " . $linkUrl);
      }
    } else {
      throw new \Exception($link . " link not found on page.");
    }
  }

  /**
   * @Then I should not see the :region region
   */
  public function assertNotRegion($region)
  {
    $session = $this->getSession();
    $regionObj = $session->getPage()->find('region', $region);
    if (!empty($regionObj)) {
      throw new \Exception(sprintf('The "%s" region was found on the page %s', $region, $this->getSession()->getCurrentUrl()));
    }
  }

  /**
   * @Then I should see the :region region
   */
  public function assertRegionVisible($region)
  {
    $session = $this->getSession();
    $regionObj = $session->getPage()->find('region', $region);
    if (empty($regionObj)) {
      throw new \Exception(sprintf('The "%s" region was not found on the page %s', $region, $this->getSession()->getCurrentUrl()));
    }
  }

    /**
   * @Then I should see the date :arg1 in the :arg2 selector
   */
  public function iShouldSeeTheDateInTheSelector($arg1, $arg2) {
    //convert date into Event list page date format
    $date = new DateTime($arg1);
    $text = $date->format('m/d/Y');
    $session = $this->getSession();
    $textSel = $session->getPage()->find('css', $arg2);

    // Find the text within the selector
    $selText = $textSel->getText();
    if (strpos($selText, $text) === false) {
      throw new \Exception(sprintf("The text '%s' was not found in the '%s' on the page %s", $text, $arg2, $this->getSession()->getCurrentUrl()));
    }
  }

  	  /**
	 * @Then I should see :textA followed by :textB
	 */
  public function iShouldSeeFollowedBy($textA, $textB)
  {
    $content = $this->getSession()->getPage()->getContent();

    // Get rid of stuff between script tags
    $content = $this->removeContentBetweenTags('script', $content);

    // ...and stuff between style tags
    $content = $this->removeContentBetweenTags('style', $content);

    $content = preg_replace('/<[^>]+>/', ' ',$content);

    // Replace line breaks and tabs with a single space character
    $content = preg_replace('/[\n\r\t]+/', ' ',$content);

    $content = preg_replace('/ {2,}/', ' ',$content);

    if (strpos($content,$textA) === false) {
      throw new Exception(sprintf('"%s" was not found in the page', $textA));
    }

    $seeking = $textA . ' ' . $textB;
    if (strpos($content,$textA . ' ' . $textB) === false) {
      // Be helpful by finding the 10 characters that did follow $textA
      preg_match('/' . $textA . ' [^ ]+/',$content,$matches);
      throw new Exception(sprintf('"%s" was not found, found "%s" instead', $seeking, $matches[0]));
    }
  }

  /**
   * @param string $tagName - The name of the tag, eg. 'script', 'style'
   * @param string $content
   *
   * @return string
   */
  private function removeContentBetweenTags($tagName,$content)
  {
    $parts = explode('<' . $tagName, $content);

    $keepers = [];

    // We always want to keep the first part
    $keepers[] = $parts[0];

    foreach ($parts as $part) {
      $subparts = explode('</' . $tagName . '>', $part);
      if (count($subparts) > 1) {
        $keepers[] = $subparts[1];
      }
    }

    return implode('', $keepers);
  }

  /**
    * The path where mail can be rerieved
    *
    * $mailpath string
    *
    */
    protected $mailpath = "http://mail-catalog.lndo.site";

    /**
    * @Given /^I check notification$/
    */
    public function iCheckNotification()
    {
    $mail_path = $this->mailpath;
    $this->visitPath($mail_path);
    }

   /**
   * @When /^I clear notifications$/
   */
  public function clearNotifications()
  {
    $this->visitPath("http://mail-catalog.lndo.site");
    $this->getSession()->getPage()->clickLink('Delete all messages');
    $this->minkContext->iWaitForAjaxToFinish();
    $this->getSession()->getPage()->pressButton('Delete all messages');
  }

  /**
  * @When I fill element :element_selector with :value
  */
  public function fillElementWithValue($element_selector, $value)
  {
  $page = $this->getSession()->getPage();
  $element = $page->find('css', $element_selector);
  //var_dump($element);
  if ($element) {
  $element->setValue($value);
  }
  else {
  throw new Exception(sprintf("Could not find element"));
  }
 }

}
