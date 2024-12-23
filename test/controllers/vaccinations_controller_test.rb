require "test_helper"

class VaccinationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vaccination = vaccinations(:one)
  end

  test "should get index" do
    get vaccinations_url, as: :json
    assert_response :success
  end

  test "should create vaccination" do
    assert_difference("Vaccination.count") do
      post vaccinations_url, params: { vaccination: { application_date: @vaccination.application_date, next_dose_date: @vaccination.next_dose_date, notes: @vaccination.notes, pet_id: @vaccination.pet_id, vaccine_type: @vaccination.vaccine_type } }, as: :json
    end

    assert_response :created
  end

  test "should show vaccination" do
    get vaccination_url(@vaccination), as: :json
    assert_response :success
  end

  test "should update vaccination" do
    patch vaccination_url(@vaccination), params: { vaccination: { application_date: @vaccination.application_date, next_dose_date: @vaccination.next_dose_date, notes: @vaccination.notes, pet_id: @vaccination.pet_id, vaccine_type: @vaccination.vaccine_type } }, as: :json
    assert_response :success
  end

  test "should destroy vaccination" do
    assert_difference("Vaccination.count", -1) do
      delete vaccination_url(@vaccination), as: :json
    end

    assert_response :no_content
  end
end
