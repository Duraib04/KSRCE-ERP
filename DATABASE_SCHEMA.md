# MySQL Database Schema for KSRCE ERP

## Database Connection Details
- **Host:** localhost
- **Port:** 3306
- **User:** root
- **Password:** 2021
- **Database:** ksrce_erp

## Database Setup

### 1. Create Database
```sql
CREATE DATABASE IF NOT EXISTS ksrce_erp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ksrce_erp;
```

### 2. Users Table
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  role ENUM('student', 'faculty', 'admin') NOT NULL,
  status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_role (role),
  INDEX idx_status (status)
);
```

### 3. Students Table
```sql
CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE NOT NULL,
  enrollment_number VARCHAR(50) UNIQUE NOT NULL,
  department VARCHAR(100) NOT NULL,
  semester INT NOT NULL,
  gpa DECIMAL(3, 2) DEFAULT 0.00,
  attendance_percentage INT DEFAULT 0,
  status ENUM('active', 'inactive', 'graduated') DEFAULT 'active',
  enrollment_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_enrollment_number (enrollment_number),
  INDEX idx_department (department),
  INDEX idx_semester (semester),
  INDEX idx_status (status)
);
```

### 4. Faculty Table
```sql
CREATE TABLE faculty (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE NOT NULL,
  faculty_id VARCHAR(50) UNIQUE NOT NULL,
  department VARCHAR(100) NOT NULL,
  designation VARCHAR(100) NOT NULL,
  years_of_experience INT DEFAULT 0,
  rating DECIMAL(2, 1) DEFAULT 0.0,
  status ENUM('active', 'inactive', 'retired') DEFAULT 'active',
  join_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_faculty_id (faculty_id),
  INDEX idx_department (department),
  INDEX idx_designation (designation),
  INDEX idx_status (status)
);
```

### 5. Courses Table
```sql
CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_code VARCHAR(20) UNIQUE NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  department VARCHAR(100) NOT NULL,
  semester INT NOT NULL,
  credits INT NOT NULL,
  faculty_id INT,
  description TEXT,
  capacity INT,
  status ENUM('active', 'inactive', 'archived') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE SET NULL,
  INDEX idx_course_code (course_code),
  INDEX idx_department (department),
  INDEX idx_semester (semester),
  INDEX idx_status (status)
);
```

### 6. Student Courses Enrollment Table
```sql
CREATE TABLE student_courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  grade_awarded VARCHAR(2),
  marks_obtained DECIMAL(5, 2),
  attendance INT DEFAULT 0,
  status ENUM('enrolled', 'completed', 'dropped') DEFAULT 'enrolled',
  enrolled_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (student_id, course_id),
  INDEX idx_student_id (student_id),
  INDEX idx_course_id (course_id),
  INDEX idx_status (status)
);
```

### 7. Attendance Table
```sql
CREATE TABLE attendance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  attendance_date DATE NOT NULL,
  status ENUM('present', 'absent', 'late') NOT NULL,
  remarks VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_attendance (student_id, course_id, attendance_date),
  INDEX idx_student_id (student_id),
  INDEX idx_course_id (course_id),
  INDEX idx_attendance_date (attendance_date)
);
```

### 8. Announcements Table
```sql
CREATE TABLE announcements (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  posted_by INT NOT NULL,
  target_role ENUM('student', 'faculty', 'admin', 'all') DEFAULT 'all',
  priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
  attachment_url VARCHAR(500),
  status ENUM('active', 'archived') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_target_role (target_role),
  INDEX idx_priority (priority),
  INDEX idx_created_at (created_at),
  INDEX idx_status (status)
);
```

### 9. Grades Table
```sql
CREATE TABLE grades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  assignment_marks INT,
  midterm_marks INT,
  endterm_marks INT,
  total_marks DECIMAL(5, 2),
  grade VARCHAR(2),
  graded_by INT NOT NULL,
  graded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (graded_by) REFERENCES faculty(id) ON DELETE SET NULL,
  UNIQUE KEY unique_grade (student_id, course_id),
  INDEX idx_student_id (student_id),
  INDEX idx_course_id (course_id)
);
```

### 10. Timetable Schedule Table
```sql
CREATE TABLE timetable (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  faculty_id INT NOT NULL,
  day_of_week VARCHAR(10) NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  room_number VARCHAR(20),
  block VARCHAR(10),
  semester INT NOT NULL,
  academic_year VARCHAR(10) NOT NULL,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE CASCADE,
  INDEX idx_day_of_week (day_of_week),
  INDEX idx_faculty_id (faculty_id),
  INDEX idx_academic_year (academic_year)
);
```

### 11. Sessions/Login History Table
```sql
CREATE TABLE user_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token_hash VARCHAR(255) NOT NULL,
  login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  logout_time TIMESTAMP NULL,
  ip_address VARCHAR(45),
  user_agent VARCHAR(500),
  device_type ENUM('web', 'mobile', 'tablet') DEFAULT 'web',
  status ENUM('active', 'expired', 'revoked') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_login_time (login_time),
  INDEX idx_status (status)
);
```

### 12. Audit Log Table
```sql
CREATE TABLE audit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  entity_id INT,
  old_values JSON,
  new_values JSON,
  ip_address VARCHAR(45),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_timestamp (timestamp),
  INDEX idx_entity_type (entity_type),
  INDEX idx_action (action)
);
```

## Sample Data

### Insert Admin User
```sql
INSERT INTO users (user_id, password_hash, name, email, phone, role, status)
VALUES ('ADM001', SHA2('admin123', 256), 'System Admin', 'admin@ksrce.edu', '+91-9999999999', 'admin', 'active');
```

### Insert Faculty User
```sql
INSERT INTO users (user_id, password_hash, name, email, phone, role, status)
VALUES ('FAC001', SHA2('demo123', 256), 'Dr. Rajesh Kumar', 'rajesh@ksrce.edu', '+91-9876543210', 'faculty', 'active');

INSERT INTO faculty (user_id, faculty_id, department, designation, years_of_experience, join_date)
VALUES (2, 'FAC001', 'Computer Science', 'Professor', 12, '2012-06-01');
```

### Insert Student User
```sql
INSERT INTO users (user_id, password_hash, name, email, phone, role, status)
VALUES ('S20210001', SHA2('demo123', 256), 'Rahul Kumar', 'rahul@ksrce.edu', '+91-9876543211', 'student', 'active');

INSERT INTO students (user_id, enrollment_number, department, semester, gpa, attendance_percentage, enrollment_date)
VALUES (3, 'S20210001', 'Computer Science', 3, 3.85, 92, '2021-07-15');
```

## Notes

1. All passwords should be hashed using SHA256 before storing
2. Indexes are created for frequently queried columns to improve performance
3. Foreign keys maintain referential integrity
4. Timestamps track record creation and updates
5. Status columns allow soft deletes and record tracking
6. JSON columns in audit_logs allow flexible historical tracking

## Backup Script

```bash
# Backup database
mysqldump -u root -p2021 ksrce_erp > ksrce_erp_backup.sql

# Restore database
mysql -u root -p2021 ksrce_erp < ksrce_erp_backup.sql
```
