class LogController < ApplicationController
    def index
        @logs = JobExecTest.all
    end
end