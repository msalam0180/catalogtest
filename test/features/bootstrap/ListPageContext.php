<?php

use Behat\Behat\Context\Context;
use Drupal\DrupalExtension\Context\DrupalContext;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use PHPUnit\Framework\Assert as PHPUnit;

/**
 * Defines application features from the specific context.
 */
class ListPageContext extends RawDrupalContext implements Context
{
  /**
   * @Then I should see :arg1 under the :arg2 date banner
   */
  public function iShouldSeeUnderTheDateBanner($arg1, $arg2)
  {
    //convert date into Event list page date format
    $date = new DateTime($arg2);
    $date->setTimezone( new DateTimeZone("America/New_York") );
    $listDate = $date->format('l, F j, Y');

    //use converted date in xpath
    //check to see if the date is in the last of the list
    //if last date use different xpath
    $headers = $this->getSession()->getPage()->findAll('xpath', "//tr[@class='group']/td");
    if (!empty($headers)) {
      if (end($headers)->getText() == strtoupper($listDate)) {
        $xpath = "//tr[preceding-sibling::tr[td//text()[contains(., '". $listDate . "')]]]/td[@class='views-field views-field-title']//a";
      } else {
        $xpath = "//tr[preceding-sibling::tr[td//text()[contains(., '". $listDate . "')]] and following-sibling::tr[@class='group']]/td[@class='views-field views-field-title']//a";
      }
    } else {
      throw new \Exception("No headers found on page.");
    }

    //loop through results and see if arg1 is in text
    $links = $this->getSession()->getPage()->findAll('xpath', $xpath);

    if (!empty($links)) {
      foreach ($links as $link) {
        if ($link->getText() == $arg1) {
          return;
        }
      }
      throw new \Exception($arg1 . " not found under " . $listDate);
    } else {
      throw new \Exception("No link " . $arg1 . " found on page." . end($headers)->getText());
    }
  }

  /**
   * @Then I should see the time :arg1 in the :arg2 row
   */
  public function iShouldSeeTheTimeInTheRow($arg1, $rowText)
  {
      //convert date into Event list page date format
      $date = new DateTime($arg1);
      $date->setTimezone( new DateTimeZone("America/New_York") );
      $text = $date->format('g:i A');

      $this->assertTextInTableRow($text, $rowText);
  }

  /**
   * @Then I should see the date :arg1 in the :arg2 row
   */
  public function iShouldSeeTheDateInTheRow($arg1, $rowText)
  {
      //convert date into Event list page date format
      $date = new DateTime($arg1);
      // $text = $this->secDateFormat($date); // AP Dateformat
      $text = $date->format('M j, Y');

      $this->assertTextInTableRow($text, $rowText);
  }

  /**
   * @Then :textBefore should precede :textAfter for the query :xpath
   */
  public function shouldPrecedeForTheQuery($textBefore, $textAfter, $xpath) {
    $items = array_map(
      function ($element) {
          return $element->getText();
      },
      $this->getSession()->getPage()->findAll('xpath', $xpath)
    );

    PHPUnit::assertTrue(in_array($textBefore, $items), 'The before text was not found!');
    PHPUnit::assertTrue(in_array($textAfter,  $items), 'The after text was not found!');

    PHPUnit::assertGreaterThan(
      array_search($textBefore, $items),
      array_search($textAfter, $items),
      "$textBefore does not proceed $textAfter"
    );
  }

  /**
   * @When I click the sort filter :arg1
   */
  public function iClickTheSortFilter($arg1) {
      $xpath = "//table[contains(@class, dataTable)]/thead/tr/th[contains(., '" . $arg1 . "')]";
      $sortHeader = $this->getSession()->getPage()->findAll('xpath', $xpath);
      $sortHeader[0]->click();
  }

  /**
   * @Then the search results should show the link :arg1
   */
  public function theSearchResultsShouldShowTheLink($link)
  {
    $element = $this->getSession()->getPage();
    $result = $element->findLink($link);

    try {
      if ($result && !$this->resultVisible($link)) {
        throw new \Exception(sprintf("Link '%s' exists in results but not visible on the page %s", $link, $this->getSession()->getCurrentUrl()));
      }
    }
    catch (UnsupportedDriverActionException $e) {
      // We catch the UnsupportedDriverActionException exception in case
      // this step is not being performed by a driver that supports javascript.
      // All other exceptions are valid.
    }

    if (empty($result)) {
      throw new \Exception(sprintf("No link to '%s' on the page %s", $link, $this->getSession()->getCurrentUrl()));
    }
  }

  /**
   * @Then the search results should not show the link :arg1
   */
  public function theSearchResultsShouldNotShowTheLink($link)
  {
    $element = $this->getSession()->getPage();
    $result = $element->findLink($link);

    try {
      if ($result && $this->resultVisible($link)) {
        throw new \Exception(sprintf("Link '%s' exists in results on the page %s", $link, $this->getSession()->getCurrentUrl()));
      }
    }
    catch (UnsupportedDriverActionException $e) {
      // We catch the UnsupportedDriverActionException exception in case
      // this step is not being performed by a driver that supports javascript.
      // All other exceptions are valid.
    }
  }

  public function secDateFormat($date){
    $abrev = array(1,2,8,10,11,12);
    $full = array(3,4,5,6,7);
    $sept = array(9);
    if (in_array($date->format('n'), $abrev)) {
      return $date->format('M. j, Y');
    } elseif (in_array($date->format('n'), $full)) {
      return $date->format('F j, Y');
    } elseif (in_array($date->format('n'), $sept)) {
      return "Sept. " . $date->format('j, Y');
    } else {
      throw new \Exception(sprintf("%s is not a month", $date->format('n')));
    }
  }

  public function resultVisible($result) {
    $xpath = '//a[@href][(normalize-space(string(.)) = "' . $result . '")]/ancestor::tr[@style="display: none;"]';
    $links = $this->getSession()->getPage()->findAll('xpath', $xpath);
    if ($links) {
      return false;
    } else {
      return true;
    }
  }

}
