require 'vault/rails'

Vault::Rails.configure do |c|
  c.enabled = true
  c.application = 'rails'
  c.address = 'https://vault:8200'
  c.token = 'abcd-1234'
  c.ssl_verify = false
end
