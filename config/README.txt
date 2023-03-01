This directory allows for Drupal 8 (and higher) Configuration Management workflows. It is referred to as the 'vcs' directory. Users of prior versions of Drupal may ignore or remove this directory.

Please read https://docs.acquia.com/cloud/manage/code/config-d8 for more details.

Directory break down:
| Name    | Explanation                                                   |
---------------------------------------------------------------------------
| default | config that are same across all environments                  |
| local   | config that applies only to local environments                |
| acquia  | config that are similar between all acquia cloud environments |
| dev     | config that only applies to acquia lower environments         |
| prod    | config that only applies to acquia production environments    |

Settings file will enable config split based on environment:
| Environment       | Enable Config |
-------------------------------------
| Local Dev         | local         |
| Acquia Lower      | acquia + dev  |
| Acquia Production | acquia + prod |

Note:
- Since acquia cloud environments share configuration we have created acquia config split.
