# KSRCE ERP - Complete Workflow & Relationship Plan

## 1. Entity Hierarchy & Roles

```
INSTITUTION (KSRCE)
├── ADMIN (Super User)
│   ├── Creates/manages Departments
│   ├── Creates/manages Faculty (assigns to departments)
│   ├── Creates/manages Students (assigns to dept + year + section)
│   └── Assigns HOD role per department
│
├── HOD (Head of Department) — one per department
│   ├── Monitors all faculty in the department
│   ├── Monitors all students in the department
│   ├── Assigns Class Adviser per class (dept + year + section)
│   ├── Assigns Mentors (faculty → group of students)
│   └── Manages course-faculty mapping
│
├── FACULTY
│   ├── Teaches many courses (across sections)
│   ├── Can be Class Adviser for one class
│   ├── Can be Mentor to a group of students (mentees)
│   ├── Can be HOD (additional role flag)
│   └── Belongs to one department
│
└── STUDENT
    ├── Belongs to one department + year + section (= "class")
    ├── Enrolled in many courses
    ├── Has one Class Adviser (faculty)
    ├── Has one Mentor (faculty)
    └── Has academic records (attendance, results, assignments)
```

---

## 2. Core Entities & Data Models

### 2.1 Department

| Field          | Type   | Example                |
|----------------|--------|------------------------|
| departmentId   | String | `DEPT_CSE`             |
| departmentName | String | `Computer Science and Engineering` |
| departmentCode | String | `CSE`                  |
| hodId          | String | `FAC003` (nullable)    |
| totalFaculty   | int    | 12                     |
| totalStudents  | int    | 248                    |

### 2.2 Users (Auth)

| Field    | Type   | Example         |
|----------|--------|-----------------|
| id       | String | `STU001`        |
| password | String | hashed          |
| role     | String | `student` / `faculty` / `admin` / `hod` |
| label    | String | Display name    |

### 2.3 Student

| Field          | Type   | Example                      |
|----------------|--------|------------------------------|
| studentId      | String | `STU001`                     |
| name           | String | `Rahul Sharma`               |
| email          | String | `rahul.sharma@ksrce.edu.in`  |
| phone          | String | `9876543210`                 |
| departmentId   | String | `DEPT_CSE`                   |
| year           | int    | 3                            |
| section        | String | `A`                          |
| dateOfBirth    | String | `2003-05-15`                 |
| bloodGroup     | String | `O+`                         |
| address        | String | `123 Main Street, ...`       |
| parentName     | String | `Vikram Sharma`              |
| parentPhone    | String | `9876543200`                 |
| admissionDate  | String | `2021-07-10`                 |
| cgpa           | double | 8.5                          |
| mentorId       | String | `FAC001` (nullable)          |
| classAdviserId | String | `FAC002` (nullable)          |
| enrolledCourses| List   | `["CS201", "CS202", "MA301"]` |

### 2.4 Faculty

| Field          | Type   | Example                        |
|----------------|--------|--------------------------------|
| facultyId      | String | `FAC001`                       |
| name           | String | `Dr. Amit Verma`               |
| email          | String | `amit.verma@ksrce.edu.in`      |
| phone          | String | `9876541234`                   |
| departmentId   | String | `DEPT_CSE`                     |
| designation    | String | `Associate Professor`          |
| qualification  | String | `Ph.D Computer Science`        |
| specialization | String | `Data Structures & Algorithms` |
| dateOfJoining  | String | `2015-06-01`                   |
| isHOD          | bool   | false                          |
| isClassAdviser | bool   | true                           |
| adviserFor     | Object | `{"departmentId":"DEPT_CSE","year":3,"section":"A"}` (nullable) |
| menteeIds      | List   | `["STU001", "STU004"]`         |
| courseIds       | List   | `["CS201", "CS202"]`          |

### 2.5 Course

| Field        | Type   | Example                    |
|--------------|--------|----------------------------|
| courseId      | String | `CS201`                    |
| courseCode    | String | `CS201`                    |
| courseName   | String | `Data Structures`          |
| departmentId | String | `DEPT_CSE`                 |
| semester     | int    | 3                          |
| credits      | int    | 4                          |
| facultyId    | String | `FAC001`                   |
| facultyName  | String | `Dr. Amit Verma`           |
| sections     | List   | `["A", "B"]`               |
| schedule     | String | `Mon, Wed, Fri 10:00-11:00`|
| room         | String | `Lab-101`                  |
| totalClasses | int    | 45                         |

### 2.6 Class (Department + Year + Section)

| Field          | Type   | Example      |
|----------------|--------|--------------|
| classId        | String | `CSE_3_A`    |
| departmentId   | String | `DEPT_CSE`   |
| year           | int    | 3            |
| section        | String | `A`          |
| classAdviserId | String | `FAC002`     |
| studentCount   | int    | 62           |

### 2.7 Mentor Assignment

| Field       | Type   | Example                  |
|-------------|--------|--------------------------|
| mentorId    | String | `FAC001`                 |
| mentorName  | String | `Dr. Amit Verma`         |
| departmentId| String | `DEPT_CSE`               |
| menteeIds   | List   | `["STU001", "STU004"]`   |
| year        | int    | 3                        |
| section     | String | `A`                      |

---

## 3. Relationship Map

```
┌─────────────────────────────────────────────────────────────┐
│                        ADMIN                                │
│  • Creates Departments                                      │
│  • Creates Faculty → assigns to Department                  │
│  • Creates Students → assigns to Dept + Year + Section      │
│  • Assigns HOD per Department                               │
└────────────────────────┬────────────────────────────────────┘
                         │ creates / manages
          ┌──────────────┼───────────────────┐
          ▼              ▼                   ▼
    ┌──────────┐   ┌──────────┐      ┌──────────────┐
    │DEPARTMENT│   │ FACULTY  │      │   STUDENT    │
    │          │   │          │      │              │
    │ hodId────┤   │ deptId───┤      │ deptId───────┤
    │          │   │ courseIds │      │ year         │
    └─────┬────┘   │ menteeIds│      │ section      │
          │        │ adviser? │      │ mentorId─────┤
          │        └────┬─────┘      │ enrolledCourses
          │             │            └──────┬───────┘
          │             │                   │
          ▼             ▼                   ▼
    ┌──────────────────────────────────────────────┐
    │                   HOD                        │
    │  • Monitors Faculty in same department       │
    │  • Monitors Students in same department      │
    │  • Assigns Class Adviser (faculty → class)   │
    │  • Assigns Mentors (faculty → student group) │
    └──────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────┐
    │           CLASS (Dept + Year + Sec)          │
    │  e.g. CSE - Year 3 - Section A              │
    │                                              │
    │  Class Adviser: FAC002 (assigned by HOD)     │
    │  Students: [STU001, STU004, ...]             │
    │  Courses: [CS201, CS202, MA301, ...]         │
    │                                              │
    │  Mentor Groups:                              │
    │    FAC001 → [STU001, STU004]                 │
    │    FAC005 → [STU007, STU008, STU009]         │
    └─────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────┐
    │               COURSE                         │
    │  CS201 - Data Structures                     │
    │                                              │
    │  Faculty: FAC001 (Dr. Amit Verma)            │
    │  Department: CSE                             │
    │  Sections: [A, B]                            │
    │  Enrolled Students: computed from            │
    │    students where enrolledCourses has CS201  │
    └─────────────────────────────────────────────┘
```

---

## 4. Workflow Descriptions

### 4.1 Admin Workflows

#### A1: Create Department
```
Admin → Departments Page → "Add Department"
  → Enter: departmentName, departmentCode
  → System generates departmentId (DEPT_{code})
  → Department created (HOD assigned later)
```

#### A2: Create Faculty
```
Admin → Faculty Management → "Add Faculty"
  → Enter: name, email, phone, departmentId, designation, qualification
  → System generates: facultyId (FAC{NNN}), user account (id + default password)
  → Faculty appears in department roster
```

#### A3: Create Student
```
Admin → Student Management → "Add Student"
  → Enter: name, email, phone, departmentId, year, section, DOB, blood group, 
           parent details, admission date
  → System generates: studentId (STU{NNN}), user account (id + default password)
  → Student appears in class (dept + year + section)
```

#### A4: Assign HOD
```
Admin → Department → Select Department → "Assign HOD"
  → Pick from faculty list (filtered by same department)
  → Faculty.isHOD = true
  → Department.hodId = faculty.facultyId
  → User role updated to include 'hod' privileges
```

#### A5: Assign Courses to Faculty
```
Admin → Course Management → Create/Edit Course
  → Assign facultyId (from faculty in same dept)
  → Assign sections [A, B, ...]
  → Course linked to faculty & department
```

#### A6: Enroll Students in Courses
```
Admin → Class Management → Select class (dept + year + section)
  → Bulk assign courses for the class
  → Each student in that class gets enrolledCourses updated
  → OR individual enrollment override
```

---

### 4.2 HOD Workflows

#### H1: Assign Class Adviser
```
HOD logs in → "Class Management" → Select class (year + section within own dept)
  → "Assign Class Adviser" → Pick faculty from own department
  → Class.classAdviserId = selected faculty
  → Faculty.isClassAdviser = true
  → Faculty.adviserFor = {departmentId, year, section}
  → All students in that class get classAdviserId updated
```

#### H2: Assign Mentors
```
HOD logs in → "Mentor Management" → Select class (year + section)
  → "Assign Mentor" → Pick faculty from own department
  → Select students (checkboxes) to form mentor group
  → MentorAssignment created
  → Faculty.menteeIds updated
  → Each selected Student.mentorId updated
```

#### H3: Monitor Department
```
HOD logs in → "Department Overview"
  → View all faculty (count, courses, workload)
  → View all students by class (year + section)
  → View course progress, attendance trends
  → View class adviser assignments
  → View mentor-mentee mappings
```

---

### 4.3 Faculty Workflows

#### F1: View My Courses
```
Faculty logs in → Dashboard shows courses from courseIds
  → Click course → see enrolled students, attendance, assignments
```

#### F2: Mark Attendance
```
Faculty → Select Course → Select Date → "Mark Attendance"
  → Student list (filtered by course enrollment)
  → Mark Present/Absent for each student
  → Attendance records updated
```

#### F3: Manage Assignments
```
Faculty → Select Course → "Assignments"
  → Create assignment (title, description, due date, max marks)
  → View submissions, grade them (marks + feedback)
```

#### F4: View Mentees (as Mentor)
```
Faculty → "My Mentees"
  → See list of assigned mentees (from menteeIds)
  → View each mentee's attendance summary, CGPA, complaints
  → Add mentor notes / schedule meetings
```

#### F5: Class Adviser Dashboard (if adviser)
```
Faculty → "Class Adviser" tab (shown only if isClassAdviser = true)
  → View all students in adviserFor class
  → View class-wide attendance summary
  → View complaints from class students
  → Manage class announcements
```

---

### 4.4 Student Workflows

#### S1: View Dashboard
```
Student logs in → Dashboard shows:
  → Profile summary (name, dept, year, section, CGPA)
  → Today's timetable (from enrolled courses)
  → Attendance overview (across enrolled courses)
  → Pending assignments
  → Recent notifications
```

#### S2: View Mentor Info
```
Student → Profile or Dashboard
  → "My Mentor" section shows mentor faculty details
  → Mentor name, phone, email, office hours
```

#### S3: View Class Adviser Info
```
Student → Profile
  → "Class Adviser" section shows adviser faculty details
```

#### S4: Enrolled Courses
```
Student → Courses page
  → Shows all courses from enrolledCourses
  → Each course shows: faculty, schedule, room, credits, attendance %
```

---

## 5. Data Connections Summary

### 5.1 Student ↔ Faculty (via Course)
```
Student.enrolledCourses → [courseId] → Course.facultyId → Faculty
Faculty.courseIds → [courseId] → Course → Students where enrolledCourses contains courseId
```

### 5.2 Student ↔ Faculty (via Department + Section)
```
Student.departmentId + Student.year + Student.section = Class
Class.classAdviserId → Faculty (Class Adviser)
```

### 5.3 Student ↔ Faculty (via Mentor)
```
Student.mentorId → Faculty
Faculty.menteeIds → [studentId] → Students
```

### 5.4 HOD ↔ Department
```
Department.hodId → Faculty (HOD)
HOD sees all Faculty where Faculty.departmentId == Department.departmentId
HOD sees all Students where Student.departmentId == Department.departmentId
```

### 5.5 Multi-Section Handling
```
Department: CSE
  ├── Year 3, Section A → 62 students, Adviser: FAC002
  ├── Year 3, Section B → 58 students, Adviser: FAC006
  ├── Year 2, Section A → 65 students, Adviser: FAC007
  └── Year 2, Section B → 60 students, Adviser: FAC009

Same course CS201 can be taught to Section A & B by same or different faculty
  → Course.sections = ["A", "B"]
  → If different faculty per section, create separate course entries:
       CS201_A (FAC001) and CS201_B (FAC010)
```

---

## 6. JSON Data Structure Expansion Needed

### New JSON files to create:

#### `departments.json`
```json
[
  {
    "departmentId": "DEPT_CSE",
    "departmentName": "Computer Science and Engineering",
    "departmentCode": "CSE",
    "hodId": "FAC003"
  },
  {
    "departmentId": "DEPT_ECE",
    "departmentName": "Electronics and Communication Engineering",
    "departmentCode": "ECE",
    "hodId": "FAC006"
  },
  {
    "departmentId": "DEPT_MECH",
    "departmentName": "Mechanical Engineering",
    "departmentCode": "MECH",
    "hodId": "FAC008"
  },
  {
    "departmentId": "DEPT_CIVIL",
    "departmentName": "Civil Engineering",
    "departmentCode": "CIVIL",
    "hodId": "FAC010"
  }
]
```

#### `faculty.json`
```json
[
  {
    "facultyId": "FAC001",
    "name": "Dr. Amit Verma",
    "email": "amit.verma@ksrce.edu.in",
    "phone": "9876541234",
    "departmentId": "DEPT_CSE",
    "designation": "Associate Professor",
    "qualification": "Ph.D Computer Science",
    "specialization": "Data Structures & Algorithms",
    "dateOfJoining": "2015-06-01",
    "isHOD": false,
    "isClassAdviser": true,
    "adviserFor": { "departmentId": "DEPT_CSE", "year": 3, "section": "A" },
    "menteeIds": ["STU001", "STU004"],
    "courseIds": ["CS201", "CS202"]
  }
]
```

#### `classes.json`
```json
[
  {
    "classId": "CSE_3_A",
    "departmentId": "DEPT_CSE",
    "year": 3,
    "section": "A",
    "classAdviserId": "FAC001",
    "studentIds": ["STU001", "STU004"]
  },
  {
    "classId": "ECE_2_B",
    "departmentId": "DEPT_ECE",
    "year": 2,
    "section": "B",
    "classAdviserId": "FAC006",
    "studentIds": ["STU002"]
  }
]
```

#### `mentor_assignments.json`
```json
[
  {
    "mentorId": "FAC001",
    "mentorName": "Dr. Amit Verma",
    "departmentId": "DEPT_CSE",
    "year": 3,
    "section": "A",
    "menteeIds": ["STU001", "STU004"]
  }
]
```

### Modifications to existing JSON files:

#### `students.json` — add fields:
```json
{
  "mentorId": "FAC001",
  "classAdviserId": "FAC002",
  "enrolledCourses": ["CS201", "CS202", "MA301"],
  "departmentId": "DEPT_CSE"
}
```

#### `courses.json` — add fields:
```json
{
  "departmentId": "DEPT_CSE",
  "sections": ["A", "B"]
}
```

#### `users.json` — add HOD users:
```json
{
  "id": "FAC003",
  "password": "hodPass123",
  "role": "hod",
  "label": "HOD - CSE"
}
```

---

## 7. DataService Expansion Needed

```dart
// New data lists
List<Map<String, dynamic>> _departments = [];
List<Map<String, dynamic>> _faculty = [];
List<Map<String, dynamic>> _classes = [];
List<Map<String, dynamic>> _mentorAssignments = [];

// New methods needed:

// ADMIN
void addStudent(Map<String, dynamic> student);
void addFaculty(Map<String, dynamic> faculty);
void addDepartment(Map<String, dynamic> department);
void assignHOD(String departmentId, String facultyId);
void assignCourseToFaculty(String courseId, String facultyId);
void enrollStudentInCourse(String studentId, String courseId);
void bulkEnrollClass(String classId, List<String> courseIds);

// HOD
void assignClassAdviser(String classId, String facultyId);
void assignMentor(String facultyId, List<String> studentIds);
List<Map<String, dynamic>> getDepartmentFaculty(String departmentId);
List<Map<String, dynamic>> getDepartmentStudents(String departmentId);
List<Map<String, dynamic>> getDepartmentClasses(String departmentId);

// FACULTY
Map<String, dynamic>? getCurrentFaculty();
List<Map<String, dynamic>> getMentees(String facultyId);
Map<String, dynamic>? getAdviserClass(String facultyId);
List<Map<String, dynamic>> getCourseStudents(String courseId);

// STUDENT
Map<String, dynamic>? getMentor(String studentId);
Map<String, dynamic>? getClassAdviser(String studentId);
List<Map<String, dynamic>> getEnrolledCourses(String studentId);
```

---

## 8. UI Pages Needed

### Admin Pages (New/Updated)
| Page                      | Purpose                                       |
|---------------------------|-----------------------------------------------|
| Admin Dashboard           | Overview: dept count, faculty, students, quick actions |
| Department Management     | CRUD departments, assign HOD                  |
| Faculty Management        | Create faculty, assign to department           |
| Student Management        | Create student, assign dept + year + section   |
| Course Management         | Create courses, assign faculty, sections       |
| Class Management          | View classes, bulk course enrollment           |
| HOD Assignment            | Assign HOD per department                      |

### HOD Pages (New)
| Page                      | Purpose                                       |
|---------------------------|-----------------------------------------------|
| HOD Dashboard             | Department overview, faculty & student stats   |
| Class Adviser Assignment  | Assign faculty as adviser per class            |
| Mentor Assignment         | Assign faculty mentors → student groups        |
| Department Faculty View   | All faculty + their courses + workload         |
| Department Students View  | All students grouped by class                  |

### Faculty Pages (Updated)
| Page                      | Purpose                                       |
|---------------------------|-----------------------------------------------|
| Faculty Dashboard         | Courses, schedule, mentees summary             |
| My Mentees                | List of mentees with academic details          |
| Class Adviser View        | Class details (if adviser)                     |

### Student Pages (Updated)
| Page                      | Purpose                                       |
|---------------------------|-----------------------------------------------|
| Student Profile           | Show mentor + class adviser info               |
| Student Dashboard         | Show mentor name, adviser name                 |

---

## 9. Implementation Priority

### Phase 1: Data Foundation
1. Create `departments.json`, `faculty.json`, `classes.json`, `mentor_assignments.json`
2. Update `students.json` with `mentorId`, `classAdviserId`, `enrolledCourses`
3. Update `courses.json` with `sections`
4. Expand `DataService` with new data loading + CRUD methods

### Phase 2: Admin Features
5. Admin Department Management page
6. Admin Faculty Management page (create faculty)
7. Admin Student Management page (create student)
8. Admin Course Management page
9. HOD Assignment page

### Phase 3: HOD Features
10. HOD Dashboard
11. Class Adviser Assignment page
12. Mentor Assignment page
13. Department monitoring views

### Phase 4: Faculty Enhancements
14. My Mentees page
15. Class Adviser Dashboard
16. Updated Faculty Dashboard with mentor/adviser info

### Phase 5: Student Enhancements
17. Update Student Profile with mentor & adviser info
18. Update Student Dashboard with mentor info

---

## 10. Route Structure

```
/admin
  /admin/dashboard
  /admin/departments          ← NEW
  /admin/faculty-management   ← NEW
  /admin/student-management   ← NEW (or update existing)
  /admin/course-management    ← NEW
  /admin/class-management     ← NEW
  /admin/hod-assignment       ← NEW

/hod                          ← NEW role
  /hod/dashboard
  /hod/class-advisers
  /hod/mentors
  /hod/faculty
  /hod/students

/faculty
  /faculty/dashboard          ← updated
  /faculty/mentees            ← NEW
  /faculty/adviser            ← NEW (if class adviser)
  /faculty/courses
  /faculty/attendance
  ...

/student
  /student/dashboard          ← updated (show mentor/adviser)
  /student/profile            ← updated (show mentor/adviser)
  /student/courses
  ...
```

---

## 11. Visual Workflow Diagram

```
                    ┌────────────┐
                    │   ADMIN    │
                    │ (Creates)  │
                    └─────┬──────┘
           ┌──────────────┼──────────────┐
           ▼              ▼              ▼
    ┌────────────┐ ┌────────────┐ ┌────────────┐
    │ DEPARTMENT │ │  FACULTY   │ │  STUDENT   │
    │            │ │            │ │            │
    │ CSE        │ │ FAC001     │ │ STU001     │
    │ ECE        │ │ FAC002     │ │ STU002     │
    │ MECH       │ │ ...        │ │ ...        │
    │ CIVIL      │ │            │ │            │
    └─────┬──────┘ └──────┬─────┘ └─────┬──────┘
          │               │             │
          ▼               ▼             ▼
    ┌─────────────────────────────────────────┐
    │         DEPARTMENT SCOPE                │
    │                                         │
    │  HOD (Faculty with isHOD=true)          │
    │    │                                    │
    │    ├── Assigns CLASS ADVISER            │
    │    │     Faculty → Class(Year+Section)  │
    │    │                                    │
    │    └── Assigns MENTORS                  │
    │          Faculty → [Student group]      │
    │                                         │
    └─────────────────────────────────────────┘
          │
          ▼
    ┌─────────────────────────────────────────┐
    │       CLASS (Dept + Year + Section)      │
    │  e.g. CSE - Year 3 - Section A          │
    │                                         │
    │  Adviser: FAC001                        │
    │  Students: [STU001, STU004, ...]        │
    │                                         │
    │  Mentor Groups:                         │
    │    FAC001 → [STU001, STU004] (5 each)   │
    │    FAC005 → [STU007, STU010] (5 each)   │
    │                                         │
    │  Courses: [CS201, CS202, MA301, ...]    │
    │    CS201 → taught by FAC001             │
    │    CS202 → taught by FAC002             │
    └─────────────────────────────────────────┘
          │
          ▼
    ┌─────────────────────────────────────────┐
    │            COURSE                        │
    │  CS201 - Data Structures                 │
    │                                          │
    │  Faculty: FAC001                         │
    │  Dept: CSE | Semester: 3                 │
    │  Sections: [A, B]                        │
    │  Students: all in CSE/3/A + CSE/3/B      │
    │            who have CS201 in enrolled     │
    │                                          │
    │  Records:                                │
    │    → Attendance per student              │
    │    → Assignments per student             │
    │    → Results per student                 │
    └──────────────────────────────────────────┘
```

---

## 12. Key Business Rules

1. **One HOD per Department** — Admin assigns from faculty in that department
2. **One Class Adviser per Class** — HOD assigns; a class = dept + year + section
3. **Multiple Mentors per Class** — HOD assigns; each mentor gets ~5 students
4. **Faculty teaches multiple courses** — possibly across sections
5. **Student belongs to exactly one class** — dept + year + section
6. **Student enrolls in multiple courses** — determined by class + curriculum
7. **Same department can have multiple sections** — CSE Year 3 Section A, B, C
8. **Mentor must be from same department** — HOD only sees own dept faculty
9. **Class Adviser must be from same department** — enforced in assignment
10. **Admin is the only role that can create users** — students & faculty
