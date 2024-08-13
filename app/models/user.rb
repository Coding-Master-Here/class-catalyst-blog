class User < ApplicationRecord
    has_many :posts, dependent: :destroy
  
    validates :username, presence: true
    validates :email, presence: true, uniqueness: true
  
    before_create :generate_auth_token
  
    private
  
    def generate_auth_token
      self.auth_token = SecureRandom.hex
    end
  end
  