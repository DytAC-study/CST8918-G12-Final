# CST8918-G12-Final: Weather Application

## Project Overview

This is a weather application based on the Azure cloud platform, using Terraform for Infrastructure as Code (IaC) management. The project adopts a microservices architecture, including a frontend weather application and backend infrastructure modules.

## Project Architecture

```
CST8918-G12-Final/
├── modules/
│   ├── backend/          # Azure Backend Infrastructure
│   └── weather-app/      # Weather App Deployment Module
├── weather-app/          # Node.js Weather Application
│   ├── src/              # Application Source Code
│   ├── app.js           # Main Application File
│   ├── package.json     # Dependency Management
│   └── Dockerfile       # Containerization Configuration
└── README.md            # Project Documentation
```

## Technology Stack

- **Frontend**: Node.js, Express.js
- **Infrastructure**: Terraform, Azure
- **Containerization**: Docker
- **API**: OpenWeatherMap API
- **Deployment**: Azure Container Instances

## Features

- 🌤️ Real-time weather information query
- 📍 Global city search support
- 🎨 Modern responsive UI design
- ⚡ High-performance caching mechanism
- 🔧 Automated deployment process

## Quick Start

### Prerequisites

- Azure CLI
- Terraform
- Docker
- Node.js (for local development)

### Local Development

1. Clone the repository
```bash
git clone https://github.com/DytAC-study/CST8918-G12-Final.git
cd CST8918-G12-Final
```

2. Install dependencies
```bash
cd weather-app
npm install
```

3. Set environment variables
```bash
export OPENWEATHER_API_KEY="your_api_key_here"
```

4. Start the application
```bash
npm start
```

The application will run at `http://localhost:3000`

### Cloud Deployment

1. Initialize Terraform
```bash
cd modules/backend
terraform init
```

2. Configure Azure authentication
```bash
az login
```

3. Deploy infrastructure
```bash
terraform plan
terraform apply
```

4. Deploy the application
```bash
cd ../weather-app
terraform init
terraform plan
terraform apply
```

## Project Structure Details

### Backend Module (`modules/backend/`)
- Azure resource group management
- Storage account configuration
- Network infrastructure

### Weather App Module (`modules/weather-app/`)
- Azure Container Instances
- Application service configuration
- Network and security settings

### Weather Application (`weather-app/`)
- Express.js web server
- OpenWeatherMap API integration
- Responsive frontend interface

## API Documentation

### Weather Query API
- **Endpoint**: `/api/weather`
- **Method**: GET
- **Parameters**: `city` (city name)
- **Returns**: JSON format weather data

Example request:
```bash
curl "http://localhost:3000/api/weather?city=Toronto"
```

## Environment Variables

| Variable Name | Description | Required |
|---------------|-------------|----------|
| `OPENWEATHER_API_KEY` | OpenWeatherMap API key | Yes |
| `PORT` | Application port | No (default: 3000) |

## Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Create a Pull Request

## Team Members

- **Team Member 1**: [GitHub Username] - Responsible for backend infrastructure
- **Team Member 2**: [GitHub Username] - Responsible for application deployment
- **Team Member 3**: [GitHub Username] - Responsible for frontend development

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- OpenWeatherMap API for weather data
- Azure cloud platform support
- Terraform for Infrastructure as Code

---

**CST8918 Final Project - Group 12**  
*Building a weather application with modern cloud-native technologies*
