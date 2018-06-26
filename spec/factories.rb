FactoryGirl.define do
  factory :staff_member do # subsequent definition is for a StaffMember model
    login                 'example123'
    password              'foobar'
    password_confirmation 'foobar'
    factory :admin do
      login 'admin'
      admin true
    end
  end
end