require "rails_helper"
require 'sidekiq/testing'
require 'sidekiq/cron/job'
Sidekiq::Testing.fake!

RSpec.describe ScheduleJob, :type => :job do
    describe "purchase schedule Job" do
        include ActiveJob::TestHelper

        before(:each) do
            ActiveJob::Base.queue_adapter = :test
        end

        it "default schedule" do
            expect(PurchaseSchedule.find_by(date: Date.today)).to eq(nil)  
            schedule_job()
            expect(PurchaseJob).to have_been_enqueued.at(Time.parse('10pm'))
        end

        it "disabeld schedule" do
            create(:purchase_schedule, enabled: false)
            schedule_job()
            expect(PurchaseJob).not_to have_been_enqueued
        end

        it "custom time schedule" do
            today_schedule=create(:purchase_schedule)
            schedule_job()
            expect(PurchaseJob).to have_been_enqueued.at(Time.parse(today_schedule.time))
        end
    end

    describe 'cron time' do
        before do
          @args = {
            name: "Test",
            cron: "0 12 * * 1-5"
          }
          @job = Sidekiq::Cron::Job.new(@args)
        end
    
        it 'should correctly parse new format' do
            weekday=Time.new(2022,3,30,12,34,56)
            saturday=Time.new(2022,3,26,12,34,56)
            sunday=Time.new(2022,3,27,12,34,56)
            expect(@job.last_time(weekday)).eql? (weekday.noon)
            expect(@job.last_time(saturday)).eql? (saturday.yesterday.noon)
            expect(@job.last_time(sunday)).eql? ((sunday-2.day).noon)
        end

      end

end



def schedule_job()
    today_schedule = PurchaseSchedule.find_by(date: Date.today)

    if today_schedule.blank?
        PurchaseJob.set(wait_until: Time.parse('10pm')).perform_later()
    elsif today_schedule.enabled
        PurchaseJob.set(wait_until: Time.parse(today_schedule.time)).perform_later()
    end
end