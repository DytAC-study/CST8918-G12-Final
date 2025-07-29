const express = require('express');
const WeatherService = require('../services/weatherService');
const cache = require('../services/cacheService');
const rateLimit = require('express-rate-limit');
const config = require('../config');

const router = express.Router();
const weatherService = new WeatherService();

// Rate limiting
const limiter = rateLimit(config.security.rateLimit);
router.use(limiter);

// Get current weather
router.get('/current/:city', async (req, res) => {
  try {
    const { city } = req.params;
    const cacheKey = `weather:current:${city.toLowerCase()}`;

    // Try to get data from cache
    let weatherData = await cache.get(cacheKey);

    if (!weatherData) {
      // Validate API key
      const isValidApiKey = await weatherService.validateApiKey();
      if (!isValidApiKey) {
        return res.status(500).json({
          error: 'Weather API key is invalid or not configured',
          message: 'Please configure a valid OpenWeatherMap API key'
        });
      }

      // Get data from API
      weatherData = await weatherService.getCurrentWeather(city);

      // Cache data (5 minutes)
      await cache.set(cacheKey, weatherData, config.app.cacheTimeout);
    }

    res.json({
      success: true,
      data: weatherData,
      cached: !!await cache.get(cacheKey),
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in current weather route:', error);
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Failed to fetch current weather data'
    });
  }
});

// Get weather forecast
router.get('/forecast/:city', async (req, res) => {
  try {
    const { city } = req.params;
    const cacheKey = `weather:forecast:${city.toLowerCase()}`;

    // Try to get data from cache
    let forecastData = await cache.get(cacheKey);

    if (!forecastData) {
      // Validate API key
      const isValidApiKey = await weatherService.validateApiKey();
      if (!isValidApiKey) {
        return res.status(500).json({
          error: 'Weather API key is invalid or not configured',
          message: 'Please configure a valid OpenWeatherMap API key'
        });
      }

      // Get data from API
      forecastData = await weatherService.getWeatherForecast(city);

      // Cache data (5 minutes)
      await cache.set(cacheKey, forecastData, config.app.cacheTimeout);
    }

    res.json({
      success: true,
      data: forecastData,
      cached: !!await cache.get(cacheKey),
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in forecast route:', error);
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Failed to fetch forecast data'
    });
  }
});

// Get air quality data
router.get('/air-quality/:city', async (req, res) => {
  try {
    const { city } = req.params;
    const cacheKey = `weather:airquality:${city.toLowerCase()}`;

    // Try to get data from cache
    let airQualityData = await cache.get(cacheKey);

    if (!airQualityData) {
      // Validate API key
      const isValidApiKey = await weatherService.validateApiKey();
      if (!isValidApiKey) {
        return res.status(500).json({
          error: 'Weather API key is invalid or not configured',
          message: 'Please configure a valid OpenWeatherMap API key'
        });
      }

      // First get city coordinates
      const currentWeather = await weatherService.getCurrentWeather(city);
      const coords = currentWeather.coord || { lat: 0, lon: 0 };

      // Get air quality data
      airQualityData = await weatherService.getAirQuality(coords.lat, coords.lon);

      if (airQualityData) {
        // Cache data (5 minutes)
        await cache.set(cacheKey, airQualityData, config.app.cacheTimeout);
      }
    }

    if (!airQualityData) {
      return res.status(404).json({
        success: false,
        error: 'Air quality data not available',
        message: 'Air quality data is not available for this location'
      });
    }

    res.json({
      success: true,
      data: airQualityData,
      cached: !!await cache.get(cacheKey),
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in air quality route:', error);
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Failed to fetch air quality data'
    });
  }
});

// Search cities
router.get('/search', async (req, res) => {
  try {
    const { q } = req.query;

    if (!q || q.length < 2) {
      return res.status(400).json({
        success: false,
        error: 'Invalid search query',
        message: 'Search query must be at least 2 characters long'
      });
    }

    const cacheKey = `weather:search:${q.toLowerCase()}`;
    let searchResults = await cache.get(cacheKey);

    if (!searchResults) {
      // Here you can integrate city search API
      // Currently returning mock data
      searchResults = [
        { name: 'London', country: 'GB', state: 'England' },
        { name: 'Los Angeles', country: 'US', state: 'California' },
        { name: 'Tokyo', country: 'JP', state: 'Tokyo' },
        { name: 'Paris', country: 'FR', state: 'Île-de-France' },
        { name: 'Sydney', country: 'AU', state: 'New South Wales' }
      ].filter(city =>
        city.name.toLowerCase().includes(q.toLowerCase()) ||
        city.country.toLowerCase().includes(q.toLowerCase())
      );

      await cache.set(cacheKey, searchResults, 300000); // 5 minutes cache
    }

    res.json({
      success: true,
      data: searchResults,
      query: q,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in search route:', error);
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Failed to search cities'
    });
  }
});

// API status check
router.get('/status', async (req, res) => {
  try {
    const isValidApiKey = await weatherService.validateApiKey();

    res.json({
      success: true,
      api_status: isValidApiKey ? 'connected' : 'disconnected',
      cache_status: 'connected',
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in status route:', error);
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Failed to check API status'
    });
  }
});

module.exports = router; 