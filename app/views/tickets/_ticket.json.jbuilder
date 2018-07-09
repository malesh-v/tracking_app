json.extract! ticket, :id, :subject, :content, :uniques_code, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
