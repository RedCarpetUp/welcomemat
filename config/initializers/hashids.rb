Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with table name.
  config.salt = Rails.application.secrets.secret_key_base

  # The minimum length of generated hashids
  config.min_hash_length = 6

  #config.alphabet = "abcdefghijklmnopqrstuvwxyz" \
  #                  "1234567890"

  # Whether to override the `find` method
  config.override_find = true
end