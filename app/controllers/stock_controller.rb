class StockController < ApplicationController
    def get_stock_info
        stock_ticker = params[:stockTicker]
        start_date = params[:startDate].nil? ? '2023-01-01' : params[:startDate]
        end_date = params[:endDate].nil? ? '2023-01-04' : params[:endDate]

        if stock_ticker.nil? || stock_ticker.empty?
            return render json: { error: { code: 'ERR_STOCK_TICKER_REQUIRED', message: 'Stock ticker is required parameter' } }, status: 500
        end

        polygon_api = PolygonApi.new(stock_ticker)
        stock_info = polygon_api.get_stock_info(start_date, end_date)
        results_arr = stock_info['results']

        if results_arr.nil? && stock_info.code == 200
           return render json: { error: { code: 'ERR_NO_RESULTS', stock_info: stock_info, message: 'No trade data found for given ticker and time period' } }, status: 500
        end

        # assuming there are results
        max_price = nil
        min_price = nil
        avg_price = nil

        max_volume = nil
        min_volume = nil
        avg_volume = nil

        # sum of the volume weighted average price
        sum_price = nil
        sum_volume = nil

        results_arr.each_with_index do |period, index|
            # initialize variables using the first element in the array 
            if index == 0
                max_price = period['h']
                min_price = period['l']
                sum_price = period['vw']

                max_volume = min_volume = sum_volume = period['v']
                next
            end

            # Calculate the max, min, and sum of prices
            if period['h'] > max_price
                max_price = period['h']
            end

            if period['l'] < min_price
                min_price = period['l']
            end

            sum_price += period['vw']
            sum_volume += period['v']

            # Calculate the max, min, and sum of volumes
            if period['v'] > max_volume
                max_volume = period['v']
            elsif period['v'] < min_volume
                min_volume = period['v']
            end
        end

        avg_price = sum_price / stock_info['resultsCount']
        avg_volume = sum_volume / stock_info['resultsCount']

        return render json: {
            max_price: max_price, min_price: min_price, avg_price: avg_price,
            max_volume: max_volume, min_volume: min_volume, avg_volume: avg_volume.round
        }
    end
end