class Ticket < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  before_create :create_unique_code, :set_status

  belongs_to :status, optional: true
  belongs_to :department
  belongs_to :staff_member, optional: true

  def self.search(term)
    collection = where('subject LIKE ? or content LIKE ?', "%#{term}%", "%#{term}%")

    if find_by(uniques_code: term).kind_of?(Ticket)
      find_by(uniques_code: term)
    elsif collection.count.positive?
      collection
    else
      nil
    end
  end

  def self.search_on_params(params)
    if !params['owner'].nil?
      Ticket.where('staff_member_id = ?', '') if params['owner'] == 'unassigned'
    elsif params['status'] == 'open'
      closed_id = Status.where('name LIKE ?', 'completed').first.id
      Ticket.where.not('status_id = ?', closed_id)
    end



  end

  private

    def random_hex
      charset = Array('A'..'Z') + Array(0..9)
      Array.new(2) { charset.sample }.join
    end

    def create_unique_code
      three_s = Array.new(3) { Array('A'..'Z').sample }.join
      self.uniques_code = [three_s, random_hex, three_s, random_hex, three_s].join("-")
    end

    def set_status
      self.status_id ||=  Status.find_by(name: 'Waiting for Staff Response').id
    end
end
