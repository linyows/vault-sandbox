class User < ApplicationRecord
  include Vault::EncryptedModel
  vault_attribute :email
end
