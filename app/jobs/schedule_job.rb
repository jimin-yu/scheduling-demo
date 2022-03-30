# 매일 schedule 테이블 조건을 확인해서 레디스큐에 purchase job을 엔큐하는 CronJob
class ScheduleJob < ActiveJob::Base
    queue_as :default
  
    def perform(*args)
        today_schedule = PurchaseSchedule.where(date: Date.today)

        PurchaseJob.set(wait_until: Time.now+30).perform_later()
    end
end