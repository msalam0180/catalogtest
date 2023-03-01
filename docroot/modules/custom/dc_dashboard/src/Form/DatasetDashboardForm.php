<?php

namespace Drupal\dc_dashboard\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Entity\EntityFieldManager;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\field\Entity\FieldConfig;
use Symfony\Component\HttpFoundation\RequestStack;

/**
 * Implements a Dataset Dashboard Form.
 */
class DatasetDashboardForm extends FormBase {

  /**
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * @var \Drupal\Core\Entity\EntityFieldManager
   */
  protected $entityFieldManager;

  /**
   * @var \Symfony\Component\HttpFoundation\RequestStack
   */
  protected $requestStack;

  /**
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager.
   * @param \Drupal\Core\Entity\EntityFieldManager $entity_field_manager
   *   The entity field manager.
   * @param \Symfony\Component\HttpFoundation\RequestStack $request_stack
   *   The request stack.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager, EntityFieldManager $entity_field_manager,
    RequestStack $request_stack) {
    $this->entityTypeManager = $entity_type_manager;
    $this->entityFieldManager = $entity_field_manager;
    $this->requestStack = $request_stack;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('entity_type.manager'),
      $container->get('entity_field.manager'),
      $container->get('request_stack')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'dataset_dashboard_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form_state->setMethod('GET');
    $fields = $this->entityFieldManager->getFieldDefinitions('node', 'data_set');
    $dataset_form_display = $this->entityTypeManager->getStorage('entity_form_display')->load('node.data_set.default');
    $metadata_group_terms = $this->entityTypeManager->getStorage('taxonomy_term')->loadByProperties(['vid' => 'metadata_groups']);
    $hidden_fields = array_keys($dataset_form_display->get('hidden'));
    $requested_display_fields = is_array($this->requestStack->getCurrentRequest()->query->get('display_fields')) ? $this->requestStack->getCurrentRequest()->query->get('display_fields') : [];
    $requested_metadata_tids = $this->requestStack->getCurrentRequest()->query->get('metadata_display_fields');
    $metadata_group_options = [];
    $field_options = [];

    $text_field_types = [
      'string',
      'float',
      'integer',
      'email',
    ];

    $text_fields = [];

    $entity_reference_fields = [];

    $list_fields = [];

    $sort_fields = ['title' => 'Title', 'nid' => 'Node ID'];

    foreach($fields as $field) {
      if ($field instanceof FieldConfig) {
        if (in_array($field->get('field_type'), $text_field_types) && !in_array($field->get('field_name'), $hidden_fields)) {
          $field_settings = $field->getSettings();
          $cardinality = $field->getFieldStorageDefinition()->getCardinality();
          if ($cardinality == 1) {
            $field_options[$field->get('field_name')] = $field->get('label');
            $sort_fields[$field->get('field_name')] = $field->get('label');
            $text_fields[] = $field;
          }
        }
        else if($field->get('field_type') == 'entity_reference' && !in_array($field->get('field_name'), $hidden_fields)) {
          $field_settings = $field->getSettings();
          $cardinality = $field->getFieldStorageDefinition()->getCardinality();

          $allowed_entity_types = ['node', 'taxonomy_term'];
          if (in_array($field_settings['target_type'], $allowed_entity_types) && $cardinality == 1) {
            $field_options[$field->get('field_name')] = $field->get('label');
            $sort_fields[$field->get('field_name')] = $field->get('label');
            $entity_reference_fields[] = $field;
          }
        }
        else if($field->get('field_type') == 'list_string' && !in_array($field->get('field_name'), $hidden_fields)) {
          $field_settings = $field->getSettings();
          $cardinality = $field->getFieldStorageDefinition()->getCardinality();
          if ($cardinality == 1) {
            $field_options[$field->get('field_name')] = $field->get('label');
            $list_fields[] = $field;
          }
        }
      }
    }

    foreach ((array) $metadata_group_terms as $metadata_group_term) {
      $metadata_group_options[$metadata_group_term->id()] = $metadata_group_term->getName();
    }

    foreach ($requested_metadata_tids as $requested_metadata_tid) {
      if (isset($metadata_group_options[$requested_metadata_tid]) && isset($metadata_group_terms[$requested_metadata_tid])) {
        $metadata_group_fields = $metadata_group_terms[$requested_metadata_tid]->get('field_metadata')->referencedEntities();
        foreach ($metadata_group_fields as $metadata_group_field) {
          if ($metadata_group_field->get('entity_type') == 'node' && isset($field_options[$metadata_group_field->get('field_name')]) && !in_array($metadata_group_field->get('field_name'), $requested_display_fields)) {
            $requested_display_fields[] = $metadata_group_field->get('field_name');
          }
        }
      }
    }

    asort($sort_fields);
    asort($field_options);
    asort($metadata_group_options);

    $form['dashboard_help'] = [
      '#type' => 'details',
      '#title' => 'How To Use The Dashboard',
      '#open' => FALSE,
    ];

    $markup = <<<EOT
    <div>
      <p><strong>Step 1: Select Fields and Datasets to Edit</strong></p>

      <p>Expand the "Display Options"</p>

      <ul>
        <li>Select fields to edit from the "Fields to Display" dropdown OR from the “Metadata Groups” dropdown. Do not use a combination of these options.</li>
        <li>Metadata Groups will return groupings of related fields based on frequent need.</li>
        <li>The Title and Node ID columns are displayed by default.</li>
      </ul>

      <p>Expand the "Filters"</p>

        <ul>
          <li>To restrict the datasets displayed in the dashboard, enter filter criteria into one or more of the fields. If you enter criteria in more than one field, the dashboard will return results where all criteria are met.</li>
          <li>Text fields use a partial match to filter (e.g. "FINR" returns datasets containing FINRA).</li>
          <li>To filter based on empty values, enter "&lt;blank&gt;" in the desired field.</li>
        </ul>

      <p>Click "Apply" to populate the dashboard based on selections above.</p>

      <p><strong>Step 2: Edit Values</strong></p>

      <ul>
        <li>To edit a value, click inside the cell and make changes. Node ID cannot be edited.</li>
        <li>Once all changes have been made, select “Save and Review” to save all changes as unpublished (i.e. "Latest Version") and to initiate the review workflow.</li>
        <li>Users who are Content Approvers can choose to “Save and Publish” to directly publish the edited values. <em>USE THIS OPTION WITH CARE.</em></li>
        <li>If you leave the dashboard without saving, your changes will be lost.</li>
      </ul>

      <p><strong>Contact the <a href="mailto:Catalog@sec.gov">Catalog@sec.gov</a> if you have questions. If you would like to propose a metadata grouping, or if the fields you would like to edit are not available.</strong></p>
    </div>
    EOT;

    $form['dashboard_help']['markup'] = [
      '#markup' => $markup,
    ];

    $form['display_container'] = [
      '#type' => 'details',
      '#title' => 'Display Options',
      '#open' => TRUE,
    ];

    $form['display_container']['display_fields'] = [
      '#type' => 'select',
      '#multiple' => TRUE,
      '#title' => $this->t('Fields to Display'),
      '#options' => $field_options,
      '#default_value' => $requested_display_fields ?: [],
    ];

    if (!empty($metadata_group_options)) {
      $form['display_container']['metadata_display_fields'] = [
        '#type' => 'select',
        '#multiple' => TRUE,
        '#title' => $this->t('Display Metadata Groups'),
        '#options' => $metadata_group_options,
        '#default_value' => $requested_metadata_tids ?: [],
      ];
    }

    $form['display_container']['sort_field'] = [
      '#type' => 'select',
      '#title' => $this->t('Sort By Field'),
      '#options' => $sort_fields,
      '#default_value' => $this->requestStack->getCurrentRequest()->query->get('sort_field') ?? 'title',
    ];

    $form['display_container']['sort_by'] = [
      '#type' => 'select',
      '#title' => $this->t('Sort By'),
      '#options' => ['asc' => 'ASC', 'desc' => 'DESC'],
      '#default_value' => $this->requestStack->getCurrentRequest()->query->get('sort_by') ?? 'asc',
    ];

    $form['filter_container'] = [
      '#type' => 'details',
      '#title' => 'Filters',
    ];

    $form['filter_container']['filter_title'] = [
      '#type' => 'textfield',
      '#title' => 'Title',
      '#default_value' => $this->requestStack->getCurrentRequest()->query->get('filter_title') ?? '',
      '#attributes' => [
        'size' => '30'
      ],
    ];

    foreach ($text_fields as $text_field) {
      $form['filter_container']['filter_' . $text_field->get('field_name')] = [
        '#type' => 'textfield',
        '#title' => strlen($text_field->get('label')) < 35 ? $text_field->get('label') : substr($text_field->get('label'), 0, 30) . "...",
        '#default_value' => $this->requestStack->getCurrentRequest()->query->get('filter_' . $text_field->get('field_name')) ?? '',
        '#attributes' => [
          'size' => '30'
        ],
      ];
    }

    foreach ($entity_reference_fields as $entity_reference_field) {
      $form['filter_container']['filter_' . $entity_reference_field->get('field_name')] = [
        '#type' => 'textfield',
        '#title' => strlen($entity_reference_field->get('label')) < 35 ? $entity_reference_field->get('label') : substr($entity_reference_field->get('label'), 0, 30) . "...",
        '#default_value' => $this->requestStack->getCurrentRequest()->query->get('filter_' . $entity_reference_field->get('field_name')) ?? '',
        '#attributes' => [
          'size' => '30'
        ],
      ];
    }

    foreach ($list_fields as $list_field) {
      $form['filter_container']['filter_' . $list_field->get('field_name')] = [
        '#type' => 'select',
        '#title' => strlen($list_field->get('label')) < 35 ? $list_field->get('label') : substr($list_field->get('label'), 0, 30) . "...",
        '#default_value' => $this->requestStack->getCurrentRequest()->query->get('filter_' . $list_field->get('field_name')) ?? '',
        '#options' => ['_none' => '- Any -', '_blank' => '<blank>'] + $list_field->getSettings()['allowed_values'],
      ];
    }

    $form['filter_container']['filter_status'] = [
      '#type' => 'select',
      '#title' => 'Publish Status',
      '#default_value' => $this->requestStack->getCurrentRequest()->query->get('filter_status') ?? '',
      '#options' => ['_none' => '- Any -', 'published' => 'Published', 'unpublished' => 'Unpublished'],
    ];

    $form['actions']['#type'] = 'actions';
    $form['actions']['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Apply'),
      '#button_type' => 'primary',
    ];
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {}

}
