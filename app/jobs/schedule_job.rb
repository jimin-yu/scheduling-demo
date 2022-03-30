# 매일 schedule 테이블 조건을 확인해서 레디스큐에 purchase job을 엔큐하는 CronJob
class ScheduleJob < ActiveJob::Base
    queue_as :schedule
  
    def perform(*args)
        Rails.logger.info "zone: #{Time.zone}"
        today_schedule = PurchaseSchedule.find_by(date: Date.today)
    
        if today_schedule.blank?
            PurchaseJob.set(wait_until: Time.parse('10pm')).perform_later()
        elsif today_schedule.enabled
            PurchaseJob.set(wait_until: Time.parse(today_schedule.time)).perform_later()
        end
    end
    
end