class SchedulesController < ApplicationController
  make_resourceful do 
    actions :all

    before :show do
      @sdate = DateTime.parse(params[:sdate]) unless params[:sdate].blank?
      @sdate ||= @schedule.datetime_from
      @schedule_detail = ScheduleDetail.find_or_create(@schedule.id, @sdate)
    end

    before :new do
      @schedules = [@schedule]
    end

    before :create do
      @sdate = DateTime.parse(params[:sdate]) unless params[:sdate].blank?
      @sdate ||= @schedule.datetime_from
      @schedule_detail = ScheduleDetail.find_or_create(@schedule.id, @sdate)
    end

    before :update do
      @sdate = DateTime.parse(params[:sdate]) unless params[:sdate].blank?
      @sdate ||= @schedule.datetime_from
      @schedule_detail = ScheduleDetail.find_or_create(@schedule.id, @sdate)
    end
  end

  def change_date
    @date = DateTime.parse("#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}")
    if params[:id]
      @schedule = Schedule.find_by_id params[:id].to_i
    else
      @schedules = Schedule.find(:all)
    end
    render :partial => "/schedules/cal"
  end

end
