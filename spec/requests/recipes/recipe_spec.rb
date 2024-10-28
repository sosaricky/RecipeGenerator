# frozen_string_literal: true

require 'rails_helper'

describe 'Recipes' do
  let(:user) { create(:user) }
  let(:recipe) { build(:recipe) }
  let(:params) { { recipe: recipe.attributes } }

  before { sign_in user }

  describe 'POST create' do
    subject { post recipes_path, params: }

    context 'when success' do
      it 'creates the recipe' do
        expect { subject }.to change(Recipe, :count).by(1)
      end

      it 'have http status 302' do
        expect(subject).to eq(302)
      end

      it 'redirect to index' do
        expect(subject).to redirect_to(recipes_path)
      end
    end

    context 'when fails' do
      let(:recipe) { build(:recipe, ingredients: nil) }

      it 'does not create the recipe' do
        expect { subject }.not_to change(Recipe, :count)
      end

      it 'have http status 422' do
        expect(subject).to eq(422)
      end
    end
  end
end
