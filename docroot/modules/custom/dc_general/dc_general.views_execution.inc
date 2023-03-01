<?php

use Drupal\views\ViewExecutable;
use Drupal\views\Plugin\views\query\QueryPluginBase;

/**
 * Implements hook_views_query_alter().
 */
function dc_general_views_query_alter(ViewExecutable $view, QueryPluginBase $query)
{
  //first check we are on the right view
  if ($view->id() == 'discussions' && $view->current_display == 'block_1') {
    //check if there is an actual search query submitted
    if (!empty($view->getExposedInput()["search"])) {
      $term = $view->getExposedInput()["search"];
      //loop over where conditions until we find the combined filter condition
      foreach ($query->where as $key=>$where) {
        if (!empty($where['conditions'])){
          if(stristr($where['conditions'][0]['field'], "CONCAT_WS")){
            //search the comment body aka subject for the search term
            $result = \Drupal::database()->query("SELECT d.entity_id FROM comment_field_data d inner join comment__comment_body c on c.entity_id = d.cid WHERE c.comment_body_value like :term", array(':term' => "%".$term."%"));
            $nodes = $result->fetchAll();
            if (!empty($nodes)){
              //create an array of matching nids and add a where to condition group
              $nids = array_column($nodes, 'entity_id');
              $query->addWhere($key, 'node_field_data.nid', $nids, 'IN');
            }
            break;
          }          
        }
      }
    }
  }
}
