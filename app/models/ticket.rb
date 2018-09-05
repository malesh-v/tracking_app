class Ticket < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  before_create :create_unique_code, :set_status

  belongs_to :staff_member, optional: true
  belongs_to :status, optional: true
  belongs_to :client, autosave: true, validate: true
  belongs_to :department
  has_many :activity_logs, dependent: :destroy
  has_many :comments

  default_scope -> { order(id: :desc) }

  class << self

    def search_by_code(term)
      find_by(uniques_code: term)
    end

    def search(term)
      where('subject LIKE ? or content LIKE ?', "%#{term}%", "%#{term}%")
    end

    def search_on_param(param)
      send("#{param}_tickets")
    end

    def all_my_tickets(staff)
      staff.tickets
    end

    def all_open_tickets
      joins(:status).where.not(statuses: { name: 'Completed' } )
    end

    def unassigned_open_tickets
      where(tickets: { staff_member_id: '' } ).joins(:status)
      .where.not(statuses: { name: 'Completed' } )
    end

    def completed_tickets
      joins(:status).where(statuses: { name: 'Completed' } )
    end

    def on_hold_tickets
      joins(:status).where(statuses: { name: 'On Hold' } )
    end

  end

  private

    def random_hex
      charset = Array('A'..'Z') + Array(0..9)
      Array.new(2) { charset.sample }.join
    end

    def create_unique_code
      three_s = Array.new(3) { Array('A'..'Z').sample }.join
      self.uniques_code = [three_s, random_hex, three_s, random_hex, three_s]
                          .join("-")
    end

    def set_status
      self.status_id ||= Status.find_by(name: 'Waiting for Staff Response').id
    end
end
