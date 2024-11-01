# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render plain: '404 Not Found', status: :not_found
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = RecipeGeneratorService.new(recipe_params[:ingredients], current_user.id).call
    if @recipe.save
      redirect_to recipes_path, notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  rescue RecipeGeneratorServiceError => exception
    redirect_to recipes_path, alert: exception.message
  end

  private

  def recipe_params
    params.require(:recipe).permit(:ingredients)
  end
end
