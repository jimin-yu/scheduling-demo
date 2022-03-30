# default 날짜에는 기본적으로 사입 요청 한다고 생각
# custom -> default 날짜에 disable / 혹은 시간 변경

class ScheduleController < ApplicationController

    def hello
        render json: {message: 'hello'}
    end
    
end
