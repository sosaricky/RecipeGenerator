# frozen_string_literal: true

require 'rails_helper'

describe 'Recipes' do
  let(:user) { create(:user) }
  let(:recipe) { build(:recipe) }
  let(:params) { { recipe: recipe.attributes } }

  before do
    stub_request(:post, 'https://api.openai.com/v1/chat/completions')
      .to_return(
        body:
        {
          choices: [
            {
              index: 0,
              message: {
                role: 'assistant',
                content: <<-JSON
              {
                "name": "Potato and Rice Casserole",
                "content": "Preheat the oven to 375°F"
              }
                JSON
              }
            }
          ]
        }
        .to_json,
        headers: { Content_Type: 'application/json' }
      )

    sign_in user
  end

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

      it 'has http status 302' do
        expect(subject).to eq(302)
      end

      it 'does not create the recipe' do
        expect { subject }.not_to change(Recipe, :count)
      end
    end
  end
end
