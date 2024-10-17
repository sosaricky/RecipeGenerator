# frozen_string_literal: true

# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  restriction :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Preference < ApplicationRecord
  MAX_PREFERENCES = 10
  validates :name, :description, presence: true
  belongs_to :user
end
