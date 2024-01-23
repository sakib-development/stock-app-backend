# README

This is the backend/rails submission for the take home assignment.

First build your docker image: `docker compose build`

To run the application start your container: `docker compose up`

If you need to create the database (during the initial run of the app), then you may need to run this command: `docker compose run web rake db:create`

To access the app you can navigate to: `http://localhost:3000/`

There is only a single controller for fetching stock info: http://localhost:3000/fetch_stock_info

Takes 3 parameters, the stock ticker, start date and end date. Returns avg, max, min of price and volume using the polygon api.