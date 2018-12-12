# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  name(名前)         :string(255)
#  password(パスワード)  :string(255)
#  accesable_type   :string(255)
#  accesable_id     :bigint(8)
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ApplicationRecord
end
