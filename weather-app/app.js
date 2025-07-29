const express = require('express');
const axios = require('axios');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));
app.use(express.json());

// Weather data cache
let weatherCache = {};
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes cache

// Function to get weather data
async function getWeatherData(city) {
    // Use API key from environment variables, or fallback to backup key
    const apiKey = process.env.OPENWEATHER_API_KEY || process.env.WEATHER_API_KEY || '3fd6ad3fb258e8136255713991d90dab';
    const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric&lang=en`;

    try {
        console.log(`Fetching weather data for ${city} with API key: ${apiKey.substring(0, 8)}...`);
        const response = await axios.get(url, { timeout: 10000 });

        console.log('Weather API response:', response.data);

        return {
            city: response.data.name,
            temperature: Math.round(response.data.main.temp),
            condition: response.data.weather[0].main,
            description: response.data.weather[0].description,
            humidity: response.data.main.humidity,
            windSpeed: Math.round(response.data.wind.speed * 3.6), // Convert to km/h
            pressure: response.data.main.pressure,
            icon: response.data.weather[0].icon
        };
    } catch (error) {
        console.error('Error fetching weather data:', error.message);
        if (error.response) {
            console.error('API Error response:', error.response.data);
            console.error('API Error status:', error.response.status);
        }
        return null;
    }
}

// Main page route
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CST8918 Weather App</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    color: white;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 40px;
                }
                
                .header h1 {
                    font-size: 3em;
                    margin-bottom: 10px;
                    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                
                .header p {
                    font-size: 1.2em;
                    opacity: 0.9;
                }
                
                .search-section {
                    text-align: center;
                    margin-bottom: 40px;
                }
                
                .search-box {
                    display: flex;
                    justify-content: center;
                    gap: 10px;
                    margin-bottom: 20px;
                }
                
                input[type="text"] {
                    padding: 15px 20px;
                    font-size: 16px;
                    border: none;
                    border-radius: 25px;
                    width: 300px;
                    background: rgba(255,255,255,0.9);
                    color: #333;
                }
                
                button {
                    padding: 15px 30px;
                    font-size: 16px;
                    border: none;
                    border-radius: 25px;
                    background: #4CAF50;
                    color: white;
                    cursor: pointer;
                    transition: background 0.3s;
                }
                
                button:hover {
                    background: #45a049;
                }
                
                .weather-card {
                    background: rgba(255,255,255,0.1);
                    backdrop-filter: blur(10px);
                    border-radius: 20px;
                    padding: 40px;
                    margin: 20px auto;
                    max-width: 600px;
                    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                }
                
                .weather-info {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                    margin-top: 30px;
                }
                
                .info-item {
                    background: rgba(255,255,255,0.1);
                    padding: 20px;
                    border-radius: 15px;
                    text-align: center;
                    transition: transform 0.3s;
                }
                
                .info-item:hover {
                    transform: translateY(-5px);
                }
                
                .temperature {
                    font-size: 3em;
                    font-weight: bold;
                    margin-bottom: 10px;
                }
                
                .condition {
                    font-size: 1.5em;
                    margin-bottom: 20px;
                }
                
                .project-info {
                    margin-top: 40px;
                    text-align: center;
                    background: rgba(255,255,255,0.1);
                    padding: 30px;
                    border-radius: 15px;
                }
                
                .tech-stack {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                    gap: 15px;
                    margin-top: 20px;
                }
                
                .tech-item {
                    background: rgba(255,255,255,0.1);
                    padding: 15px;
                    border-radius: 10px;
                    text-align: center;
                }
                
                .loading {
                    text-align: center;
                    font-size: 1.2em;
                    margin: 40px 0;
                }
                
                .error {
                    background: rgba(255,0,0,0.2);
                    padding: 20px;
                    border-radius: 10px;
                    text-align: center;
                    margin: 20px 0;
                }
                
                @media (max-width: 768px) {
                    .container {
                        padding: 10px;
                    }
                    
                    .header h1 {
                        font-size: 2em;
                    }
                    
                    input[type="text"] {
                        width: 250px;
                    }
                    
                    .weather-info {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🌤️ CST8918 Weather App</h1>
                    <p>Real-time weather information powered by OpenWeatherMap API</p>
                </div>
                
                <div class="search-section">
                    <div class="search-box">
                        <input type="text" id="cityInput" placeholder="Enter city name..." value="Toronto">
                        <button onclick="getWeather()">Get Weather</button>
                    </div>
                </div>
                
                <div id="weatherResult"></div>
                
                <div class="project-info">
                    <h2>🚀 CST8918 Final Project</h2>
                    <p>Infrastructure as Code with Azure Kubernetes Service</p>
                    <div class="tech-stack">
                        <div class="tech-item">✅ Terraform</div>
                        <div class="tech-item">✅ AKS</div>
                        <div class="tech-item">✅ ACR</div>
                        <div class="tech-item">✅ CI/CD</div>
                        <div class="tech-item">✅ Monitoring</div>
                        <div class="tech-item">✅ Security</div>
                    </div>
                </div>
            </div>
            
            <script>
                async function getWeather() {
                    const city = document.getElementById('cityInput').value;
                    const resultDiv = document.getElementById('weatherResult');
                    
                    if (!city) {
                        resultDiv.innerHTML = '<div class="error">Please enter a city name</div>';
                        return;
                    }
                    
                    resultDiv.innerHTML = '<div class="loading">Loading weather data...</div>';
                    
                    try {
                        const response = await fetch('/api/weather?city=' + encodeURIComponent(city));
                        const data = await response.json();
                        
                        if (data.error) {
                            resultDiv.innerHTML = '<div class="error">Error: ' + data.error + '</div>';
                        } else {
                            resultDiv.innerHTML = \`
                                <div class="weather-card">
                                    <h2>Weather in \${data.city}</h2>
                                    <div class="temperature">\${data.temperature}°C</div>
                                    <div class="condition">\${data.condition}</div>
                                    <div class="weather-info">
                                        <div class="info-item">
                                            <h3>💧 Humidity</h3>
                                            <p>\${data.humidity}%</p>
                                        </div>
                                        <div class="info-item">
                                            <h3>💨 Wind Speed</h3>
                                            <p>\${data.windSpeed} km/h</p>
                                        </div>
                                        <div class="info-item">
                                            <h3>🌡️ Pressure</h3>
                                            <p>\${data.pressure} hPa</p>
                                        </div>
                                        <div class="info-item">
                                            <h3>📝 Description</h3>
                                            <p>\${data.description}</p>
                                        </div>
                                    </div>
                                </div>
                            \`;
                        }
                    } catch (error) {
                        resultDiv.innerHTML = '<div class="error">Error fetching weather data</div>';
                    }
                }
                
                // Get default city weather on page load
                window.onload = function() {
                    getWeather();
                };
                
                // Search on Enter key
                document.getElementById('cityInput').addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        getWeather();
                    }
                });
            </script>
        </body>
        </html>
    `);
});

// API route - Get weather data
app.get('/api/weather', async (req, res) => {
    const city = req.query.city;

    if (!city) {
        return res.json({ error: 'City parameter is required' });
    }

    // Check cache
    const cacheKey = city.toLowerCase();
    const now = Date.now();

    if (weatherCache[cacheKey] && (now - weatherCache[cacheKey].timestamp) < CACHE_DURATION) {
        return res.json(weatherCache[cacheKey].data);
    }

    const weatherData = await getWeatherData(city);

    if (!weatherData) {
        return res.json({ error: 'Unable to fetch weather data for this city' });
    }

    // Update cache
    weatherCache[cacheKey] = {
        data: weatherData,
        timestamp: now
    };

    res.json(weatherData);
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        service: 'CST8918 Weather App'
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`CST8918 Weather App listening at http://0.0.0.0:${port}`);
    console.log('Environment:', process.env.NODE_ENV || 'development');
    console.log('API Key configured:', !!process.env.WEATHER_API_KEY);
}); 