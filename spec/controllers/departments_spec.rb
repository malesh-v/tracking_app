require 'rails_helper'
require 'support/utilities'

describe DepartmentsController do

  let(:staffmember) { FactoryGirl.create(:staff_member) }
  let(:department)  { Department.first }
  let(:name)        { 'department new' }

  before do
    Department.create!(name: 'example')
  end

  describe 'non logged in' do

    describe 'guest try create new department' do
      it 'should create' do
        post :create, params: { department: { name: name} }
        Department.find_by_name(name).should be_nil
      end
    end

    describe 'guest try edit department' do
      it 'edit the requested department' do
        put :update, params: {id: department.id, department: { name: name} }
        department.reload.name.should_not eq(name)
      end
    end

    describe 'guest try delete  department' do
      it 'destroys the requested department' do
        expect {
          delete :destroy, params: {id: department.id }
        }.to change(Department, :count).by(0)
      end
    end
  end

  describe 'logged as non admin' do
    before do
      sign_in staffmember, no_capybara: true
    end

    describe 'try create department as logged non admin' do
      it 'should create' do
        post :create, params: { department: { name: name} }
        Department.find_by_name(name).should be_nil
      end
    end

    describe 'try edit department as logged non admin' do
      it 'edit the requested department' do
        put :update, params: {id: department.id, department: { name: name} }
        department.reload.name.should_not eq(name)
      end
    end

    describe 'try delete department as logged non admin' do
      it 'destroys the requested department' do
        expect {
          delete :destroy, params: {id: department.id }
        }.to change(Department, :count).by(0)
      end
    end
  end

  describe 'logged as admin' do

    let(:admin) { FactoryGirl.create(:admin) }

    before do
      sign_in admin, no_capybara: true
    end

    describe 'admin be able create department' do
      it 'should create' do
        post :create, params: { department: { name: name} }
        Department.find_by_name(name).should_not be_nil
      end
    end

    describe 'admin be able edit department' do
      it 'edit the requested department' do
        put :update, params: {id: department.id, department: { name: name} }
        department.reload.name.should eq(name)
      end
    end

    describe 'admin be able destroy department' do
      it 'destroys the requested department' do
        expect {
          delete :destroy, params: {id: department.id }
        }.to change(Department, :count).by(-1)
      end
    end
  end
end