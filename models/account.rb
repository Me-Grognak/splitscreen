class Account < ActiveRecord::Base
  has_many :account_image, dependent: :destroy

  include BCrypt

  def password=(pwd)
    return self.password_digest = BCrypt::Password.create(pwd)
  end

  def password
    return BCrypt::Password.new(self.password_digest)
  end

  def self.authenticate(username, password)
    current_user = Account.find_by(user_name: username)
    if current_user.password == password
      return current_user
    else
      return nil
    end
  end

end
