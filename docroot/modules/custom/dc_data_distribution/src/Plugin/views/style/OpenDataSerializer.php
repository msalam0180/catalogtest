<?php

namespace Drupal\dc_data_distribution\Plugin\views\style;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\rest\Plugin\views\style\Serializer;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * A style plugin for Project Open Data json data. See DSITE-8066 for details.
 *
 * @ingroup views_style_plugins
 *
 * @ViewsStyle(
 *   id = "open_data_serializer",
 *   title = @Translation("Open Data Serializer"),
 *   help = @Translation("Configurable row output for data exports."),
 *   display_types = {"data"}
 * )
 */
class OpenDataSerializer extends Serializer {

  const DIVISION_OFFICE = 'U.S. Securities and Exchange Commission';

  const CONTACT_POINT_FN = "Open Data @ SEC";

  const CONTACT_POINT_HAS_EMAIL = "mailto:opendata@sec.gov";

  const LICENSE = "http://www.usa.gov/publicdomain/label/1.0/";

  /** @var array */
  protected array $sourceIdentifierIndex;

  /**
   * The entity type manager.
   *
   * @var EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    $instance = parent::create($container, $configuration, $plugin_id, $plugin_definition);
    $instance->entityTypeManager = $container->get('entity_type.manager');
    return $instance;
  }

  /**
   * This is a plugin view to format fields display as structured JSON.
   *
   * @return array|bool|float|int|string
   * @throws \Drupal\Component\Plugin\Exception\InvalidPluginDefinitionException
   * @throws \Drupal\Component\Plugin\Exception\PluginNotFoundException
   */
  public function render() {
    $datasetArray = [];

    $data = file_get_contents("https://www.sec.gov/data.json");

    // To associative array.
    $sourceJson = json_decode($data, TRUE);

    $sourceJson = is_array($sourceJson) ? $sourceJson : [];

    $sourceJson = $this->_indexJson($sourceJson);

    foreach ($this->view->result as $row_index => $row) {

      $datasetEntity = $row->_entity;

      $moderationState = $datasetEntity->moderation_state->value;

      // Check if entity is the default revision.
      if ($datasetEntity->isDefaultRevision()) {
        $vid = $this->entityTypeManager->getStorage('node')
          ->revisionIds($datasetEntity);
        $lastRevId = end($vid);
        // If the loaded revision is not the last one get the last revision
        // then from last revision get the latest moderation state.
        if ($datasetEntity->getRevisionId() != $lastRevId) {
          $latestRevision = $this->entityTypeManager->getStorage('node')
            ->loadRevision($lastRevId);
          $moderationState = $latestRevision->moderation_state->value;
        }
      }

      // Display content ONLY if moderation state is set to Public.
      if ($moderationState !== 'public') {
        continue;
      }

      $nid = $datasetEntity->nid->value;

      $accessLevelId = $datasetEntity->field_open_government_data_acces->target_id;
      $accessLevel = $this->entityTypeManager
        ->getStorage('taxonomy_term')
        ->load($accessLevelId)
        ->label();

      // Get SEC.gov Node Id field
      $nodeSECGovNodeId = $datasetEntity->field_sec_gov_node_id->value;

      $distribution = '';
      $landingPage = '';
      $temporal = '';
      if ($sourceJson) {
        // Look for SEC.gov Node Id field value if exist in sec.gov/data.json.
        $sourceJsonDistro = array_filter($sourceJson, fn($data) => trim($data['identifier']) == $nodeSECGovNodeId);
        if (!empty($sourceJsonDistro)) {

          foreach ($sourceJsonDistro as $distro) {
            $distribution = $distro['distribution'];
            $landingPage = $distro['landingPage'];
            $temporal = $distro['temporal'];
          }
        }
      }

      // Resources defined in https://resources.data.gov/resources/dcat-us/
      $dataset = [
        "@type" => "dcat:Dataset",
        "identifier" => $nid,
        "landingPage" => $landingPage,
        "bureauCode" => ["449:00"],
        "programCode" => ["000:000"],
        "accessLevel" => $accessLevel,
        "rights" => $datasetEntity->field_ogda_access_level_rights->value,
        "temporal" => $temporal,
        "license" => self::LICENSE,
        "title" => $datasetEntity->label(),
        "publisher" => [
          "@type" => "org:Organization",
          "name" => self::DIVISION_OFFICE,
          "subOrganizationOf" => [
            "name" => "U.S. Government",
          ],
        ],
      ];

      $modified = $datasetEntity->change->value;

      $dataset["modified"] = date("Y-m-d", $modified);

      $dataset["contactPoint"] = [
        "fn" => self::CONTACT_POINT_FN,
        "hasEmail" => self::CONTACT_POINT_HAS_EMAIL,
      ];

      if (isset($distribution)) {
        $dataset["distribution"] = $distribution;
      }

      $dataset["description"] = $datasetEntity->field_summary->value;

      $keywordRows = [];
      // Populate Tags or keywords.
      if (!empty($datasetEntity->field_tags)) {
        foreach ($datasetEntity->field_tags as $keywordEntity) {
          $target_id = $keywordEntity->target_id;
          $keywordRows[] = $this->entityTypeManager
            ->getStorage('taxonomy_term')
            ->load($target_id)
            ->label();
        }
      }

      $dataset["keyword"] = $keywordRows ?: '';

      // Remove element if empty values.
      $datasetArray[] = array_filter($dataset, fn($data) => !is_null($data) && $data !== '');
    }

    $renderArray = [
      "@id" => "https://www.sec.gov/data.json",
      "@type" => "dcat:Catalog",
      "conformsTo" => "https://project-open-data.cio.gov/v1.1/schema",
      "describedBy" => "https://project-open-data.cio.gov/v1.1/schema/catalog.json",
      "dataset" => $datasetArray,
    ];

    return json_encode($renderArray, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
  }

  /**
   * Process JSON and pull only needed elements.
   *
   * @param array $data
   *
   * @return array
   */
  public function _indexJson($data): ?array {
    if ($data['dataset']) {
      $index = [];
      foreach ($data['dataset'] as $item) {
        $nodeIdentifier = explode('/', $item['identifier']);
        $index[] = [
          'identifier' => $nodeIdentifier[4],
          'modified' => $item['modified'],
          'title' => $item['title'],
          'distribution' => $item['distribution'],
          'landingPage' => $item['landingPage'],
          'temporal' => $item['temporal']
        ];
      }
      return $index;
    }
    return [];
  }

}
