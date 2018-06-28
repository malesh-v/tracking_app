require 'rails_helper'

describe StaffMember do

  before do
    @staff = StaffMember.new(login: 'login', password: 'foobar',
                             password_confirmation: 'foobar', admin: true)
  end

  subject { @staff }

  it { should respond_to(:login) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe 'when login address is already taken' do
    before do
      staff_with_same_login = @staff.dup
      staff_with_same_login.login = @staff.login
      staff_with_same_login.save
    end

    it { should_not be_valid }
  end

  describe 'when password is not present' do
    before do
      @staff = StaffMember.new(login: 'Example staff', password: ' ',
                               password_confirmation: ' ')
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @staff.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe 'return value of authenticate method' do
    before { @staff.save }
    let(:staff_member) { StaffMember.find_by(login: @staff.login) }

    describe 'with valid password' do
      it { should eq staff_member.authenticate(@staff.password) }
    end

    describe 'with invalid password' do
      let(:staff_for_invalid_password) { staff_member.authenticate('invalid') }

      it { should_not eq staff_for_invalid_password }
      specify { should_not staff_for_invalid_password } # specify is eq is
    end
  end

  describe "with a password that's too short" do
    before { @staff.password = @staff.password_confirmation = 'a' * 5 }
    it { should be_invalid }
  end

  describe 'remember token' do
    before { @staff.save }
    it { @staff.remember_token.should be_blank }
  end
end