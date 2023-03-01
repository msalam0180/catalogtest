<?php

namespace Drupal\dc_dashboard\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Form\FormBuilderInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\RequestStack;
use Drupal\Core\Database\Connection;
use Drupal\Core\Entity\EntityFieldManager;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Database\Query\PagerSelectExtender;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Component\Serialization\Json;
use Drupal\Component\Utility\Xss;
use Drupal\Core\Messenger\MessengerInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\field\Entity\FieldStorageConfig;
use Exception;
use Drupal\Core\Link;

/**
 * Provides route for dataset dashboard.
 */
class DatasetDashboardController extends ControllerBase {

  /**
   * @var \Drupal\Core\Form\FormBuilderInterface
   */
  protected $formBuilder;

  /**
   * @var \Symfony\Component\HttpFoundation\RequestStack
   */
  protected $requestStack;

  /**
   * @var \Drupal\Core\Database\Connection
   */
  protected $database;

  /**
   * @var \Drupal\Core\Entity\EntityFieldManager
   */
  protected $entityFieldManager;

  /**
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * @var \Drupal\Core\Messenger\MessengerInterface
   */
  protected $messenger;

  /**
   * The current user account.
   *
   * @var \Drupal\Core\Session\AccountInterface
   */
  protected $currentUser;


  /**
   * @param \Drupal\Core\Form\FormBuilderInterface $form_builder
   *   The form builder.
   * @param \Symfony\Component\HttpFoundation\RequestStack $request_stack
   *   The request stack.
   * @param \Drupal\Core\Database\Connection $database
   *   The database connector.
   * @param \Drupal\Core\Entity\EntityFieldManager $entity_field_manager
   *   The entity field manager.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager.
   * @param \Drupal\Core\Messenger\MessengerInterface
   *   The messenger service.
   * @param \Drupal\Core\Session\AccountInterface $account
   *   The current user.
   */
  public function __construct(
    FormBuilderInterface $form_builder,
    RequestStack $request_stack,
    Connection $database,
    EntityFieldManager $entity_field_manager,
    EntityTypeManagerInterface $entity_type_manager,
    MessengerInterface $messenger,
    AccountInterface $account
  ) {
    $this->formBuilder = $form_builder;
    $this->requestStack = $request_stack;
    $this->database = $database;
    $this->entityFieldManager = $entity_field_manager;
    $this->entityTypeManager = $entity_type_manager;
    $this->messenger = $messenger;
    $this->currentUser = $account;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('form_builder'),
      $container->get('request_stack'),
      $container->get('database'),
      $container->get('entity_field.manager'),
      $container->get('entity_type.manager'),
      $container->get('messenger'),
      $container->get('current_user')
    );
  }

  /**
   * Returns dataset dashboard
   *
   * @return array
   *   A simple renderable array.
   */
  public function dashboardPage() {
    $build = [
      '#theme' => 'dataset_dashboard',
    ];

    $form_class = '\Drupal\dc_dashboard\Form\DatasetDashboardForm';
    $build['#form'] = $this->formBuilder->getForm($form_class);
    $build['#content'] = $this->dashboardData();
    $build['#can_publish'] = $this->currentUser->hasPermission('save and publish dataset dashboard');

    return $build;
  }

  public function dashboardData() {

    // Get query parameters
    $parameters = $this->requestStack->getCurrentRequest()->query->all();

    // List of fields to join in query
    $used_fields = [];

    // Get field definitions.
    $fields = $this->entityFieldManager->getFieldDefinitions('node', 'data_set');

    // Get hidden fields
    $dataset_form_display = $this->entityTypeManager->getStorage('entity_form_display')->load('node.data_set.default');
    $hidden_fields = array_keys($dataset_form_display->get('hidden'));

    // Table header.
    $header = [
      'Node ID',
      'Title',
    ];

    // List of fields to display in table
    $display_fields = is_array($parameters['display_fields']) ? $parameters['display_fields'] : [];

    // Used to set aliases
    $field_count = 1;

    // Used to join to entity tables and query LIKE through those
    $entity_reference_fields = [];

    // Used for fields that are lists
    $list_fields = [];

    $text_field_types = [
      'string',
      'float',
      'integer',
      'email',
    ];

    $sort_field = $parameters['sort_field'] ?: 'title';
    $sort_by = $parameters['sort_by'] ?: 'asc';

    $metadata_group_terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadByProperties(['vid' => 'metadata_groups']);
    $requested_metadata_tids = $this->requestStack->getCurrentRequest()->query->get('metadata_display_fields');

    foreach ($requested_metadata_tids as $requested_metadata_tid) {
      if (isset($metadata_group_terms[$requested_metadata_tid])) {
        $metadata_group_fields = $metadata_group_terms[$requested_metadata_tid]->get('field_metadata')->referencedEntities();
        foreach ($metadata_group_fields as $metadata_group_field) {
          if ($metadata_group_field->get('entity_type') == 'node' && !in_array($metadata_group_field->get('field_name'), $display_fields)) {
            if (in_array($metadata_group_field->get('type'), $text_field_types) && !in_array($metadata_group_field->get('field_name'), $hidden_fields)) {
              $cardinality = $metadata_group_field->getCardinality();
              if ($cardinality == 1) {
                $display_fields[] = $metadata_group_field->get('field_name');
              }
            }
            else if($metadata_group_field->get('type') == 'entity_reference' && !in_array($metadata_group_field->get('field_name'), $hidden_fields)) {
              $field_settings = $metadata_group_field->getSettings();
              $cardinality = $metadata_group_field->getCardinality();

              $allowed_entity_types = ['node', 'taxonomy_term'];
              if (in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
                $display_fields[] = $metadata_group_field->get('field_name');
              }
            }
            else if($metadata_group_field->get('type') == 'list_string' && !in_array($metadata_group_field->get('field_name'), $hidden_fields)) {
              $field_settings = $metadata_group_field->getSettings();
              $cardinality = $metadata_group_field->getCardinality();
              if ($cardinality == 1) {
                $display_fields[] = $metadata_group_field->get('field_name');
              }
            }
          }
        }
      }
    }

    foreach ($display_fields as $display_field) {
      $used_fields[$display_field] = "field_filter_{$field_count}";
      $header[] = $fields[$display_field]->getLabel();
      $field_count++;
    }

    // List of fields to filter by
    $filter_fields = [];

    // Get title as it's a base field
    $title = $parameters['filter_title'] ?: "";

    // Get status as it's a base field
    $status_filter = $parameters['filter_status'] ?: "";

    // Remove title and status to deal with parameters after
    unset($parameters['filter_title']);
    unset($parameters['filter_status']);

    // Loop through to get filter fields
    foreach ($parameters as $field_parameter => $value) {
      preg_match("/filter_(.*)/i", $field_parameter, $matches);

      // $matches[1] should have the field name
      if (isset($matches[1]) && !empty($value)) {
        $used_fields[$matches[1]] = "field_filter_{$field_count}";
        $filter_fields[$matches[1]] = $value;
        $field_count++;
      }
    }

    $query = $this->database->select('node_field_data', 'nfd');

    foreach ($used_fields as $field_name => $field_alias) {
      if (!empty($filter_fields[$field_name]) && $filter_fields[$field_name] != '_none') {
        $query->leftJoin("node__" . $field_name, $field_alias, "nfd.nid = {$field_alias}.entity_id");

        if ($fields[$field_name]->getType() == 'entity_reference') {
          $field_settings = $fields[$field_name]->getSettings();
          $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
          $allowed_entity_types = ['node', 'taxonomy_term'];

          if (in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
            $field_settings['table_alias'] = "field_filter_{$field_count}";
            $query->leftJoin($field_settings['target_type'] . "_field_data", $field_settings['table_alias'], "{$field_alias}.{$field_name}_target_id = {$field_settings['table_alias']}.{$field_settings['target_type'][0]}id");
            $entity_reference_fields[$field_name] = $field_settings;
            $field_count++;
          }
        }
      } else {
        $query->leftJoin("node__" . $field_name, $field_alias, "nfd.nid = {$field_alias}.entity_id");

        if ($fields[$field_name]->getType() == 'entity_reference') {
          $field_settings = $fields[$field_name]->getSettings();
          $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
          $allowed_entity_types = ['node', 'taxonomy_term'];

          if (in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
            $field_settings['table_alias'] = "field_filter_{$field_count}";
            $query->leftJoin($field_settings['target_type'] . "_field_data", $field_settings['table_alias'], "{$field_alias}.{$field_name}_target_id = {$field_settings['table_alias']}.{$field_settings['target_type'][0]}id");
            $entity_reference_fields[$field_name] = $field_settings;
            $field_count++;
          }
        }
      }
    }

    $query->condition('nfd.type', 'data_set');

    foreach ($filter_fields as $filter_field => $value) {
      if (in_array($fields[$filter_field]->getType(), $text_field_types)) {
        $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
        if ($cardinality == 1) {
          if ($value == '<blank>') {
            $fieldOrCondition = $query->orConditionGroup()
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_value", NULL, "IS NULL")
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_value", '');
            $query->condition($fieldOrCondition);
          }
          else {
            $query->condition("{$used_fields[$filter_field]}.{$filter_field}_value", "%" . $this->database->escapeLike($value) . "%", "LIKE");
          }
        }
      }
      elseif ($fields[$filter_field]->getType() == 'list_string' && !empty($value) && $value != '_none') {
        $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
        if ($cardinality == 1) {
          if ($value == '_blank') {
            $fieldOrCondition = $query->orConditionGroup()
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_value", NULL, "IS NULL")
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_value", '');
            $query->condition($fieldOrCondition);
          }
          else {
            $query->condition("{$used_fields[$filter_field]}.{$filter_field}_value", $value);
          }
        }
      }
      elseif ($fields[$filter_field]->getType() == 'entity_reference') {
        $field_settings = $entity_reference_fields[$filter_field];
        $cardinality = $fields[$filter_field]->getFieldStorageDefinition()->getCardinality();
        $allowed_entity_types = ['node', 'taxonomy_term'];

        if (isset($field_settings['table_alias']) && in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
          if ($value == '<blank>') {
            $fieldOrCondition = $query->orConditionGroup()
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_target_id", NULL, "IS NULL")
              ->condition("{$used_fields[$filter_field]}.{$filter_field}_target_id", '');
            $query->condition($fieldOrCondition);
          }
          else {
            if ($field_settings['target_type'] == 'node') {
              $query->condition("{$field_settings['table_alias']}.title", "%" . $this->database->escapeLike($value) . "%", "LIKE");
            }
            elseif ($field_settings['target_type'] == 'taxonomy_term') {
              $query->condition("{$field_settings['table_alias']}.name", "%" . $this->database->escapeLike($value) . "%", "LIKE");
            }
          }
        }
      }
    }

    if (!empty($title)) {
      $query->condition('nfd.title', "%" . $this->database->escapeLike($title) . "%", "LIKE");
    }

    if (!empty($status_filter)) {
      if ($status_filter == 'published') {
        $query->condition('nfd.status', 1);
      }
      elseif ($status_filter == 'unpublished') {
        $query->condition('nfd.status', 0);
      }
    }

    foreach ($display_fields as $field_name) {
      if (isset($fields[$field_name]) && (in_array($fields[$field_name]->getType(), $text_field_types) || $fields[$field_name]->getType() == 'list_string')) {
        $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
        if ($cardinality == 1) {
          $query->fields($used_fields[$field_name], [$field_name . "_value"]);
        }
      }
      elseif (isset($fields[$field_name]) && $fields[$field_name]->getType() == 'entity_reference') {
        $field_settings = $entity_reference_fields[$field_name];
        $cardinality = $fields[$field_name]->getFieldStorageDefinition()->getCardinality();
        $allowed_entity_types = ['node', 'taxonomy_term'];

        if (isset($field_settings['table_alias']) && in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
          if ($field_settings['target_type'] == 'node') {
            $query->addField("{$field_settings['table_alias']}", 'title', $field_name . "_title");
            $query->addField("{$field_settings['table_alias']}", 'nid', $field_name . "_id");
          }
          elseif ($field_settings['target_type'] == 'taxonomy_term') {
            $query->addField("{$field_settings['table_alias']}", 'name', $field_name . "_title");
            $query->addField("{$field_settings['table_alias']}", 'tid', $field_name . "_id");
          }
        }
      }
    }

    $query->fields('nfd', ['nid', 'vid', 'title', 'status']);

    if (!empty($sort_field)) {
      if ($sort_field != 'title' && $sort_field != 'nid') {
        $field_alias = '';
        if (isset($fields[$sort_field]) && in_array($fields[$sort_field]->getType(), $text_field_types)) {
          $cardinality = $fields[$sort_field]->getFieldStorageDefinition()->getCardinality();
          if ($cardinality == 1) {
            if (isset($used_fields[$sort_field])) {
              $field_alias = $used_fields[$sort_field] . "." . $sort_field . "_value";
            }
            else {
              $query->leftJoin("node__" . $sort_field, "sortingField", "nfd.nid = sortingField.entity_id");
              $field_alias = 'sortingField.' . $sort_field . '_value';
            }
          }
        }
        elseif (isset($fields[$sort_field]) && $fields[$sort_field]->getType() == 'entity_reference') {
          if (isset($entity_reference_fields[$sort_field])) {
            $field_settings = $entity_reference_fields[$sort_field];
            $cardinality = $fields[$sort_field]->getFieldStorageDefinition()->getCardinality();
            $allowed_entity_types = ['node', 'taxonomy_term'];

            if (isset($field_settings['table_alias']) && in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
              if ($field_settings['target_type'] == 'node') {
                $field_alias = $field_settings['table_alias'] . ".title";
              }
              elseif ($field_settings['target_type'] == 'taxonomy_term') {
                $field_alias = $field_settings['table_alias'] . ".name";
              }
            }
          }
          else {
            $field_settings = $fields[$sort_field]->getSettings();
            $cardinality = $fields[$sort_field]->getFieldStorageDefinition()->getCardinality();
            $allowed_entity_types = ['node', 'taxonomy_term'];

            if (in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
              $query->leftJoin("node__" . $sort_field, 'entitySortField', "nfd.nid = entitySortField.entity_id");
              $query->leftJoin($field_settings['target_type'] . "_field_data", 'sortingField', "entitySortField.{$sort_field}_target_id = sortingField.{$field_settings['target_type'][0]}id");
              if ($field_settings['target_type'] == 'node') {
                $field_alias = 'sortingField.title';
              }
              elseif ($field_settings['target_type'] == 'taxonomy_term') {
                $field_alias = 'sortingField.name';
              }
            }
          }
        }
        if (!empty($field_alias)) {
          if ($sort_by == 'asc') {
            $query->orderBy($field_alias, 'ASC');
          }
          else {
            $query->orderBy($field_alias, 'DESC');
          }
        }
      }
      elseif ($sort_field == 'nid') {
        if ($sort_by == 'asc') {
          $query->orderBy('nfd.nid', 'ASC');
        }
        else {
          $query->orderBy('nfd.nid', 'DESC');
        }
      }
      else {
        if ($sort_by == 'asc') {
          $query->orderBy('nfd.title', 'ASC');
        }
        else {
          $query->orderBy('nfd.title', 'DESC');
        }
      }
    }

    $pager = $query->extend(PagerSelectExtender::class)->limit(20);

    $results = $pager->execute()->fetchAll();

    // Building rows array.
    $rows = [];

    foreach ($results as $data) {
      $data = (array) $data;
      $nid = $data['nid'];
      $published_revision = $data['vid'];
      $node_title = $data['title'];
      $status = $data['status'];
      unset($data['status']);
      unset($data['title']);
      unset($data['nid']);
      unset($data['vid']);
      $latest_revision = $this->entityTypeManager->getStorage('node')->getLatestRevisionId($nid);
      $nid_label = $nid;

      if ($latest_revision && $latest_revision != $published_revision) {
        $nid_label .= " *";
      }

      if (!$status) {
        $nid_label .= " **";
      }

      $data_cells = [
        [
          'data' => Link::createFromRoute($nid_label, 'entity.node.canonical', ['node' => $nid],['attributes' => ['target' => '_blank']]),
        ],
        [
          'data' => $node_title,
          'data-field' => 'title',
          'data-type' => 'string',
          'data-required' => '1',
          'class' => [
            'dataset-column',
            'off-focus',
          ],
        ],
      ];

      foreach ($data as $field_column => $field_value) {
        preg_match("/(.*)_value/i", $field_column, $matches);
        preg_match("/(.*)_title/i", $field_column, $entity_matches);

        // $matches[1] should have the field name
        if (isset($matches[1])) {
          $data_cell = [
            'data' => $field_value,
            'data-field' => $matches[1],
            'data-type' => $fields[$matches[1]]->getType(),
            'data-required' => (string) $fields[$matches[1]]->isRequired(),
            'class' => [
              'dataset-column',
              'off-focus',
            ],
          ];

          if ($fields[$matches[1]]->getType() == 'list_string') {
            $field_settings = $fields[$matches[1]]->getSettings();
            $data_cell['data'] = $field_settings['allowed_values'][$field_value];
            $data_cell['data-selected-value'] = $field_value;
            $data_cell['data-select-options'] = Json::encode(['_none' => ''] + $field_settings['allowed_values']);
          }

          $data_cells[] = $data_cell;
        }
        elseif (isset($entity_matches[1])) {
          $entity_id_field = $entity_matches[1] . "_id";
          $data_cells[] = [
            'data' => !empty($field_value) ? $field_value . " ({$data[$entity_id_field]})" : "",
            'data-field' => $entity_matches[1],
            'data-type' => $fields[$entity_matches[1]]->getType(),
            'data-required' => (string) $fields[$entity_matches[1]]->isRequired(),
            'data-entity-value' => $data[$entity_id_field],
            'class' => [
              'dataset-column',
              'off-focus',
            ],
          ];
        }
      }

      $row = [
        'data' => $data_cells,
        'data-nid' => $nid,
        'class' => [
          'dataset-row',
        ],
      ];

      if ($latest_revision && $latest_revision != $published_revision) {
        $row['class'][] = 'data-has-latest-revision';
      }

      if (!$status) {
        $row['class'][] = 'data-is-not-published';
      }

      $rows[] = $row;
    }

    return [
      'empty' => count($rows) < 1,
      'table' => [
        '#type' => 'table',
        '#header' => $header,
        '#rows' => $rows,
        '#attributes' => [
          'id' => 'dataset-dashboard-table'
        ],
        '#empty' => $this->t('There are no results.'),
      ],
      'pager' => [
        '#type' => 'pager',
        '#attributes' => [
          'class' => 'pager'
        ],
      ]
    ];
  }

  public function saveData() {
    $json = Json::decode($this->requestStack->getCurrentRequest()->getContent());
    $field_definitions = $this->entityFieldManager->getFieldDefinitions('node', 'data_set');
    $saved_nid = $failed_nid =[];
    $moderation_state = (isset($json['save_state']) && $json['save_state'] == 'publish') ? 'published' : 'review';

    if (!$this->currentUser->hasPermission('save and publish dataset dashboard')) {
      $moderation_state = 'review';
    }

    foreach ($json['results'] as $item) {
      $node_save = FALSE;

      if (isset($item['nid'])) {
        $nid = Xss::filter($item['nid']);
        $node = $this->entityTypeManager->getStorage('node')->load($nid);

        if ($node && $node->bundle() == 'data_set') {

          foreach ($item as $field_name => $field_value) {
            $field_name = Xss::filter($field_name);
            if (isset($field_definitions[$field_name])) {
              switch ($field_definitions[$field_name]->getType()) {
                case 'string':
                case 'integer':
                case 'float':
                case 'email':
                  $field_value = trim(Xss::filter($field_value));
                  $node->set($field_name, $field_value);

                  $node_save = TRUE;
                  break;
                case 'list_string':
                  $field_value = trim(Xss::filter($field_value));
                  $node->set($field_name, $field_value);

                  $node_save = TRUE;
                  break;
                case 'entity_reference':
                  $field_value = trim(Xss::filter($field_value));
                  preg_match("/.* \((\d+)\)/i", $field_value, $matches);

                  if (isset($matches[1])) {
                    $node->set($field_name, $matches[1]);
                    $node_save = TRUE;
                  }
                  elseif (empty($field_value)) {
                    $node->set($field_name, NULL);
                    $node_save = TRUE;
                  }
                  break;

                default:
                  break;
              }
            }
          }
          if ($node_save) {
            try {
              $node->set('moderation_state', $moderation_state);
              $node->save();
              $saved_nid[] =  $node->getTitle() . " ($nid)";
            } catch (Exception $e) {
              $failed_nid[] = $node->getTitle() . " ($nid)";
            }
          }
          else {
            $failed_nid[] =  $node->getTitle() . " ($nid)";
          }
        }
      }
    }

    if (!empty($saved_nid)) {
      $this->messenger->addMessage('Following Datasets have been saved: ' . implode(', ', $saved_nid));
    }
    if (!empty($failed_nid)) {
      $this->messenger->adderror('Following Datasets have failed to save: ' . implode(', ', $failed_nid));
    }

    return new JsonResponse(['message' => 'data processed']);
  }

  function getFieldData() {
    $results = [];
    $field = $this->requestStack->getCurrentRequest()->request->get('field');
    $search_query = $this->requestStack->getCurrentRequest()->request->get('query');
    $field_definitions = $this->entityFieldManager->getFieldDefinitions('node', 'data_set');
    $settings = $field_definitions[$field]->getSettings();
    $allowed_entity_reference = [
      'node',
      'taxonomy_term',
    ];

    if (in_array($settings['target_type'], $allowed_entity_reference)) {
      $title_column = $settings['target_type'] == 'node' ? 'title' : 'name';
      $id_column = $settings['target_type'] == 'node' ? 'nid' : 'tid';
      $bundle = $settings['target_type'] == 'node' ? 'type' : 'vid';
      $query = $this->database->select($settings['target_type'] . "_field_data", 'def')
      ->condition('def.' . $title_column, '%' .$this->database->escapeLike($search_query) . '%', 'LIKE');
      if (!empty($settings['handler_settings']['target_bundles'])) {
        $query->condition('def.' . $bundle, $settings['handler_settings']['target_bundles'], 'IN');
      }
      $query->addExpression("CONCAT(def.{$title_column}, ' (', def.{$id_column}, ')')", 'title');
      $results = $query->range(0,20)->execute()->fetchAllKeyed(0);
      $results = array_keys($results);
      sort($results);
    }

    return new JsonResponse($results);
  }
}
