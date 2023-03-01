<?php

namespace Drupal\dc_general\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\dc_general\Plugin\migrate\process\RelatedApps.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use Drupal\node\Entity\Node;
use Drupal\paragraphs\Entity\Paragraph;

/**
 * Creates relationships to applications based on short name value.
 *
 * @see \Drupal\migrate\Plugin\MigrateProcessInterface
 *
 * @MigrateProcessPlugin(
 *   id = "related_apps"
 * )
 */
class RelatedApps extends ProcessPluginBase
{

    /**
   * {@inheritdoc}
   */
    public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) 
    {

        if (empty($value)) {
            // Skip this item if there's no value.
            throw new MigrateSkipProcessException();
        }

        $value = explode(",",$value);
        $descriptionOfRelationship = $row->getSourceProperty($this->configuration['desc']);
        if (is_array($value)) {
            
            foreach ($value as $otherSourceId) {
                $otherNid = $this->getNidBySourceId($otherSourceId);
                if (!empty($otherNid)) {                    
                    
                    $otherNode = Node::load($otherNid);
                    //check if this row is already in system
                    $thisSourceId = $row->getSourceProperty('id');
                    
                    if (!empty($thisSourceId)) {
                        $thisNodeId = $this->getNidBySourceId($thisSourceId);
                        if (!empty($thisNodeId)) {
                            //load the entity so we can read the related apps field we're eventually trying to modify
                            $entity = Node::load($thisNodeId);
                            if (!empty($entity)) {
                                //grab related application entities and loop over them checking for an existing relationship
                                $thisRelatedApps = $entity->get('field_related_applications')->referencedEntities();
                                $isAlreadyRelated = false;
                                foreach ($thisRelatedApps as $relatedApp) {
                                    //$relatedNid represents the related application
                                    $relatedNid = $relatedApp->get('field_application')->getValue()[0]['target_id'];
                                    
                                    if ($relatedNid == $otherNid){                                    
                                        $isAlreadyRelated = true;
                                        break;
                                    }
                                }
                                if (!$isAlreadyRelated) {
                                    // Create corresponding paragraph entity
                                    $paragraph = Paragraph::create(['type' => 'related_application']);
                                    $paragraph->set('field_desc_of_relationship', [
                                        'value'=>$descriptionOfRelationship,
                                        'format'=>'plain_text'
                                    ]);
                                    $paragraph->set('field_application', $otherNode);
                                    $paragraph->setParentEntity($entity,"field_related_applications");
                                    $paragraph->save();

                                    //grab any existing values for the otherNode and append this new paragraph
                                    $paragraphArray = $entity->get('field_related_applications')->getValue();
                                    $paragraphArray[] = array(
                                        'target_id' => $paragraph->id(),
                                        'target_revision_id' => $paragraph->getRevisionId(),
                                        );
                                    $entity->set('field_related_applications', $paragraphArray);
                                    $entity->save();                             }
                            }
                        }
                    }
                }
            }
        }
       

    }

    protected function getNidBySourceId($sourceId){
        return \Drupal::database()->query('SELECT destid1 FROM {migrate_map_apps} WHERE sourceid1 = :sourceId',[':sourceId' => $sourceId])->fetchField();        
    }

}
