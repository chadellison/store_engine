class User < ActiveRecord::Base
  authenticates_with_sorcery!
  # attr_accessible :title, :body

  attr_accessible :email, :name, :display_name, :password, :password_confirmation

  validates_confirmation_of :password
  validates :password, length: { minimum: 6, maximum: 20 }
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :name
  validates :display_name, length: { minimum: 2, maximum: 32 }, :unless => "display_name.blank?"

end
