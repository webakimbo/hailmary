class User < ActiveRecord::Base

  belongs_to :group

  # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  has_attached_file :avatar
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # attr_accessor :groups

  def display_name
    name = display_name_as.to_sym rescue ""
    case name
      when :handle then handle
      else "#{first_name} #{last_name}"
    end
  end

end
