const config = {
  // Redis configuration
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD || null,
    db: process.env.REDIS_DB || 0,
    // Production environment configuration
    tls: process.env.NODE_ENV === 'production' ? {} : undefined,
    retryDelayOnFailover: 100,
    maxRetriesPerRequest: 3
  },

  // OpenWeatherMap API configuration
  weatherApi: {
    baseUrl: 'https://api.openweathermap.org/data/2.5',
    apiKey: process.env.OPENWEATHER_API_KEY || 'your-api-key-here',
    units: 'metric', // metric, imperial, kelvin
    lang: 'en' // Language setting
  },

  // Application configuration
  app: {
    port: process.env.PORT || 3000,
    host: process.env.HOST || '0.0.0.0',
    environment: process.env.NODE_ENV || 'development',
    cacheTimeout: 300000, // 5 minutes cache
    maxRequestsPerMinute: 60
  },

  // Logging configuration
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    format: process.env.NODE_ENV === 'production' ? 'json' : 'dev'
  },

  // Security configuration
  security: {
    cors: {
      origin: process.env.CORS_ORIGIN || '*',
      credentials: true
    },
    rateLimit: {
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100 // Limit each IP to 100 requests per 15 minutes
    }
  }
};

module.exports = config; 