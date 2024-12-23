class VaccinationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_vaccination, only: %i[ show update destroy ]
  before_action :authorize_pet, only: %i[ create ]
  before_action :authorize_vaccination, only: %i[ show update destroy ]

  # GET /vaccinations
  def index
    @vaccinations = Vaccination.joins(:pet).where(pets: { user_id: @current_user.id })
    render json: @vaccinations
  end

  # GET /vaccinations/:id
  def show
    render json: @vaccination
  end

  # POST /vaccinations
  def create
    @vaccination = Vaccination.new(vaccination_params)

    if @vaccination.save
      render json: @vaccination, status: :created
    else
      render json: @vaccination.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vaccinations/:id
  def update
    if @vaccination.update(vaccination_params)
      render json: @vaccination
    else
      render json: @vaccination.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vaccinations/:id
  def destroy
    @vaccination.destroy!
    head :no_content
  end

  private

  def set_vaccination
    @vaccination = Vaccination.find(params[:id])
  end

  def authorize_vaccination
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @vaccination.pet.owned_by?(@current_user)
  end

  def authorize_pet
    pet_id = vaccination_params[:pet_id]  
    pet = Pet.find(pet_id)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless pet.owned_by?(@current_user)
  end

  def vaccination_params
    params.require(:vaccination).permit(:pet_id, :vaccine_type, :application_date, :next_dose_date, :notes)
  end
end
