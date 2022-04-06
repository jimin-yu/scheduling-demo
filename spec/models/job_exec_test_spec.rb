# == Schema Information
#
# Table name: job_exec_tests
#
#  id         :bigint           not null, primary key
#  job_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe JobExecTest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
