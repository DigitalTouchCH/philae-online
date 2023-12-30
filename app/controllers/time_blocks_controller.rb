class TimeBlocksController < ApplicationController
  before_action :set_week_availability
  before_action :set_time_block, only: [:edit, :update, :destroy]
  before_action :authorize_time_block, only: [:edit, :update, :destroy]

  # GET /week_availabilities/:week_availability_id/time_blocks
  def index
    @time_blocks = policy_scope(@week_availability.time_blocks)
  end

  # GET /week_availabilities/:week_availability_id/time_blocks/new
  def new
    @time_block = @week_availability.time_blocks.build
  end

  # POST /week_availabilities/:week_availability_id/time_blocks
  def create
    @time_block = @week_availability.time_blocks.build(time_block_params)
    if @time_block.save
      redirect_to week_availability_time_blocks_path(@week_availability), notice: 'Time block was successfully created.'
    else
      render :new
    end
  end

  # GET /week_availabilities/:week_availability_id/time_blocks/:id/edit
  def edit
  end

  # PATCH/PUT /week_availabilities/:week_availability_id/time_blocks/:id
  def update
    respond_to do |format|
      if @time_block.update(time_block_params)
        format.html { redirect_to week_availabilities_path, notice: 'Time block was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /week_availabilities/:week_availability_id/time_blocks/:id
  def destroy
    @time_block.destroy if @time_block
    if @week_availability
      redirect_to week_availabilities_path, notice: 'Time block was successfully destroyed.'
    else
      redirect_to week_availabilities_path, alert: 'Week availability could not be found.'
    end
  end



  private

  def authorize_time_block
    authorize @time_block
  end

  def set_week_availability
    @week_availability = WeekAvailability.find(params[:week_availability_id])
  end

  def set_time_block
    @time_block = @week_availability.time_blocks.find(params[:id])
  end

  def time_block_params
    params.require(:time_block).permit(:week_day, :start_time, :end_time)
  end
end
