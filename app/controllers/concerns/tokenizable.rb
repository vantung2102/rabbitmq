module Tokenizable
  extend ActiveSupport::Concern

  def encrypt_token(data)
    cryptor.encrypt_and_sign(data)
  end

  def decrypt_token(token)
    return unless token.present?

    begin
      cryptor.decrypt_and_verify(token)
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      nil
    end
  end

  private

  SECRET_KEY = ENV['CRYPTOR_SECRET_KEY']

  def cryptor
    ActiveSupport::MessageEncryptor.new(SECRET_KEY)
  end
end
