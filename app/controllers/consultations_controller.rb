class ConsultationsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_consultation, only: %i[ show update destroy ]
  before_action :authorize_pet, only: %i[ create ]
  before_action :authorize_consultation, only: %i[ show update destroy ]

  # GET /consultations
  def index
    @consultations = Consultation.joins(:pet).where(pets: { user_id: @current_user.id })
    render json: @consultations
  end

  # GET /consultations/:id
  def show
    render json: @consultation
  end

  # POST /consultations
  def create
    @consultation = Consultation.new(consultation_params)

    if @consultation.save
      render json: @consultation, status: :created
    else
      render json: @consultation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /consultations/:id
  def update
    if @consultation.update(consultation_params)
      render json: @consultation
    else
      render json: @consultation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /consultations/:id
  def destroy
    @consultation.destroy!
    head :no_content
  end

  private

  def set_consultation
    @consultation = Consultation.find(params[:id])
  end

  def authorize_consultation
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @consultation.pet.owned_by?(@current_user)
  end

  def authorize_pet
    pet_id = consultation_params[:pet_id]  
    pet = Pet.find(pet_id)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless pet.owned_by?(@current_user)
  end

  def consultation_params
    params.require(:consultation).permit(:pet_id, :date, :consultation_type, :veterinarian, :notes)
  end
  
end
