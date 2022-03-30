# == Schema Information
#
# Table name: purchase_schedules
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  time       :string(255)
#  enable     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PurchaseSchedule < ApplicationRecord
end
