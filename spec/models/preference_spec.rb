# frozen_string_literal: true

# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text             not null
#  restriction :boolean
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Preference do
  subject { create(:preference, user:) }

  let!(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    context 'when the max_preferences limit is reached' do
      it 'doesn\'t create the preference' do
        create_list(:preference, Preference::MAX_PREFERENCES, user:)
        user.reload
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid, /You cannot add more preferences/)
      end
    end

    context 'when the max_preferences limit isn\'t reached' do
      it 'create the preference' do
        user.reload
        expect { subject }.to change(described_class, :count).by(1)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
