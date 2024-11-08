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
class Preference < ApplicationRecord
  MAX_PREFERENCES = 5
  validates :name, :description, presence: true
  validate :check_max_preferences_reached
  belongs_to :user

  def check_max_preferences_reached
    return unless user.preferences.count >= Preference::MAX_PREFERENCES
      errors.add(:base, t('views.preferences.limit_reached_message', max: Preference::MAX_PREFERENCES))
  end
end
