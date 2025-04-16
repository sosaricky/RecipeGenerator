# frozen_string_literal: true

require_relative '../services/adapters/deep_seek_adapter'
class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show destroy]
  def index
    @recipes = Recipe.all
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def create
    @adapter = DeepSeekAdapter.new
    @recipe = RecipeGeneratorService.new(recipe_params[:ingredients], current_user.id, @adapter).call
    if @recipe.save
      redirect_to recipes_path, notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  rescue RecipeGeneratorServiceError => exception
    redirect_to recipes_path, alert: exception.message
  end

  def destroy
    if @recipe.destroy
      redirect_to recipes_path, notice: t('views.recipes.destroy_success')
    else
      redirect_to recipes_path, alert: t('views.recipes.destroy_failure')
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render plain: '404 Not Found', status: :not_found
  end

  def recipe_params
    params.require(:recipe).permit(:ingredients)
  end
end
