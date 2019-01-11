# == Schema Information
#
# Table name: users
#
#  id             :bigint(8)        not null, primary key
#  name           :string(255)
#  password       :string(255)
#  accesable_type :string(255)
#  accesable_id   :bigint(8)
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
  include DeviseTokenAuth::Concerns::User
end
