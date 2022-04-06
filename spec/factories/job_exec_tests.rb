# == Schema Information
#
# Table name: job_exec_tests
#
#  id         :bigint           not null, primary key
#  job_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :job_exec_test do
    job_name { "MyString" }
  end
end
