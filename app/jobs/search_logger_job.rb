class SearchLoggerJob < ApplicationJob
  queue_as :default

  def perform(ip, current_input)
    cached = Rails.cache.read("user:#{ip}:last_query")
    puts "CACHED #{cached}"
    Rails.logger.info "[SearchLoggerJob] Cached: #{cached}, Input: #{current_input}"
    return unless cached == current_input
  
    session = SearchSession.find_or_create_by(ip_address: ip)

    last_query = session.search_queries.last&.final_query
    puts "LAST_QUERY #{last_query}"
    return if last_query == current_input
  
    query = session.search_queries.create!(final_query: current_input)
    Rails.logger.info "[SearchLoggerJob] Logged query: #{query.final_query}"
  end
  
end
