class PurchaseJob < ActiveJob::Base
    queue_as :default
  
    def perform(*args)
        Rails.logger.info "[#{Time.current}] SEND API TO WMS"
    end
  end