# About project

This is a weather statistics service using  https://developer.accuweather.com/apis as a data source.

# List of endpoints:

- `/weather/current` - Current temperature
- `/weather/historical` - Hourly temperature for the last 24 hours ([API Documentation](https://developer.accuweather.com/accuweather-current-conditions-api/apis/get/currentconditions/v1/%7BlocationKey%7D/historical/24))
- `/weather/historical/max` - Maximum temperature for 24 hours
- `/weather/historical/min` - Minimum temperature for 24 hours
- `/weather/historical/avg` - Average temperature over 24 hours
- `/weather/by_time` - Find the temperature closest to the transmitted timestamp (e.g., 1621823790 should return the temperature for 2021-05-24 08:00. If the time is not available, return 404)
- `/health` - Backend status (Always responds with OK)


# Usage:

-  Clone repo:
git clone git@github.com:Shkuryn/weather_api_app.git
-  Go to the app folder:
cd ./weather_api_app
- Create .env file
sudo nano .env
Add Accuweather Api Key
ACCUWEATHER_API_KEY=YOUR_VALUE
Add LOCATION_KEY=YOUR_VALUE (find your city location code  or by default will be used LOCATION_KEY=28580)
- Save .env file
Ctrl+O Ctrl+X
- Run docker-dompose build
- sudo docker-compose build
- Create DB
sudo docker-compose run web bundle exec rails db:create db:migrate
- Build and spin up the server
- sudo docker-compose up --build
- Open the second terminal tab
- Run rails console
- sudo docker-compose exec web rails console
- Call Accuweather Service
AccuweatherService.call
