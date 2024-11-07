# frozen_string_literal: true

require 'rails_helper'

describe 'Preferences' do
  let(:user) { create(:user) }
  let(:preference) { build(:preference) }
  let(:params) { { preference: preference.attributes } }

  before { sign_in user }

  describe 'POST create' do
    subject { post preferences_path, params: }

    context 'when success' do
      it 'creates the preference' do
        expect { subject }.to change(Preference, :count).by(1)
      end

      it 'have http status 302' do
        expect(subject).to eq(302)
      end

      it 'redirect to index' do
        expect(subject).to redirect_to(preferences_path)
      end
    end

    context 'when fails' do
      let(:preference) { build(:preference, name: nil) }

      it 'does not create the preference' do
        expect { subject }.not_to change(Preference, :count)
      end

      it 'have http status 422' do
        expect(subject).to eq(422)
      end
    end
  end

  describe 'PATCH update' do
    subject { patch preference_path(id), params: }

    let(:id) { preference.id }
    let(:preference) { create(:preference) }
    let(:params) { { preference: { name: 'name_updated' } } }

    context 'when success' do
      it 'update the preference' do
        subject
        expect(preference.reload.name).to eq('name_updated')
      end

      it 'redirect to index' do
        expect(subject).to redirect_to(preferences_path)
      end

      it 'have http status 302' do
        expect(subject).to eq(302)
      end
    end

    context 'when fails' do
      let(:id) { preference.id + 1 }

      it 'doesn\'t update the preference' do
        subject
        expect(preference.reload.name).not_to eq('name_updated')
      end

      it 'have http status 404' do
        expect(subject).to eq(404)
      end
    end
  end

  describe 'DELETE destroy' do
    subject { delete preference_path(id) }

    let(:id) { preference.id }
    let!(:preference) { create(:preference) }

    context 'when success' do
      it 'destroy the preference' do
        expect { subject }.to change(Preference, :count).by(-1)
      end

      it 'have http status 302' do
        expect(subject).to eq(302)
      end

      it 'redirect to index' do
        expect(subject).to redirect_to(preferences_path)
      end

      context 'when fails' do
        let(:id) { preference.id + 1 }

        it 'doesn\'t destroy the preference' do
          expect { subject }.not_to change(Preference, :count)
        end

        it 'have http status 404' do
          expect(subject).to eq(404)
        end
      end
    end
  end
end
