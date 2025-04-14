class SearchQuery < ApplicationRecord
  belongs_to :search_session
  validates :final_query, presence: true
end
