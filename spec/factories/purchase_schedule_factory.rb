# == Schema Information
#
# Table name: purchase_schedules
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  time       :string(255)
#  enabled    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
    factory :purchase_schedule do
        date {Date.today}
        time {"#{rand(13..23)}:00"}
        enabled {true}
    end
end
