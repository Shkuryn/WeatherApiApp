# About project

This is a weather statistics service using  https://developer.accuweather.com/apis as a data source.

# Usage:

-  Clone repo:
   git clone git@github.com:Shkuryn/weather_api_app.git
-  Go to the app folder:
   cd ./weather_api_app
-  Create .env file
   echo "ACCUWEATHER_API_KEY=VALUE" > .env
   echo "LOCATION_KEY=VALUE" > .env
   (find your city location code or by default will be used LOCATION_KEY=28580)
-  Run docker
   for ex. docker build -t weather_api_app:1.0 
   docker run {your_image}
-  Create DB
   Enter to the running container docker exec -it container_name /bin/bash 
   and run bundle exec rails db:create db:migrate
-  Run bundle exec rails c
   and call Accuweather Service by
   AccuweatherService.call

# List of endpoints:

- `/weather/current` - Current temperature
- `/weather/historical` - Hourly temperature for the last 24 hours ([API Documentation](https://developer.accuweather.com/accuweather-current-conditions-api/apis/get/currentconditions/v1/%7BlocationKey%7D/historical/24))
- `/weather/historical/max` - Maximum temperature for 24 hours
- `/weather/historical/min` - Minimum temperature for 24 hours
- `/weather/historical/avg` - Average temperature over 24 hours
- `/weather/by_time` - Find the temperature closest to the transmitted timestamp (e.g., 1621823790 should return the temperature for 2021-05-24 08:00. If the time is not available, return 404)
- `/health` - Backend status (Always responds with OK)
