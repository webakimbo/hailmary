class Group < ActiveRecord::Base

  has_and_belongs_to_many :users

  # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  has_attached_file :avatar
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

end
