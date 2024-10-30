# frozen_string_literal: true

module API
  module V1
    class PreferencesController < API::V1::APIController
      def show
        @preference = Preference.find(params[:id])
        render json: @preference
      end
    end
  end
end
