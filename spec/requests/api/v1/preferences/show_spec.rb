# frozen_string_literal: true

describe 'GET api/v1/preferences/:id' do
  subject { get api_v1_preference_path(preference_id), headers: auth_headers, as: :json }

  let(:preference) { create(:preference) }
  let(:preference_id) { preference.id }
  let(:user) { create(:user) }

  context 'when success' do
    it 'returns http status 200' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns preference with correct attributes' do
      subject
      expect(json[:id]).to eq(preference.id)
    end

    it 'returns preference name' do
      subject
      expect(json[:name]).to eq(preference.name)
    end

    it 'returns preference description' do
      subject
      expect(json[:description]).to eq(preference.description)
    end

    it 'returns preference restriction' do
      subject
      expect(json[:restriction]).to eq(preference.restriction)
    end
  end

  context 'when fails' do
    let(:preference_id) { -1 }

    it 'returns http status 404' do
      subject
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error message' do
      subject
      expect(json[:error]).to eq('preference not found')
    end
  end
end
