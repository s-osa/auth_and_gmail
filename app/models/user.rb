class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[a-zA-Z0-9\.\-\_]+@gmail.com\z/
  validates :email, email: true, format: {with: EMAIL_REGEXP}
end
