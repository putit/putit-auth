# == Schema Information
#
# Table name: blocked_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BlockedToken < ApplicationRecord
end
