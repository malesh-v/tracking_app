class Ticket < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  before_create :create_unique_code, :set_status

  belongs_to :staff_member, optional: true
  belongs_to :status, optional: true
  belongs_to :client, autosave: true, validate: true
  belongs_to :department
  has_many :activity_logs, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  class << self

    def search(term)
      collection = where('subject LIKE ? or content LIKE ?', "%#{term}%", "%#{term}%")

      if find_by(uniques_code: term).kind_of?(Ticket)
        find_by(uniques_code: term)
      elsif collection.count.positive?
        collection
      else
        nil
      end
    end

    def search_on_param(param)
      send("#{param}_tickets")
    end

    def all_open_tickets
      Ticket.all - completed_tickets
    end

    def unassigned_open_tickets
      Ticket.where('staff_member_id IS NULL') - completed_tickets
    end

    def completed_tickets
      Status.where('name LIKE ?', 'completed').first.tickets
    end

    def on_hold_tickets
      Status.where('name LIKE ?', 'on hold').first.tickets
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
