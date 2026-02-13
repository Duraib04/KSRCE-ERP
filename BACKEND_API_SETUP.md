# Backend API Integration Guide

## Database Configuration

This API is configured to work with MySQL database.

**MySQL Connection Details:**
- **Host:** localhost
- **Port:** 3306
- **User:** root
- **Password:** 2021
- **Database:** ksrce_erp (create this database)

## API Configuration

### Setting Backend URL

The API base URL is configured in `lib/src/core/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';
```

Update this to match your backend server address:
- **Local Development:** `http://localhost:3000`
- **Remote Server:** `https://api.yourdomain.com`
- **Docker:** `http://backend:3000`

## API Endpoints

All endpoints require authentication token (except login/register):

### Authentication Endpoints
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/verify` - Verify token validity

### Student Endpoints
- `GET /api/v1/students` - Get all students (paginated)
- `GET /api/v1/students/:id` - Get student by ID
- `GET /api/v1/students/search` - Search students
- `GET /api/v1/students/dashboard` - Get student dashboard data
- `GET /api/v1/students/attendance` - Get attendance data
- `GET /api/v1/students/grades` - Get grades
- `POST /api/v1/students` - Create student
- `PUT /api/v1/students/:id` - Update student
- `DELETE /api/v1/students/:id` - Delete student

### Faculty Endpoints
- `GET /api/v1/faculty` - Get all faculty (paginated)
- `GET /api/v1/faculty/:id` - Get faculty by ID
- `GET /api/v1/faculty/search` - Search faculty
- `GET /api/v1/faculty/dashboard` - Get faculty dashboard data
- `GET /api/v1/faculty/schedule` - Get teaching schedule
- `GET /api/v1/faculty/metrics` - Get performance metrics
- `POST /api/v1/faculty` - Create faculty
- `PUT /api/v1/faculty/:id` - Update faculty
- `DELETE /api/v1/faculty/:id` - Delete faculty

### Admin Endpoints
- `GET /api/v1/admin/dashboard` - Get admin dashboard
- `GET /api/v1/admin/users` - Get all users
- `GET /api/v1/admin/settings` - Get system settings
- `POST /api/v1/admin/settings` - Update system settings

## Backend Implementation Example (Node.js + Express)

### Sample Backend Structure

```
backend/
├── routes/
│   ├── auth.js
│   ├── students.js
│   ├── faculty.js
│   └── admin.js
├── controllers/
├── models/
├── middleware/
│   └── auth.js
├── config/
│   └── database.js
└── server.js
```

### Database Connection

```javascript
// config/database.js
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '2021',
  database: 'ksrce_erp',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
```

### Login Endpoint Example

```javascript
// routes/auth.js
router.post('/login', async (req, res) => {
  const { userId, password } = req.body;
  
  try {
    // Validate credentials against MySQL
    const connection = await pool.getConnection();
    const query = 'SELECT * FROM users WHERE user_id = ?';
    const [results] = await connection.execute(query, [userId]);
    
    if (results.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: results[0].id, role: results[0].role },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.json({
      success: true,
      data: {
        accessToken: token,
        userId: results[0].id,
        userRole: results[0].role,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000)
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});
```

## HTTP Client Usage

The `HttpClientService` automatically:
- Adds authentication headers to requests
- Handles token refresh on 401 responses
- Parses JSON responses
- Throws typed exceptions for error handling

## Authentication Flow

1. **Login** → Get access token
2. **Store** → Save token in SharedPreferences
3. **Request** → Include token in Authorization header
4. **Refresh** → Auto-refresh on token expiry (401 response)
5. **Logout** → Clear stored token

## Services Overview

### HttpClientService
- Handles all HTTP requests (GET, POST, PUT, DELETE)
- Manages authentication headers
- Handles errors and timeouts
- Automatic JSON encoding/decoding

### AuthenticationService
- Manages user authentication
- Token storage and retrieval
- Token refresh logic
- Session persistence

## Error Handling

Custom exceptions for different scenarios:
- `AuthenticationException` - Login failed, invalid credentials
- `AuthorizationException` - Insufficient permissions
- `ValidationException` - Request validation failed
- `ServerException` - Server error (5xx)
- `NetworkException` - Network connectivity issues
- `TimeoutException` - Request timeout
- `ApiException` - Generic API errors

## TODO: Setup Instructions

1. **Create MySQL Database**
   ```sql
   CREATE DATABASE ksrce_erp;
   USE ksrce_erp;
   
   CREATE TABLE users (
     id INT PRIMARY KEY AUTO_INCREMENT,
     user_id VARCHAR(50) UNIQUE NOT NULL,
     password VARCHAR(255) NOT NULL,
     name VARCHAR(100) NOT NULL,
     email VARCHAR(100) UNIQUE NOT NULL,
     role ENUM('student', 'faculty', 'admin') NOT NULL,
     status ENUM('active', 'inactive') DEFAULT 'active',
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **Set up Backend Server** (Node.js/Express example provided above)

3. **Update API Base URL** in `api_config.dart` to point to your backend

4. **Enable HTTP Client** by uncommenting `http` package in pubspec.yaml

5. **Update Auth Service** - Replace mock login in LoginForm with actual API calls
