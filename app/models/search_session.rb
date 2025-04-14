class SearchSession < ApplicationRecord
  has_many :search_queries, dependent: :destroy
  validates :ip_address, presence: true
end
