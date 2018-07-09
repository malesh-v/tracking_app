require 'rails_helper'

RSpec.describe "tickets/show", type: :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :subject => "Subject",
      :content => "Content",
      :uniques_code => "Uniques Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/Uniques Code/)
  end
end
