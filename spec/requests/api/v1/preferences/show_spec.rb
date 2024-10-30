# frozen_string_literal: true

describe 'GET api/v1/preferences/:id' do
  subject { get api_v1_preference_path(preference_id), headers: auth_headers, as: :json }

  let(:preference) { create(:preference) }
  let(:preference_id) { preference.id }
  let(:user) { create(:user) }

  before { subject }

  context 'when success' do
    it 'returns http status 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns preference with correct attributes' do
      expect(json[:id]).to eq(preference.id)
    end

    it 'returns preference name' do
      expect(json[:name]).to eq(preference.name)
    end

    it 'returns preference description' do
      expect(json[:description]).to eq(preference.description)
    end

    it 'returns preference restriction' do
      expect(json[:restriction]).to eq(preference.restriction)
    end
  end

  context 'when fails' do
    let(:preference_id) { -1 }

    it 'returns http status 404' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
