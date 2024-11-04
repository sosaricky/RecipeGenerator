# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :set_preference, only: %i[show edit update destroy]
  before_action :check_max_preferences_reached, only: %i[create]
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def show; end

  def new
    @preference = Preference.new
  end

  def edit; end

  def create
    @preference = current_user.preferences.new(preference_params)
    if @preference.save!
      redirect_to preferences_path, notice: t('views.preferences.create_success')
    else
      render :new, status: unprocessable_entity
    end
  end

  def update
    if @preference.update(preference_params)
      redirect_to preferences_path, notice: t('views.preferences.update_success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @preference.destroy
      redirect_to preferences_path, notice: t('views.preferences.destroy_success')
    else
      redirect_to preferences_path, alert: t('views.preferences.destroy_failure')
    end
  end

  private

  def set_preference
    @preference = Preference.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render plain: '404 Not Found', status: :not_found
  end

  def check_max_preferences_reached
    return unless current_user.preferences.count == Preference::MAX_PREFERENCES

    redirect_to preferences_path, notice: t('views.preferences.limit_reached_message', max: Preference::MAX_PREFERENCES)
  end

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
