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
use Behat\Mink\Extension\ElementNotFoundException;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Testwork\Hook\Scope\BeforeSuiteScope;


/**
 * Defines application features from the specific context.
 */
class InputScreenContext extends RawDrupalContext implements Context
{

    /**
    * @When I select :arg1 from :arg2 for the :arg3 option of the :arg4 row
    */
    public function iSelectFromTheOptionOf($arg1, $arg2, $arg3, $arg4)
    {
      $select =  $this->getSession()->getPage()->find('xpath', "//label[text()='" . $arg2 . " (value " . $arg4 . ")']/following-sibling::div[" . $arg3 . "]/select");
       $select->selectOption($arg1);
    }

    /**
    * @Then I should see the link :first_link before I see the link :second_link in the :region region
    */
    public function iShouldSeeTheLinkBeforeISeeTheLinkInTheRegion($first_link, $second_link, $region)
        {
          $page = $this->getSession()->getPage();
          $regionObj = $page->find('region', $region);
          $rows=$regionObj->findAll('xpath','//div[contains(concat(" ", @class, " "), "views-row")]| //table[contains(concat(" ", @class, " "), "table")]/tbody/tr| //div[contains(concat(" ", @class, " "), " item-list")]/ul/li');
          $foundFirst = false;
          $foundinOrder = false;
          // Iterate over the rows of the view
          foreach ($rows as $row) {
          if (!empty($row->findLink($first_link))) {
                  $foundFirst = true;
                  }
              elseif ($foundFirst && !empty($row->findLink($second_link))) {
                    $foundinOrder = true;
                    break;
                     }
                  }
                  if (!$foundinOrder) {
                    throw new Exception("The link " . $first_link . " was not found before the link " . $second_link);
                    }
            }

            /**
           * @When /^I hover over the element "([^"]*)"$/
           */
          public function iHoverOverTheElement($locator)
          {
                  $session = $this->getSession(); // get the mink session
                  $element = $session->getPage()->find('css', $locator); // runs the actual query and returns the element

                  // errors must not pass silently
                  if (null === $element) {
                      throw new \InvalidArgumentException(sprintf('Could not evaluate CSS selector: "%s"', $locator));
                  }

                  // ok, let's hover it
                  $element->mouseOver();
          }

           /**
     * @Then I should see the text :first_text before I see the text :second_text in the :region region
     */
    public function iShouldSeeTheTextBeforeISeeTheTextInTheRegion($first_text, $second_text, $region)
    {
      $page = $this->getSession()->getPage();
          $regionObj = $page->find('region', $region);
          $rows=$regionObj->findAll('xpath','//div[contains(concat(" ", @class, " "), "views-row")]| //table[contains(concat(" ", @class, " "), "table")]/tbody/tr');
          $foundFirst = false;
          $foundinOrder = false;

      foreach ($rows as $row) {
        if ($row->has('named', array('content', $first_text))) {
          $foundFirst = true;
        }
        elseif ($foundFirst && $row->has('named', array('content', $second_text))) {
          $foundinOrder = true;
          break;
        }
      }
      if (!$foundinOrder) {
        throw new Exception(sprintf("The text %s was not found before the text %s in region %s.", $first_text, $second_text, $region));
      }
    }

     /**
    * @When I select contact :arg1 from :arg2
    */
    public function iSelectContactFrom($arg1, $arg2)
    {
      //ul[not(contains(@styl
      $select =  $this->getSession()->getPage()->find('xpath', "//select[starts-with(@id,'" . $arg2 . "')]");

      // /select[contaings(@id^='".$arg2."')]");
      // "//label[text()='" . $arg2 . " (value " . $arg4 . ")']/following-sibling::div[" . $arg3 . "]/select");
       $select->selectOption($arg1);
    }
}
?>
