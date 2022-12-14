class User < ApplicationRecord
  validates_presence_of :email, case_sensitive: false
  validates_uniqueness_of :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_presence_of :name
  validates_presence_of :password, confirmation: true, presence: true # password must match password_confirmation
  validates_presence_of :password_confirmation, presence: true # a password confirmation must be set
  
  has_many :user_parties
  has_many :parties, through: :user_parties

  has_secure_password

  def movie_cards_info
    cards = {}
    parties.each do |party|
      cards[party.id] = MovieFacade.movie_card(party.movie_id)
    end
    cards
  end
end