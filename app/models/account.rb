class Account < ApplicationRecord
  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= "http://localhost:3000"

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    #SP section
    settings.issuer                         = url_base + "/saml/metadata"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"
    settings.protocol_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" # 指定しないとGet Request で /saml/acs を叩いてくるため

    idp_base_url = "https://auth.worksmobile.com/saml2"

    # IdP section
    settings.idp_entity_id                  = "#{idp_base_url}/#{ENV['IDP_GROUP_NAME']}"
    settings.idp_sso_target_url             = "#{idp_base_url}/idp/#{ENV['IDP_GROUP_NAME']}"
    settings.idp_slo_target_url             = "#{idp_base_url}/idp/#{ENV['IDP_GROUP_NAME']}/logout"
    settings.idp_cert_fingerprint           = "#{ENV['IDP_FINGERPRINT']}"
    settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA256

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Security section
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end
end
