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
require "test_helper"

class PurchaseScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
