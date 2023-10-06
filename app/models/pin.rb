class Pin < ApplicationRecord
  has_many :comments
  belongs_to :user
  mount_uploader :pin_image, PinImageUploader
end
