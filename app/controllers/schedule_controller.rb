class ScheduleController < ApplicationController
    before_action :set_schedule, only: [:show, :update]

    def update
        @schedule.update!(schedule_params)
    end

    def events
        start_date, end_date = parse_time.values_at(:start_date, :end_date)
        @events = PurchaseSchedule.where(date: start_date..end_date)
    end

    private

    def set_schedule
        @schedule = PurchaseSchedule.find_or_create_by(date: params.fetch(:date, Date.today))
    end

    def schedule_params
        params.require(:purchase_schedule).permit(:time, :enabled)
    end

    def parse_time
        byebug
        [:start_date, :end_date].reduce({}) {|hash, key| hash.merge( key => Time.at(params[key][0..9].to_i))}
    end

end
