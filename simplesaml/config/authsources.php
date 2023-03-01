<?php

$env = !empty($_ENV['AH_SITE_ENVIRONMENT']) ? $_ENV['AH_SITE_ENVIRONMENT'] : '';

$idp = 'http://adfsstg.sec.gov/adfs/services/trust';
//DEV and STAGING share a non-prod ADFS server, prod has its own
if ($env == 'prod') {
	$idp = 'http://adfs.sec.gov/adfs/services/trust';
}

$config = array(
  'admin' => array(
    'core:AdminPassword',
  ),
  'default-sp' => array(
   'saml:SP',

   // You can get this from ADFS Federation file
   // Contact your ADFS administrator
   // to obtain this information.
   'entityID'             => 'urn:drupal:adfs-saml-catalog-'.$env,
   'idp'                  => $idp,
   'redirect.sign'        => true,
   'redirect.validate'    => true,
   'assertion.encryption' => true,
   'sign.logout'          => true,
   'NameIDFormat' 		  => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',

   // Generate using openssl, @see example above.
   // These are the certs from `/cert` directory.
   'privatekey'           => 'catalog.sec.gov.key',
   'certificate'          => 'CatalogServerCertificate.crt',
   // Defaults to SHA1 (http://www.w3.org/2000/09/xmldsig#rsa-sha1)
   'signature.algorithm'  => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  ),
);
