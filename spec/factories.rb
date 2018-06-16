FactoryGirl.define do
  factory :staffmember do # subsequent definition is for a StaffMember model
    login    'example123'
    password 'foobar'
    password_confirmation 'foobar'
  end
end