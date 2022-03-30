class ExampleJob < ActiveJob::Base
    queue_as :default
  
    def perform(*args)
        PurchaseJob.set(wait_until: Time.now+30).perform_later()
    end
  end