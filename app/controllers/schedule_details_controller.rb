class ScheduleDetailsController < ApplicationController
  make_resourceful do
    actions:all

    response_for :create, :update do
      redirect_to "/schedules/show/#{@schedule_detail.schedule_id}?sdate=#{@schedule_detail.schedule_date.strftime("%Y-%m-%d")}"
    end
  end
end

