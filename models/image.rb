class Account_Image < ActiveRecord::Base
  belongs_to :account
  has_many :image_comment, dependent: :destroy
  has_many :image_like
end
