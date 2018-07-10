class Ticket < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  before_create :create_unique_code
  before_validation :set_status

  belongs_to :status
  belongs_to :department

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

  private

    def generate_string
      charset = Array('A'..'Z')
      Array.new(3) { charset.sample }.join
    end

    def random_hex
      charset = Array('A'..'Z') + Array(0..9)
      Array.new(2) { charset.sample }.join
    end

    def create_unique_code
      three_s = generate_string
      self.uniques_code = [three_s, random_hex, three_s, random_hex, three_s].join("-")
    end

    def set_status
      if self.status_id.nil?
        self.status_id = Status.find_by(name: 'Waiting for Staff Response').id
      end
    end
end
