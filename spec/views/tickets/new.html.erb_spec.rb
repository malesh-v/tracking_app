require 'rails_helper'

RSpec.describe "tickets/new", type: :view do
  before(:each) do
    assign(:ticket, Ticket.new(
      :subject => "MyString",
      :content => "MyString",
      :uniques_code => "MyString"
    ))
  end

  it "renders new ticket form" do
    render

    assert_select "form[action=?][method=?]", tickets_path, "post" do

      assert_select "input[name=?]", "ticket[subject]"

      assert_select "input[name=?]", "ticket[content]"

      assert_select "input[name=?]", "ticket[uniques_code]"
    end
  end
end
