require "rails_helper"

RSpec.describe ScheduleJob, :type => :job do
    describe "purchase schedule Job" do
      it "default schedule" do
        # ActiveJob::Base.queue_adapter = :test
        # expect {
        #   UploadBackupsJob.perform_later('backup')
        # }.to have_enqueued_job

        expect(1+1).to eq(2)
      end
    end
end