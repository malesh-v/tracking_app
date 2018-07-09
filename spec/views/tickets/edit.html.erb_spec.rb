require 'rails_helper'

RSpec.describe "tickets/edit", type: :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :subject => "MyString",
      :content => "MyString",
      :uniques_code => "MyString"
    ))
  end

  it "renders the edit ticket form" do
    render

    assert_select "form[action=?][method=?]", ticket_path(@ticket), "post" do

      assert_select "input[name=?]", "ticket[subject]"

      assert_select "input[name=?]", "ticket[content]"

      assert_select "input[name=?]", "ticket[uniques_code]"
    end
  end
end
