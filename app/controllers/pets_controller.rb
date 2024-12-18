class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :authorize_pet, only: %i[ show update destroy ]

  # GET /pets
  def index
    @pets = @current_user.pets
    render json: @pets.map { |pet| pet.as_json.merge(dynamic_age: pet.dynamic_age) }
  end

  # GET /pets/1
  def show
    render json: @pet.as_json.merge(dynamic_age: @pet.dynamic_age)
  end

  # POST /pets
  def create
    @pet = @current_user.pets.new(pet_params)

    if @pet.save
      render json: @pet, status: :created, location: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pets/1
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pets/1
  def destroy
    @pet.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  # Verifica se o pet pertence ao usuário logado
  def authorize_pet
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @pet.owned_by?(@current_user)
  end

  # Only allow a list of trusted parameters through.
  def pet_params
    params.require(:pet).permit(:user_id, :name, :species, :breed, :birth_date, :weight, :photo)
  end
end
