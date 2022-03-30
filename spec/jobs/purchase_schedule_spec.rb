require "rails_helper"

RSpec.describe ScheduleJob, :type => :job do
    describe "purchase schedule Job" do
        before(:each) do
            ActiveJob::Base.queue_adapter = :test
        end
        
        it "default schedule" 

        it "disabeld schedule"

        it "custom time schedule"

    end

end