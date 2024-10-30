# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  ingredients :text             not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
require 'rails_helper'
RSpec.describe Recipe do
  describe 'validations' do
    subject { build(:recipe) }

    it { is_expected.to validate_presence_of(:ingredients) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
