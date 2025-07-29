const axios = require('axios');
const config = require('../config');

class WeatherService {
  constructor() {
    this.baseUrl = config.weatherApi.baseUrl;
    this.apiKey = config.weatherApi.apiKey;
    this.units = config.weatherApi.units;
    this.lang = config.weatherApi.lang;
  }

  // Get current weather
  async getCurrentWeather(city) {
    try {
      const response = await axios.get(`${this.baseUrl}/weather`, {
        params: {
          q: city,
          appid: this.apiKey,
          units: this.units,
          lang: this.lang
        },
        timeout: 10000
      });

      return this.formatCurrentWeather(response.data);
    } catch (error) {
      console.error('Error fetching current weather:', error.message);
      throw new Error(`Failed to fetch weather data for ${city}`);
    }
  }

  // Get weather forecast
  async getWeatherForecast(city) {
    try {
      const response = await axios.get(`${this.baseUrl}/forecast`, {
        params: {
          q: city,
          appid: this.apiKey,
          units: this.units,
          lang: this.lang
        },
        timeout: 10000
      });

      return this.formatForecast(response.data);
    } catch (error) {
      console.error('Error fetching weather forecast:', error.message);
      throw new Error(`Failed to fetch forecast data for ${city}`);
    }
  }

  // Format current weather data
  formatCurrentWeather(data) {
    return {
      city: data.name,
      country: data.sys.country,
      temperature: Math.round(data.main.temp),
      feels_like: Math.round(data.main.feels_like),
      humidity: data.main.humidity,
      pressure: data.main.pressure,
      description: data.weather[0].description,
      icon: data.weather[0].icon,
      wind_speed: Math.round(data.wind.speed * 3.6), // Convert to km/h
      wind_direction: data.wind.deg,
      visibility: data.visibility / 1000, // Convert to km
      sunrise: new Date(data.sys.sunrise * 1000).toLocaleTimeString(),
      sunset: new Date(data.sys.sunset * 1000).toLocaleTimeString(),
      timestamp: new Date().toISOString()
    };
  }

  // Format weather forecast data
  formatForecast(data) {
    const dailyForecasts = {};

    data.list.forEach(item => {
      const date = new Date(item.dt * 1000);
      const day = date.toDateString();

      if (!dailyForecasts[day]) {
        dailyForecasts[day] = {
          date: day,
          temp_min: item.main.temp_min,
          temp_max: item.main.temp_max,
          description: item.weather[0].description,
          icon: item.weather[0].icon,
          humidity: item.main.humidity,
          wind_speed: Math.round(item.wind.speed * 3.6),
          forecasts: []
        };
      }

      dailyForecasts[day].forecasts.push({
        time: date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        temperature: Math.round(item.main.temp),
        description: item.weather[0].description,
        icon: item.weather[0].icon
      });
    });

    return {
      city: data.city.name,
      country: data.city.country,
      forecasts: Object.values(dailyForecasts)
    };
  }

  // Get air quality data (if API supports it)
  async getAirQuality(lat, lon) {
    try {
      const response = await axios.get(`${this.baseUrl}/air_pollution`, {
        params: {
          lat: lat,
          lon: lon,
          appid: this.apiKey
        },
        timeout: 10000
      });

      return this.formatAirQuality(response.data);
    } catch (error) {
      console.error('Error fetching air quality:', error.message);
      return null; // Return null if API doesn't support it
    }
  }

  // Format air quality data
  formatAirQuality(data) {
    const aqi = data.list[0].main.aqi;
    const components = data.list[0].components;

    const aqiLevels = {
      1: 'Good',
      2: 'Fair',
      3: 'Moderate',
      4: 'Poor',
      5: 'Very Poor'
    };

    return {
      aqi: aqi,
      level: aqiLevels[aqi] || 'Unknown',
      components: {
        co: components.co,
        no2: components.no2,
        o3: components.o3,
        so2: components.so2,
        pm2_5: components.pm2_5,
        pm10: components.pm10
      },
      timestamp: new Date().toISOString()
    };
  }

  // Validate API key
  async validateApiKey() {
    try {
      await axios.get(`${this.baseUrl}/weather`, {
        params: {
          q: 'London',
          appid: this.apiKey,
          units: this.units
        },
        timeout: 5000
      });
      return true;
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return false; // Invalid API key
      }
      return true; // Other errors, possibly network issues
    }
  }
}

module.exports = WeatherService; 