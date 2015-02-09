class User < ActiveRecord::Base
  validates :email, email: true, format: {with: /\A[a-zA-Z0-9\.\-\_]+@gmail.com\Z/}
end
