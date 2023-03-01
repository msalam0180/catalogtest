<?php
/**
 * SAML 2.0 remote SP metadata for SimpleSAMLphp.
 *
 * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-sp-remote
 */
$env = !empty($_ENV['AH_SITE_ENVIRONMENT']) ? $_ENV['AH_SITE_ENVIRONMENT'] : '';

$idpserver = 'adfsstg';
//DEV and STAGING share a non-prod ADFS server, prod has its own
//if ($env == 'prod') {
//	$idpserver = 'adfs';
//}

$metadata['http://adfsstg.sec.gov/adfs/services/trust'] = [
  'entityid' => 'http://adfsstg.sec.gov/adfs/services/trust',
  'contacts' => [
      [
          'contactType' => 'support',
      ],
  ],
  'metadata-set' => 'saml20-sp-remote',
  'AssertionConsumerService' => [
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
          'Location' => 'https://adfsstg.sec.gov/adfs/ls/',
          'index' => 0,
          'isDefault' => true,
      ],
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
          'Location' => 'https://adfsstg.sec.gov/adfs/ls/',
          'index' => 1,
      ],
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
          'Location' => 'https://adfsstg.sec.gov/adfs/ls/',
          'index' => 2,
      ],
  ],
  // 'SingleLogoutService' => [
  //     [
  //         'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
  //         'Location' => 'https://adfsstg.sec.gov/adfs/ls/',
  //     ],
  //     [
  //         'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
  //         'Location' => 'https://adfsstg.sec.gov/adfs/ls/',
  //     ],
  // ],
  'NameIDFormat' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
  'keys' => [
      [
          'encryption' => true,
          'signing' => false,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC4DCCAcigAwIBAgIQOcHndeu5iblNaP/5qtZy9zANBgkqhkiG9w0BAQsFADAsMSowKAYDVQQDEyFBREZTIEVuY3J5cHRpb24gLSBhZGZzc3RnLnNlYy5nb3YwHhcNMjAwODA2MTcyMTMyWhcNMjIwODA2MTcyMTMyWjAsMSowKAYDVQQDEyFBREZTIEVuY3J5cHRpb24gLSBhZGZzc3RnLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC0vyoqa5ODvZE1xjsir9hT6MqfVGBQd0Y8QVfHUUZkSbqxrgB9+7cV54SMGJEqoephD7BN7IpFHc3rWXzqx4lJveVeZ4QD0F7p/cZ8BUbkQ7zj2ScDSL24h2SWIp1zQ9eF43WmEX3e5JrtqYry3v+9OR9hR46SUhTV3XjUWkpNVqKRIHqx4cKZQi2W2NCUP5X/ospBXzvKb6Kq2big2VbaNEgDiDr7eY1wWFuyCkgyA3yXNLrTBTQGARZh4azwDf8qWGVgLdFCLvaqMFRqCCKCudwfOOMshRqEB5K54aHssbXREWWGNqxjmsocGtgD1Eov+TaDjQLnCfPqKsc14f3pAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADKPgK+esxj2E59vRHCcwe+/+bJW9C3sk6Y6OmniPko1cZAnwErKIUQbTvswpAOshbEFwg1x+OSXIapyqY3+PIY+A1xnBcK0LDHLjMFM+KuFv3ErYyqbzL/RlBUL4Tv0swnEw2It5fWb4p3qEdc8MVRhWIqBQN2+MuQSzO9gokhWkHwRDzld3AP8vJuBW8155Mr4nhwEBhSaIDJtba71cQV9H73YuaX2/2EK9eUoC9CFcexI5/ExM3yyzHlq62bWVpJ13I5ROYR1YM5dmbEtBV9Nv/aGe92+PWnzpCgl67BES8WuWiVAOvfnHeRwCbx1tbxIQOUZ/7zrfm8Wv33EOJY=',
      ],
      [
          'encryption' => false,
          'signing' => true,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC2jCCAcKgAwIBAgIQR6mW3H/cpaNIsOzSMsbBhjANBgkqhkiG9w0BAQsFADApMScwJQYDVQQDEx5BREZTIFNpZ25pbmcgLSBhZGZzc3RnLnNlYy5nb3YwHhcNMjAwODA2MTcyMTUzWhcNMjIwODA2MTcyMTUzWjApMScwJQYDVQQDEx5BREZTIFNpZ25pbmcgLSBhZGZzc3RnLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCJ5lVeHQgxOh5O6RCtTQ+4uNedKvjWzpO6EFFn0cB+WihQh0zpUOpvRpO0DK8lLUhuaZSvfdmXS2x3BcSY7paKFAQLf1C1x8M0uC5Ubgw4/IKLPy9hDt+REzAp3nSG9QUx4q915MwcvSwoRaYCHlvm8qOMabdtkP/oDp4x8sl9VK3I8BqVR1da5SoY6LAqckD3tWN5lFRRsgglmfaCtBeNK9E0NQJxSJmRV9pz3R+b/zQuXy5IDY2sJcOyzUpDhnqPAmu8Lx5ViNeg9AncGbuFEPKRvcs3LyzX8sh/BUepcdxMg/NodcPJ0kXCdNp/PFqPxHYjCP4AeRkOuwBZDyBjAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIHj/oK7aqWpmS6Hp/bcWvXM3U+LdliBIDbLNXzHsXajHMsobfqZ1cY069hCsw7D4tbysGcbXHKemEv06+0t0zRAA8nRaM6EBfIpBFqSai7bHMUNsNVPZ0ngqrxx/rYGFrbPcNzNOsZWkJ/YG2mExRBtonioTYZB2jl/gK82+u0Gu6R/rabD/tnq/twSzqyo0g+iHD4cdWJpwhmpEwDi1v4NBNoOCWUMEFuS7qMUsSd0J1OOxR7CGF/cGRBlZRHlKo9jG6BR4lhjJ7XRuN07otJbdq6mQ2U0enwXJuX8N0J3i4SyBPuDnLhrMW14MNjHbagDggWuSmfSGr8h/BPTcJY=',
      ],
      [
          'encryption' => false,
          'signing' => true,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC2jCCAcKgAwIBAgIQVSuKj7QKzKZO/Wshff9DejANBgkqhkiG9w0BAQsFADApMScwJQYDVQQDEx5BREZTIFNpZ25pbmcgLSBhZGZzc3RnLnNlYy5nb3YwHhcNMjIwNzExMTczNDUyWhcNMjQwNTExMTczNDUyWjApMScwJQYDVQQDEx5BREZTIFNpZ25pbmcgLSBhZGZzc3RnLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClMGxvaSCPskvgzCi6DYE4opxKttXxbqwJrhyJa5Ad+f7RP7cF9Ks5pxqHhCE8wdNJhJOeTrgikGkFkot9gp2Ahj2e5PzAZxscAHoTjnmm1w1GrQb9wWEuzi6HiaKYny4tYosWALKnczjzqwcz3T25j5M1UyBjxdn9rHfuYOj5BNILkNL/Qfo8QGG4+R9KJTe+XyAsZGXclZd9sSEG39F9//1lkYzUsO/ePE4NTxU8mek1lHuRa2YpJMrugYm6AWBGyDsQZihXRrRNQTNcNERXyuzv+WvKYhYzEcidBFgWvJDteKpXdmgI0zefb6SmLR7nblMGVlpyOFMb/fFajYO1AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJ3TvHrEUj+ZLaG1ubtypf4PZ/Amge2TsOsRzgXobyuOI6bvXGaks/ZM93lLzNsgku/vZ1zWpLUA9NfNXs58+Ln0UHWD4DFxkzQvau0MFeXsa5KKINJM4mu/rMi/ZcJSXUtWVph1tv5f1KlYUSp51pTMwroFVbGUud1Ous/TBgYIeC1qPTJFP9jZeI0NzcIuR9GDmE1+8/HjsQgsMJYti8Nwgb26p8S++DE1oRjYYdgvCVwNjyqYMppxt8K0vqqb9nG8zeheTq7OJRMOFSAM310O61wz3xgcrZPg+sN0p3kiXqQqexUZvltoIBNIOdwUvk6EYvFiD9o0LN4SQeLbVNU=',
      ],
  ],
  'saml20.sign.assertion' => true,
];

$metadata['http://adfs.sec.gov/adfs/services/trust'] = [
  'entityid' => 'http://adfs.sec.gov/adfs/services/trust',
  'contacts' => [
      [
          'contactType' => 'support',
      ],
  ],
  'metadata-set' => 'saml20-sp-remote',
  'AssertionConsumerService' => [
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
          'Location' => 'https://adfs.sec.gov/adfs/ls/',
          'index' => 0,
          'isDefault' => true,
      ],
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
          'Location' => 'https://adfs.sec.gov/adfs/ls/',
          'index' => 1,
      ],
      [
          'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
          'Location' => 'https://adfs.sec.gov/adfs/ls/',
          'index' => 2,
      ],
  ],
  // 'SingleLogoutService' => [
  //     [
  //         'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
  //         'Location' => 'https://adfs.sec.gov/adfs/ls/',
  //     ],
  //     [
  //         'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
  //         'Location' => 'https://adfs.sec.gov/adfs/ls/',
  //     ],
  // ],
  'NameIDFormat' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
  'keys' => [
      [
          'encryption' => true,
          'signing' => false,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC2jCCAcKgAwIBAgIQfO108lTyMZhOYgOl/ezkDzANBgkqhkiG9w0BAQsFADApMScwJQYDVQQDEx5BREZTIEVuY3J5cHRpb24gLSBhZGZzLnNlYy5nb3YwHhcNMjAwODIyMDM0NTE2WhcNMjIwODIyMDM0NTE2WjApMScwJQYDVQQDEx5BREZTIEVuY3J5cHRpb24gLSBhZGZzLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC27s4mzS2A9BnvX7lAaNcNE1W5K2ENxWvMLloRVPcQEZPEdY3iQnfW7LZH4nfQ4ml+UJXWuYYhrQ2FTaDZJkM3qqp1OV85A3UVWh/JZrvwqHfvT3LqejVCcnA/+Ji9uMwI7s08lz3Adi0cpQIkm/TAt8CuazUguw3prxIuY9HaAAG1ghR80S6g+mj7eUNFTLXjJ5ksT3BhSqDkMNF3K1E1KDuwn5b1BUMt1fyE4rslIlr8GJxZSVdJuDtY886by8xemBgvrr3rAuCwIECuQPGVq38Md2bgzdOQIzS2J9IL8sjtsbd8YJWNUGOhTLqZUjFWcCVviBoz0fyL0ooSH4cfAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADzNdjegSbLnh8o/ngGxnYWA279BSbvz0ZvfkmVumMAAUxHfEjGnURfQybmHGA3/z8uK3cBmkccokbniqvdO2GLuJX1D0wEThFobE4Fdh7j6jsIzexFWN/Dg5ZbzhSNL7O9ZlBBc8WgXnAPQNJxs2zYz6dwJJ+s67N/UycD4unZguE0dsrAyVjo8Td3h4Y/1vNhehNTqBHba2CB0D68GqeoijqZLNQyWCpkFLV9n3/yU4QQOFvhmOfUJICAbl2AcApMROofDb+QlFWPUn2NzFQsDUf4AWwUs8cG2Wgj+dZanO0iJ2tI/YdkK3qruaGjWwuggdraU4ajZ6TfLPkgFbKM=',
      ],
      [
          'encryption' => false,
          'signing' => true,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC1DCCAbygAwIBAgIQFJQEvVHSA7dDVCfQ2IFeyzANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDExtBREZTIFNpZ25pbmcgLSBhZGZzLnNlYy5nb3YwHhcNMjAwODIyMDM0NTI4WhcNMjIwODIyMDM0NTI4WjAmMSQwIgYDVQQDExtBREZTIFNpZ25pbmcgLSBhZGZzLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDnRe1dIT8KVAjnII8xRub7cnNduGUmPPcaRn/q54gpGK53LWRcOOPmkCQ0Lh46FoBZLbLtwD1RX9zWb/195rYwN665Djk040HAXlkhoPG1tfKPd6f8nSe9NJ4pY+A/ws373dRy1SMtTptKstfOFq708DcusQ0gD4/xHwUIYZXb5fsJXUbMCS5ixPL4YI9bFRJPog2LxEJcGf0Rh4GhydUkNBT2i+8eZil10gJtIdf922+0r7h0DttKTK8SK4+NxNNdE8vxJfQBUh6KMx7pacniDo+kR4Roq9wAJpDWEhn6largFlkAZOcxcVnIkP6wq8vxZXVnNoo8g+BM8izUFir1AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAOK6k/2JFkyEM2znaE2MTqlTd5n/szZymLbLr6psHloK5QBbRe3UWRwpJigxZQKnmOjPt0wyEfGHuT2xXZ3iCO36jVho9+qgzJVFyD5GUOsmFo2vTh9WFJgDPEPqFiv27tsdSAfTNw8BDGUIlg88+IgiXnNB/W5scOCDigXEjx1VB1XqxcQ4mrYyWddrs/9MWCkjCTLaN6OQC2wbkT5pmb6h4UHLrWv/rD7VKp5K8iWWXp+CQRE+ouSZZkJzWK0DJWBh+4JT+Y6dGUDQt5A/D/J8xqfuH+zeUBAW3HCYbII4qa3SNszO0H8FKELGr/iPxC7O5fywZY3zRbhX5+FO+8E=',
      ],
      [
          'encryption' => false,
          'signing' => true,
          'type' => 'X509Certificate',
          'X509Certificate' => 'MIIC1DCCAbygAwIBAgIQHveg6OkV+KpCL0ZsM/UpYjANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDExtBREZTIFNpZ25pbmcgLSBhZGZzLnNlYy5nb3YwHhcNMjIwODExMTAxNTAzWhcNMjQwNjExMTAxNTAzWjAmMSQwIgYDVQQDExtBREZTIFNpZ25pbmcgLSBhZGZzLnNlYy5nb3YwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCdtIHWAElCBCszzhohGTVqp0sPK+xgWBOndy9b9movowDRb+Bo5spckLJ4IAmPe+7g8O8qi+8q/GGQ/1bXCw5+iMx3jsyGsuP/bWovN/VcVpxzs89xKr86smOdu7NmMxj//nWF+G4qJNMDkI4E6V4pdzjkQGZFBZD+dYX2JSLlAx+dwXHjuINo915kbiIgKwVbdHcmvOSWYKlria/rrIGodIpTHoBTY5qDdNNVptDIQ/QNqRSosO+RtYf3qgiznglBnXUsbcM+38clHSCtYQ3qrjVExfAVvBwI9oQvmzMoGwrnpU3nRrNl4NIxrabFDaDlPp9rw0D3N9B5N0Y8r5ijAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAEVn5ZOxp+CEExvaEzKn7rkyu2Hk29IBd8uXz3bPXRFFd5iNcll/CWNywweeVCObOJoFk8BXnDKNIfj2TNQNNC2ZTiGr2Wbd56l5urHs0iPS6wOohLv6A3S4RrQZYNAJKuzhF7JQJjmbm1LimSCsz3+TEATXNW4xogxD03D3b78LN0pVbM9V3XPfzS/FBWJAMkUwSADv3Dx5Xgu4FyGJSOM44Vlgkuxums34UC3n1yUOtxi0LuonKlwnBl9YbW3wf3KADEYX4nX6eF4sUaXbL92JrL453zHxK2tvilECdM3O+HuNZX1RKnrQyKwCUN3PImH129e8YuXzNQhqk44jbb8=',
      ],
  ],
  'saml20.sign.assertion' => true,
];
