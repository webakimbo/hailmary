class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :user_seasons, dependent: :destroy
  has_many :sim_user_seasons, dependent: :destroy
  has_one :app_admin_role

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, if: :email_required?
  validates :phone, presence: true, if: :phone_required?

  after_create :create_user_seasons

  def full_name
    [first_name, last_name].join(" ")
  end

  def is_admin?
    app_admin_role.present?
  end

private

  def email_required?
    !phone.present? || contact_preference == "email"
  end

  def phone_required?
    !email.present? || contact_preference == "phone"
  end

  def create_user_seasons
    season = Season.current_season
    UserSeason.create!(user: self, season: season)

    if sim_mode?
      SimUserSeason.create!(competitor: self, season: season)
    end
  end

end
