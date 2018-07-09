require 'rails_helper'

RSpec.describe "tickets/index", type: :view do
  before(:each) do
    assign(:tickets, [
      Ticket.create!(
        :subject => "Subject",
        :content => "Content",
        :uniques_code => "Uniques Code"
      ),
      Ticket.create!(
        :subject => "Subject",
        :content => "Content",
        :uniques_code => "Uniques Code"
      )
    ])
  end

  it "renders a list of tickets" do
    render
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => "Uniques Code".to_s, :count => 2
  end
end
