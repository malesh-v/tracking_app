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

    describe 'GET #new' do
      it 'should create' do
        post :create, params: { status: { name: name} }
        Status.find_by_name(name).should be_nil
      end
    end

    describe 'GET #edit' do
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

    describe 'GET #new' do
      it 'should create' do
        post :create, params: { status: { name: name} }
        Status.find_by_name(name).should be_nil
      end
    end

    describe 'GET #edit' do
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

  describe 'logged as admin' do

    let(:admin) { FactoryGirl.create(:admin) }

    before do
      sign_in admin, no_capybara: true
    end

    describe 'GET #new' do
      it 'should create' do
        post :create, params: { status: { name: name} }
        Status.find_by_name(name).should_not be_nil
      end
    end

    describe 'GET #edit' do
      it 'edit the requested status' do
        put :update, params: {id: status.id, status: { name: name} }
        status.reload.name.should eq(name)
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested status' do
        expect {
          delete :destroy, params: {id: status.id }
        }.to change(Status, :count).by(-1)
      end
    end
  end
end