# == Schema Information
#
# Table name: resources
#
#  id         :bigint(8)        not null, primary key
#  company_id :bigint(8)
#  code       :string(255)      not null
#  type       :string(255)      not null
#  name       :string(255)      not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ResourceJbu < Resource
end
