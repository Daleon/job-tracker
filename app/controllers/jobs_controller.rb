class JobsController < ApplicationController
  before_action :set_company, except: [:show]
  before_action :set_job, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new, :create, :edit]

  def index
    @jobs = @company.jobs.all.order(interest_params)
    @contact = Contact.new
  end

  def new
    @job = Job.new()
  end

  def create
    @job = @company.jobs.new(job_params)
    if @job.save
      flash[:success] = "You created #{@job.title} at #{@company.name}"
      redirect_to company_job_path(@company, @job)
    else
      render :new
    end
  end

  def show
    @job = Job.find(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to company_job_path(@company, @job)
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    flash[:success] = "#{@job.title} was successfully deleted!"
    redirect_to company_jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :level_of_interest, :city, :category_id)
  end

  def interest_params
    return "level_of_interest" if params[:sort] == "interest"
  end

  def set_job
    @job = @company.jobs.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_categories
    @categories = Category.all
  end

  def city_params
    return "city" if params[:sort] == "location"
  end

  def location_params
    return "city = '#{params[:location]}'" if params[:location]
  end
end
