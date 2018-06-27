require 'rails_helper'
require 'support/utilities'

describe StatusesController do

  let(:staffmember) { FactoryGirl.create(:staff_member) }
  let(:status)      { Status.first }
  let(:name)        { 'status new' }

  before do
    Status.create!(name: 'example')
  end

  describe 'non logged in' do

    describe 'GET statuses list' do
      specify do
        visit statuses_path
        expect(current_path).to eq root_path
      end
    end

    describe 'GET #new' do
      specify do
        visit new_status_path
        expect(current_path).to eq root_path
      end
      it 'should create' do
        post :create, params: { status: { name: name} }
        Status.find_by_name(name).should be_nil
      end
    end

    describe 'GET #edit' do
      specify do
        visit edit_status_path(status)
        expect(current_path).to eq root_path
      end
      it 'edit the requested status' do
        put :update, params: {id: status.id, status: { name: name} }
        status.reload.name.should_not eq(name)
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested status' do
        expect {
          delete :destroy, params: {id: status.id }
        }.to change(Status, :count).by(0)
      end
    end
  end

  describe 'logged as non admin' do
    before do
      sign_in staffmember, no_capybara: true
    end

    describe 'GET statuses list' do
      specify do
        visit statuses_path
        expect(current_path).to eq root_path
      end
    end

    describe 'GET #new' do
      specify do
        visit new_status_path
        expect(current_path).to eq root_path
      end
      it 'should create' do
        post :create, params: { status: { name: name} }
        Status.find_by_name(name).should be_nil
      end
    end

    describe 'GET #edit' do
      specify do
        visit edit_status_path(status)
        expect(current_path).to eq root_path
      end
      it 'edit the requested status' do
        put :update, params: {id: status.id, status: { name: name} }
        status.reload.name.should_not eq(name)
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested status' do
        expect {
          delete :destroy, params: {id: status.id }
        }.to change(Status, :count).by(0)
      end
    end
  end
end

=begin
  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested status' do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: new_attributes}, session: valid_session
        status.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the status' do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: valid_attributes}, session: valid_session
        expect(response).to redirect_to(status)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the edit template)' do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested status' do
      status = Status.create! valid_attributes
      expect {
        delete :destroy, params: {id: status.to_param}, session: valid_session
      }.to change(Status, :count).by(-1)
    end

    it 'redirects to the statuses list' do
      status = Status.create! valid_attributes
      delete :destroy, params: {id: status.to_param}, session: valid_session
      expect(response).to redirect_to(statuses_url)
    end
  end
=end


