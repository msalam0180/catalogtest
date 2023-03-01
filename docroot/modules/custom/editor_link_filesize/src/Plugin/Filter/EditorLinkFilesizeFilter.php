<?php
namespace Drupal\editor_link_filesize\Plugin\Filter;

use Drupal\Component\Utility\Html;
use Drupal\Core\Entity\EntityRepositoryInterface;
use Drupal\filter\FilterProcessResult;
use Drupal\filter\Plugin\FilterBase;
use Drupal\file\Entity\File;

/**
 * Provides a EditorLinkFilesizeFilter filter.
 *
 * @Filter(
 *   id = "LinkFilesize",
 *   title = @Translation("Show File Size next to files"),
 *   description = @Translation("Updates links so that they have a filesize attribute and display the filesize."),
 *   settings = {
 *     "title" = TRUE,
 *   },
 *   type = Drupal\filter\Plugin\FilterInterface::TYPE_TRANSFORM_REVERSIBLE
 * )
 */
class EditorLinkFilesizeFilter extends FilterBase {

  /**
   * {@inheritdoc}
   */
  public function process($text, $langcode) {


    $result = new FilterProcessResult($text);

    if (strpos($text, 'data-entity-type') !== FALSE && strpos($text, 'data-entity-uuid') !== FALSE) {
      $dom = Html::load($text);
      $xpath = new \DOMXPath($dom);

      foreach ($xpath->query('//a[@data-entity-type and @data-entity-uuid]') as $element) {
        /** @var \DOMElement $element */
        try {
          // Load the appropriate translation of the linked entity.
          $entity_type = $element->getAttribute('data-entity-type');
          $uuid = $element->getAttribute('data-entity-uuid');

          // Skip empty attributes to prevent loading of non-existing
          // content type.
          if ($entity_type === '' || $uuid === '') {
            continue;
          }
          
          $entity = \Drupal::service('entity.repository')->loadEntityByUuid($entity_type, $uuid);
          if ($entity) {
            if($entity_type == "media") {
              // TODO: This is hard coded, it should probably look for the first file on the entity or something like that so it can be used for other sites
              $fileEntity = $entity->field_media_file->entity;
            }
            elseif($entity_type == "file"){
              $fileEntity = $entity;
            }
            if ($entity_type == "file" || $entity_type == "media") {
              if (isset($fileEntity) && $fileEntity != null) {
                $file_size = $fileEntity->getSize();
                $file_size_formatted = format_size($file_size);
                $file_size_html = '<span class="file-size">(' . $file_size_formatted . ')</span>';
                $element->setAttribute('data-filesize', $file_size_formatted);
                appendToInnerHML($element, $file_size_html);
              }
            }
          }
        }
        catch (\Exception $e) {
          watchdog_exception('LinkFilesize', $e);
        }
      }

      $result->setProcessedText(Html::serialize($dom));
      // $result->setAttachments(array(
        // 'library' => array('editor_link_filesize/editor_link_filesize'),
      // ));
    }

    return $result;
  }

}

function appendToInnerHML($element, $html)
{
  if (!empty($element)) {
    $fragment = $element->ownerDocument->createDocumentFragment();
    $fragment->appendXML( $html );
    $element->appendChild( $fragment );
  }
}
