# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show recipe', :js do
  let(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }

  before do
    sign_in user
    visit recipes_path
    show_first_recipe
  end

  describe '#show' do
    context 'when clicking on some recipe' do
      it 'show the Name label' do
        within '#panel' do
          expect(page).to have_content('Name')
        end
      end

      it 'name it\'s not editable' do
        within '#panel' do
          expect(page).to have_field('recipe[name]', disabled: true)
        end
      end

      it 'name it\'s not blank' do
        within '#panel' do
          expect(find_field('recipe[name]', disabled: true).value).not_to be_empty
        end
      end

      it 'show the description area' do
        within '#panel' do
          expect(page).to have_css('textarea')
        end
      end

      it 'description it\'s not blank' do
        within '#panel' do
          expect(page).to have_css('textarea', text: /\S/)
        end
      end
    end
  end

  def show_first_recipe
    within all('tbody tr').first do
      click_on 'Show'
    end
  end
end
