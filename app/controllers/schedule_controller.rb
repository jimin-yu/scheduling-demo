# default 날짜에는 기본적으로 사입 요청 한다고 생각
# custom -> default 날짜에 disable / 혹은 시간 변경

class ScheduleController < ApplicationController
    before_action :set_schedule

    def update
        @schedule.update!(schedule_params)
    end

    def events
        render json: {message: 'hello'}
    end

    private

    def set_schedule
        @schedule = PurchaseSchedule.find_or_create_by(date: params.fetch(:date, Date.today))
    end

    def schedule_params
        params.require(:purchase_schedule).permit(:time, :enabled)
    end

end
