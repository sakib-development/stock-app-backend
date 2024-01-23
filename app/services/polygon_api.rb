require 'httparty'

class PolygonApi
    include HTTParty
    base_uri 'https://api.polygon.io/v2/aggs/ticker'

    def initialize(stock_ticker)
        @options = { query: { apiKey: 'taIMgMrmnZ8SUZmdpq9_7ANRDxw3IPIx' } }
        @stock_ticker = stock_ticker
    end

    def get_stock_info(start_date, end_date)
        puts "grabbing stock info: #{@stock_ticker}"
        self.class.get( "/#{@stock_ticker}/range/1/day/#{start_date}/#{end_date}", @options)
    end
end