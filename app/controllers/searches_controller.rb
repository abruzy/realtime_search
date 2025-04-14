class SearchesController < ApplicationController
  def index
  end

  def create
    ip = request.remote_ip
    current_input = params[:query].to_s.strip

    puts "HELLO #{current_input}"

    session = SearchSession.find_or_create_by(ip_address: ip)
    Rails.cache.write("user:#{ip}:last_query", current_input, expires_in: 30.seconds)

    # Add logging to ensure cache write
    Rails.logger.info "[SearchesController] Cache written: #{current_input}"

    # Use Sidekiq to delay final logging
    SearchLoggerJob.set(wait: 15.seconds).perform_later(ip, current_input)

    head :ok
  end


  def analytics
    queries = SearchQuery.pluck(:final_query)
    normalized = queries.map { |q| normalize_query(q) }
  
    # Initialize fuzzy matcher with all unique queries
    matcher = FuzzyMatch.new(normalized.uniq)
  
    clustered = Hash.new(0)
  
    normalized.each do |query|
      best_match = matcher.find(query)
      clustered[best_match] += 1
    end
  
    sorted = clustered.sort_by { |_query, count| -count }.to_h
  
    render json: sorted
  end
  
  private
  
  def normalize_query(query)
    query.to_s.downcase.strip.gsub(/[^a-z0-9\s]/i, '')
  end
  
end
