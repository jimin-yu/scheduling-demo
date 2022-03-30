# wms에 사입 요청 api를 전송하는 Job
class PurchaseJob < ActiveJob::Base
    queue_as :schedule
  
    def perform(*args)
        Rails.logger.info "[#{Time.current}] SEND API TO WMS"
    end
end