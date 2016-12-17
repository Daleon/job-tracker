class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    # @companies = Company.where(location_params).order(city_params)
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      flash[:success] = "#{@company.name} added!"
      redirect_to company_path(@company)
    else
      render :new
    end
  end

  def show
    redirect_to company_jobs_path(@company)
  end

  def edit
  end

  def update
    @company.update(company_params)
    if @company.save
      flash[:success] = "#{@company.name} updated!"
      redirect_to company_path(@company)
    else
      render :edit
    end
  end

  def destroy
    if @company.jobs.count == 0
      @company.delete
      flash[:success] = "#{@company.name} was successfully deleted!"
      redirect_to companies_path
    else
      flash[:error] = "All jobs must be deleted from #{@company.name} before the company can be deleted!"
      redirect_to companies_path
    end
  end


  private

  def company_params
    params.require(:company).permit(:name)
  end

  # def city_params
  #   return "city" if params[:sort] == "location"
  # end
  #
  # def location_params
  #   return "city = '#{params[:location]}'" if params[:location]
  # end

  def set_company
    @company = Company.find(params[:id])
  end

end
