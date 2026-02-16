import 'package:flutter/material.dart';

class FacultyFeatureAction {
  final String label;
  final String actionId;
  final IconData icon;

  const FacultyFeatureAction({
    required this.label,
    required this.actionId,
    required this.icon,
  });
}

class FacultyFeatureItem {
  final IconData icon;
  final String label;
  final String value;
  final String? status;

  const FacultyFeatureItem({
    required this.icon,
    required this.label,
    required this.value,
    this.status,
  });
}

class FacultyFeatureSection {
  final String title;
  final String? description;
  final List<FacultyFeatureItem> items;
  final List<FacultyFeatureAction> actions;

  const FacultyFeatureSection({
    required this.title,
    this.description,
    required this.items,
    this.actions = const [],
  });
}

class FacultyFeatureConfig {
  final String key;
  final String title;
  final String subtitle;
  final List<FacultyFeatureSection> sections;

  const FacultyFeatureConfig({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.sections,
  });
}

const Map<String, FacultyFeatureConfig> facultyFeatureConfigs = {
  // Core dashboard and overview
  'notifications-center': FacultyFeatureConfig(
    key: 'notifications-center',
    title: 'Notifications Center',
    subtitle: 'System alerts, admin messages, and student messages.',
    sections: [
      FacultyFeatureSection(
        title: 'System Alerts',
        description: 'Critical and high-priority system alerts.',
        items: [
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'ERP Maintenance',
            value: 'Scheduled tonight at 10:00 PM',
            status: 'High',
          ),
          FacultyFeatureItem(
            icon: Icons.security,
            label: 'Policy Update',
            value: 'New password rules active',
            status: 'Info',
          ),
        ],
      ),
      FacultyFeatureSection(
        title: 'Admin Messages',
        items: [
          FacultyFeatureItem(
            icon: Icons.message,
            label: 'HOD Circular',
            value: 'Submit grades by Feb 25',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.event_note,
            label: 'Faculty Meeting',
            value: 'Friday 3:00 PM in Hall A',
            status: 'Info',
          ),
        ],
      ),
      FacultyFeatureSection(
        title: 'Student Messages',
        items: [
          FacultyFeatureItem(
            icon: Icons.chat_bubble,
            label: 'Project Query',
            value: 'Group A requesting guidance',
            status: 'New',
          ),
          FacultyFeatureItem(
            icon: Icons.chat_bubble_outline,
            label: 'Assignment Doubt',
            value: 'Student 21 needs clarification',
            status: 'New',
          ),
        ],
      ),
    ],
  ),
  'announcements': FacultyFeatureConfig(
    key: 'announcements',
    title: 'Announcements',
    subtitle: 'Broadcast announcements to your classes.',
    sections: [
      FacultyFeatureSection(
        title: 'Recent Announcements',
        items: [
          FacultyFeatureItem(
            icon: Icons.campaign,
            label: 'Assignment Deadline',
            value: 'Extended to Feb 20',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.campaign,
            label: 'Lab Schedule',
            value: 'Lab rescheduled to Thu 2 PM',
            status: 'Active',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Create Announcement',
            actionId: 'announce.create',
            icon: Icons.add,
          ),
        ],
      ),
    ],
  ),
  'activity-log': FacultyFeatureConfig(
    key: 'activity-log',
    title: 'Activity Log',
    subtitle: 'Track your ERP actions and audits.',
    sections: [
      FacultyFeatureSection(
        title: 'Recent Activity',
        items: [
          FacultyFeatureItem(
            icon: Icons.login,
            label: 'Login',
            value: 'Today 09:12 AM',
            status: 'Success',
          ),
          FacultyFeatureItem(
            icon: Icons.check_circle,
            label: 'Attendance Updated',
            value: 'CS301 - Section A',
            status: 'Completed',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment_turned_in,
            label: 'Grade Submission',
            value: 'CS302 - Assignment 3',
            status: 'Completed',
          ),
        ],
      ),
    ],
  ),
  'login-history': FacultyFeatureConfig(
    key: 'login-history',
    title: 'Login History',
    subtitle: 'Review your account access history.',
    sections: [
      FacultyFeatureSection(
        title: 'Recent Logins',
        items: [
          FacultyFeatureItem(
            icon: Icons.devices,
            label: 'Windows Desktop',
            value: 'Today 09:12 AM',
            status: 'Success',
          ),
          FacultyFeatureItem(
            icon: Icons.phone_android,
            label: 'Android Phone',
            value: 'Yesterday 08:30 PM',
            status: 'Success',
          ),
        ],
      ),
    ],
  ),
  'grade-submissions': FacultyFeatureConfig(
    key: 'grade-submissions',
    title: 'Grade Submissions',
    subtitle: 'Track submitted grades and approvals.',
    sections: [
      FacultyFeatureSection(
        title: 'Recent Submissions',
        items: [
          FacultyFeatureItem(
            icon: Icons.assignment_turned_in,
            label: 'CS301 - Midterm',
            value: 'Submitted 2 days ago',
            status: 'Approved',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment_turned_in,
            label: 'CS302 - Assignment 2',
            value: 'Submitted today',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'attendance-edits': FacultyFeatureConfig(
    key: 'attendance-edits',
    title: 'Attendance Edits',
    subtitle: 'Track attendance updates and corrections.',
    sections: [
      FacultyFeatureSection(
        title: 'Recent Edits',
        items: [
          FacultyFeatureItem(
            icon: Icons.edit_calendar,
            label: 'CS301 - Feb 12',
            value: '1 record corrected',
            status: 'Approved',
          ),
          FacultyFeatureItem(
            icon: Icons.edit_calendar,
            label: 'CS302 - Feb 10',
            value: '2 records corrected',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),

  // Class and course management
  'course-materials': FacultyFeatureConfig(
    key: 'course-materials',
    title: 'Course Materials',
    subtitle: 'Upload notes, PDFs, assignments, and links.',
    sections: [
      FacultyFeatureSection(
        title: 'Materials Library',
        items: [
          FacultyFeatureItem(
            icon: Icons.description,
            label: 'Notes',
            value: '12 files uploaded',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.picture_as_pdf,
            label: 'PDFs',
            value: '8 files uploaded',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.link,
            label: 'Links',
            value: '5 external links',
            status: 'Active',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Upload Material',
            actionId: 'materials.upload',
            icon: Icons.upload,
          ),
        ],
      ),
    ],
  ),
  'syllabus-tracking': FacultyFeatureConfig(
    key: 'syllabus-tracking',
    title: 'Syllabus Tracking',
    subtitle: 'Monitor syllabus coverage and completion.',
    sections: [
      FacultyFeatureSection(
        title: 'Coverage',
        items: [
          FacultyFeatureItem(
            icon: Icons.check_circle,
            label: 'Unit 1',
            value: 'Completed',
            status: 'Completed',
          ),
          FacultyFeatureItem(
            icon: Icons.timelapse,
            label: 'Unit 2',
            value: 'In progress',
            status: 'In Progress',
          ),
          FacultyFeatureItem(
            icon: Icons.pending,
            label: 'Unit 3',
            value: 'Pending',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'lesson-planner': FacultyFeatureConfig(
    key: 'lesson-planner',
    title: 'Lesson Planner',
    subtitle: 'Weekly plan and topic schedule.',
    sections: [
      FacultyFeatureSection(
        title: 'This Week',
        items: [
          FacultyFeatureItem(
            icon: Icons.event_note,
            label: 'Monday',
            value: 'Trees and Graphs',
            status: 'Planned',
          ),
          FacultyFeatureItem(
            icon: Icons.event_note,
            label: 'Wednesday',
            value: 'Shortest Path',
            status: 'Planned',
          ),
          FacultyFeatureItem(
            icon: Icons.event_note,
            label: 'Friday',
            value: 'Quiz 2',
            status: 'Planned',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Add Plan',
            actionId: 'planner.add',
            icon: Icons.add,
          ),
        ],
      ),
    ],
  ),

  // Attendance system
  'attendance-dashboard': FacultyFeatureConfig(
    key: 'attendance-dashboard',
    title: 'Attendance Dashboard',
    subtitle: 'Class-wise attendance overview.',
    sections: [
      FacultyFeatureSection(
        title: 'Summary',
        items: [
          FacultyFeatureItem(
            icon: Icons.people,
            label: 'Classes',
            value: '4 active sections',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.percent,
            label: 'Average Attendance',
            value: '91.5%',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.warning,
            label: 'Shortage Alerts',
            value: '6 students flagged',
            status: 'High',
          ),
        ],
      ),
    ],
  ),
  'attendance-correction': FacultyFeatureConfig(
    key: 'attendance-correction',
    title: 'Attendance Correction Request',
    subtitle: 'Modify previous attendance entries with approval.',
    sections: [
      FacultyFeatureSection(
        title: 'Open Requests',
        items: [
          FacultyFeatureItem(
            icon: Icons.edit_calendar,
            label: 'CS301 - Feb 10',
            value: '2 students',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.edit_calendar,
            label: 'CS302 - Feb 08',
            value: '1 student',
            status: 'Approved',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Create Request',
            actionId: 'attendance.correction',
            icon: Icons.add,
          ),
        ],
      ),
    ],
  ),
  'attendance-reports': FacultyFeatureConfig(
    key: 'attendance-reports',
    title: 'Attendance Reports',
    subtitle: 'Export CSV/PDF attendance reports.',
    sections: [
      FacultyFeatureSection(
        title: 'Exports',
        items: [
          FacultyFeatureItem(
            icon: Icons.download,
            label: 'CSV',
            value: 'Last exported 2 days ago',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.picture_as_pdf,
            label: 'PDF',
            value: 'Last exported 1 week ago',
            status: 'Ready',
          ),
        ],
      ),
    ],
  ),
  'shortage-alerts': FacultyFeatureConfig(
    key: 'shortage-alerts',
    title: 'Shortage Alerts',
    subtitle: 'Auto-flag low attendance students.',
    sections: [
      FacultyFeatureSection(
        title: 'Flagged Students',
        items: [
          FacultyFeatureItem(
            icon: Icons.person_off,
            label: 'S20210012',
            value: 'Attendance 62%',
            status: 'Critical',
          ),
          FacultyFeatureItem(
            icon: Icons.person_off,
            label: 'S20210018',
            value: 'Attendance 68%',
            status: 'High',
          ),
        ],
      ),
    ],
  ),

  // Grades and exam management
  'grades-dashboard': FacultyFeatureConfig(
    key: 'grades-dashboard',
    title: 'Grade Management Dashboard',
    subtitle: 'Overall grading summary and pending items.',
    sections: [
      FacultyFeatureSection(
        title: 'Summary',
        items: [
          FacultyFeatureItem(
            icon: Icons.assignment_turned_in,
            label: 'Grading Completion',
            value: '76%',
            status: 'In Progress',
          ),
          FacultyFeatureItem(
            icon: Icons.pending_actions,
            label: 'Pending',
            value: '18 submissions',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'internal-marks-entry': FacultyFeatureConfig(
    key: 'internal-marks-entry',
    title: 'Internal Marks Entry',
    subtitle: 'CIA 1, CIA 2, and model exams.',
    sections: [
      FacultyFeatureSection(
        title: 'CIA Entry',
        items: [
          FacultyFeatureItem(
            icon: Icons.score,
            label: 'CIA 1',
            value: '38/45 graded',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.score,
            label: 'CIA 2',
            value: '45/45 graded',
            status: 'Completed',
          ),
        ],
      ),
    ],
  ),
  'assignment-marks-entry': FacultyFeatureConfig(
    key: 'assignment-marks-entry',
    title: 'Assignment Marks Entry',
    subtitle: 'Evaluate and upload assignment scores.',
    sections: [
      FacultyFeatureSection(
        title: 'Assignments',
        items: [
          FacultyFeatureItem(
            icon: Icons.assignment,
            label: 'Assignment 3',
            value: '32/40 graded',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment,
            label: 'Assignment 4',
            value: '40/40 graded',
            status: 'Completed',
          ),
        ],
      ),
    ],
  ),
  'exam-marks-upload': FacultyFeatureConfig(
    key: 'exam-marks-upload',
    title: 'Exam Marks Upload',
    subtitle: 'Upload exam marks and bulk CSV.',
    sections: [
      FacultyFeatureSection(
        title: 'Uploads',
        items: [
          FacultyFeatureItem(
            icon: Icons.upload_file,
            label: 'Model Exam CSV',
            value: 'Uploaded 1 day ago',
            status: 'Processed',
          ),
          FacultyFeatureItem(
            icon: Icons.upload_file,
            label: 'Endterm CSV',
            value: 'Not uploaded',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'grade-validation': FacultyFeatureConfig(
    key: 'grade-validation',
    title: 'Grade Validation',
    subtitle: 'Auto calculation and error detection.',
    sections: [
      FacultyFeatureSection(
        title: 'Validation Results',
        items: [
          FacultyFeatureItem(
            icon: Icons.check_circle,
            label: 'Valid Records',
            value: '142',
            status: 'Completed',
          ),
          FacultyFeatureItem(
            icon: Icons.error,
            label: 'Errors',
            value: '3 mismatches',
            status: 'Critical',
          ),
        ],
      ),
    ],
  ),
  'final-grade-submission': FacultyFeatureConfig(
    key: 'final-grade-submission',
    title: 'Final Grade Submission',
    subtitle: 'Lock grades after final submission.',
    sections: [
      FacultyFeatureSection(
        title: 'Finalization',
        items: [
          FacultyFeatureItem(
            icon: Icons.lock,
            label: 'CS301',
            value: 'Ready to lock',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.lock_open,
            label: 'CS302',
            value: 'Locked',
            status: 'Completed',
          ),
        ],
      ),
    ],
  ),
  'grade-history': FacultyFeatureConfig(
    key: 'grade-history',
    title: 'Grade History',
    subtitle: 'View previously submitted records.',
    sections: [
      FacultyFeatureSection(
        title: 'History',
        items: [
          FacultyFeatureItem(
            icon: Icons.history,
            label: 'CS301 - 2024',
            value: 'Submitted Feb 2025',
            status: 'Completed',
          ),
          FacultyFeatureItem(
            icon: Icons.history,
            label: 'CS302 - 2024',
            value: 'Submitted Feb 2025',
            status: 'Completed',
          ),
        ],
      ),
    ],
  ),

  // Student interaction
  'class-roster': FacultyFeatureConfig(
    key: 'class-roster',
    title: 'Class Roster',
    subtitle: 'Student list with profile preview.',
    sections: [
      FacultyFeatureSection(
        title: 'Roster Snapshot',
        items: [
          FacultyFeatureItem(
            icon: Icons.people,
            label: 'Total Students',
            value: '44',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.person_search,
            label: 'Profile Preview',
            value: 'Tap student for details',
            status: 'Ready',
          ),
        ],
      ),
    ],
  ),
  'student-performance-view': FacultyFeatureConfig(
    key: 'student-performance-view',
    title: 'Student Performance View',
    subtitle: 'Attendance and marks combined view.',
    sections: [
      FacultyFeatureSection(
        title: 'Performance Snapshot',
        items: [
          FacultyFeatureItem(
            icon: Icons.trending_up,
            label: 'Top Performer',
            value: 'S20210004',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.trending_down,
            label: 'Low Performer',
            value: 'S20210012',
            status: 'High',
          ),
        ],
      ),
    ],
  ),
  'mentor-panel': FacultyFeatureConfig(
    key: 'mentor-panel',
    title: 'Mentor / Advisor Panel',
    subtitle: 'Assigned mentees and academic tracking.',
    sections: [
      FacultyFeatureSection(
        title: 'Mentees',
        items: [
          FacultyFeatureItem(
            icon: Icons.person,
            label: 'Assigned',
            value: '12 students',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment_turned_in,
            label: 'On Track',
            value: '9 students',
            status: 'Good',
          ),
        ],
      ),
    ],
  ),
  'student-feedback-review': FacultyFeatureConfig(
    key: 'student-feedback-review',
    title: 'Student Feedback Review',
    subtitle: 'Feedback about faculty and courses.',
    sections: [
      FacultyFeatureSection(
        title: 'Feedback Summary',
        items: [
          FacultyFeatureItem(
            icon: Icons.star,
            label: 'Overall Rating',
            value: '4.4 / 5',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.comment,
            label: 'Comments',
            value: '24 responses',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),
  'messaging-center': FacultyFeatureConfig(
    key: 'messaging-center',
    title: 'Message Students',
    subtitle: 'Individual and bulk messaging.',
    sections: [
      FacultyFeatureSection(
        title: 'Messaging',
        items: [
          FacultyFeatureItem(
            icon: Icons.mail,
            label: 'Bulk Message',
            value: 'Send to class group',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.mail_outline,
            label: 'Individual Message',
            value: 'Send to single student',
            status: 'Ready',
          ),
        ],
      ),
    ],
  ),

  // Schedule and workload
  'substitution-management': FacultyFeatureConfig(
    key: 'substitution-management',
    title: 'Substitution Management',
    subtitle: 'Assign substitute faculty based on free slots.',
    sections: [
      FacultyFeatureSection(
        title: 'Requests',
        items: [
          FacultyFeatureItem(
            icon: Icons.swap_horiz,
            label: 'Pending Substitution',
            value: '2 requests',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.swap_horiz,
            label: 'Approved',
            value: '5 this month',
            status: 'Approved',
          ),
        ],
      ),
    ],
  ),
  'workload-summary': FacultyFeatureConfig(
    key: 'workload-summary',
    title: 'Workload Summary',
    subtitle: 'Total hours handled and subjects per semester.',
    sections: [
      FacultyFeatureSection(
        title: 'Workload',
        items: [
          FacultyFeatureItem(
            icon: Icons.timer,
            label: 'Weekly Hours',
            value: '18 hours',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.class_,
            label: 'Subjects',
            value: '4 subjects',
            status: 'Active',
          ),
        ],
      ),
    ],
  ),
  'invigilation-duty': FacultyFeatureConfig(
    key: 'invigilation-duty',
    title: 'Invigilation Duty',
    subtitle: 'Exam duty schedule and assignments.',
    sections: [
      FacultyFeatureSection(
        title: 'Upcoming Duties',
        items: [
          FacultyFeatureItem(
            icon: Icons.event,
            label: 'Hall B - Feb 20',
            value: '9:00 AM - 12:00 PM',
            status: 'Scheduled',
          ),
          FacultyFeatureItem(
            icon: Icons.event,
            label: 'Hall A - Feb 22',
            value: '1:00 PM - 4:00 PM',
            status: 'Scheduled',
          ),
        ],
      ),
    ],
  ),

  // Admin and requests
  'leave-application': FacultyFeatureConfig(
    key: 'leave-application',
    title: 'Leave Application',
    subtitle: 'Casual, medical, and OD requests.',
    sections: [
      FacultyFeatureSection(
        title: 'Apply Leave',
        items: [
          FacultyFeatureItem(
            icon: Icons.calendar_today,
            label: 'Leave Balance',
            value: '8 days remaining',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.edit,
            label: 'New Request',
            value: 'Create leave request',
            status: 'Ready',
          ),
        ],
      ),
    ],
  ),
  'leave-status': FacultyFeatureConfig(
    key: 'leave-status',
    title: 'Leave Status Tracking',
    subtitle: 'Track submitted leave requests.',
    sections: [
      FacultyFeatureSection(
        title: 'Requests',
        items: [
          FacultyFeatureItem(
            icon: Icons.pending_actions,
            label: 'Feb 18 - 19',
            value: 'Pending approval',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.check_circle,
            label: 'Jan 10',
            value: 'Approved',
            status: 'Approved',
          ),
        ],
      ),
    ],
  ),
  'request-approval': FacultyFeatureConfig(
    key: 'request-approval',
    title: 'Request Approval Panel',
    subtitle: 'Approve student OD or requests.',
    sections: [
      FacultyFeatureSection(
        title: 'Pending Approvals',
        items: [
          FacultyFeatureItem(
            icon: Icons.how_to_reg,
            label: 'OD Request - S20210011',
            value: 'Reason: Competition',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.how_to_reg,
            label: 'OD Request - S20210015',
            value: 'Reason: Workshop',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'department-circulars': FacultyFeatureConfig(
    key: 'department-circulars',
    title: 'Department Circulars',
    subtitle: 'Internal circulars and notices.',
    sections: [
      FacultyFeatureSection(
        title: 'Circulars',
        items: [
          FacultyFeatureItem(
            icon: Icons.article,
            label: 'Academic Calendar',
            value: 'Updated Feb 1',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.article,
            label: 'Lab Safety SOP',
            value: 'Updated Jan 12',
            status: 'Active',
          ),
        ],
      ),
    ],
  ),
  'document-upload-center': FacultyFeatureConfig(
    key: 'document-upload-center',
    title: 'Document Upload Center',
    subtitle: 'Research documents and reports.',
    sections: [
      FacultyFeatureSection(
        title: 'Uploads',
        items: [
          FacultyFeatureItem(
            icon: Icons.upload_file,
            label: 'NAAC Report',
            value: 'Uploaded 2 days ago',
            status: 'Completed',
          ),
          FacultyFeatureItem(
            icon: Icons.upload_file,
            label: 'Project Report',
            value: 'Pending upload',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),

  // Performance and analytics
  'performance-analytics': FacultyFeatureConfig(
    key: 'performance-analytics',
    title: 'Faculty Performance Analytics',
    subtitle: 'Student result trends and analytics.',
    sections: [
      FacultyFeatureSection(
        title: 'Trends',
        items: [
          FacultyFeatureItem(
            icon: Icons.trending_up,
            label: 'Result Trend',
            value: '+6% improvement',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.show_chart,
            label: 'Attendance Trend',
            value: 'Stable',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),
  'grade-distribution': FacultyFeatureConfig(
    key: 'grade-distribution',
    title: 'Grade Distribution',
    subtitle: 'Visualize grade distribution per class.',
    sections: [
      FacultyFeatureSection(
        title: 'Distribution',
        items: [
          FacultyFeatureItem(
            icon: Icons.bar_chart,
            label: 'A and A+',
            value: '42%',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.bar_chart,
            label: 'B and C',
            value: '48%',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.bar_chart,
            label: 'F',
            value: '10%',
            status: 'High',
          ),
        ],
      ),
    ],
  ),
  'attendance-trends': FacultyFeatureConfig(
    key: 'attendance-trends',
    title: 'Attendance Trend Graph',
    subtitle: 'Track attendance over time.',
    sections: [
      FacultyFeatureSection(
        title: 'Trend',
        items: [
          FacultyFeatureItem(
            icon: Icons.show_chart,
            label: 'Last 4 weeks',
            value: '91% average',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.show_chart,
            label: 'Variance',
            value: 'Low',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),
  'department-comparison': FacultyFeatureConfig(
    key: 'department-comparison',
    title: 'Department Comparison View',
    subtitle: 'Compare class performance by department.',
    sections: [
      FacultyFeatureSection(
        title: 'Comparisons',
        items: [
          FacultyFeatureItem(
            icon: Icons.compare,
            label: 'CSE vs ECE',
            value: '+4% in grades',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.compare,
            label: 'ME vs CE',
            value: '+2% in attendance',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),

  // Security and settings
  'change-password': FacultyFeatureConfig(
    key: 'change-password',
    title: 'Change Password',
    subtitle: 'Update password and secure hash logic.',
    sections: [
      FacultyFeatureSection(
        title: 'Password Update',
        items: [
          FacultyFeatureItem(
            icon: Icons.password,
            label: 'Last Changed',
            value: '42 days ago',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.security,
            label: 'Password Strength',
            value: 'Strong',
            status: 'Good',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Update Password',
            actionId: 'security.changePassword',
            icon: Icons.lock,
          ),
        ],
      ),
    ],
  ),
  'security-settings': FacultyFeatureConfig(
    key: 'security-settings',
    title: 'Security Settings',
    subtitle: '2FA, session control, and privacy settings.',
    sections: [
      FacultyFeatureSection(
        title: 'Security',
        items: [
          FacultyFeatureItem(
            icon: Icons.verified_user,
            label: 'Two-Factor Auth',
            value: 'Not enabled',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.phonelink_lock,
            label: 'Trusted Devices',
            value: '2 devices',
            status: 'Active',
          ),
        ],
      ),
    ],
  ),
  'session-control': FacultyFeatureConfig(
    key: 'session-control',
    title: 'Session Control',
    subtitle: 'Manage active sessions.',
    sections: [
      FacultyFeatureSection(
        title: 'Sessions',
        items: [
          FacultyFeatureItem(
            icon: Icons.devices,
            label: 'Windows Desktop',
            value: 'Active now',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.phone_android,
            label: 'Android Phone',
            value: 'Active 1 hour ago',
            status: 'Active',
          ),
        ],
      ),
    ],
  ),
  'privacy-settings': FacultyFeatureConfig(
    key: 'privacy-settings',
    title: 'Privacy Settings',
    subtitle: 'Control visibility and data sharing.',
    sections: [
      FacultyFeatureSection(
        title: 'Privacy',
        items: [
          FacultyFeatureItem(
            icon: Icons.visibility,
            label: 'Profile Visibility',
            value: 'Faculty only',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.share,
            label: 'Data Sharing',
            value: 'Disabled',
            status: 'Good',
          ),
        ],
      ),
    ],
  ),

  // Advanced
  'research-publications': FacultyFeatureConfig(
    key: 'research-publications',
    title: 'Research & Publications',
    subtitle: 'Manage research output and publications.',
    sections: [
      FacultyFeatureSection(
        title: 'Publications',
        items: [
          FacultyFeatureItem(
            icon: Icons.book,
            label: 'Journals',
            value: '8 published',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.book,
            label: 'Conferences',
            value: '5 published',
            status: 'Active',
          ),
        ],
      ),
    ],
  ),
  'project-supervision': FacultyFeatureConfig(
    key: 'project-supervision',
    title: 'Project Supervision',
    subtitle: 'Track student projects and milestones.',
    sections: [
      FacultyFeatureSection(
        title: 'Projects',
        items: [
          FacultyFeatureItem(
            icon: Icons.work,
            label: 'Active Projects',
            value: '6 ongoing',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.flag,
            label: 'Reviews Due',
            value: '2 this week',
            status: 'Pending',
          ),
        ],
      ),
    ],
  ),
  'placement-coordinator': FacultyFeatureConfig(
    key: 'placement-coordinator',
    title: 'Placement Coordinator Panel',
    subtitle: 'Manage placement-related tasks.',
    sections: [
      FacultyFeatureSection(
        title: 'Placements',
        items: [
          FacultyFeatureItem(
            icon: Icons.business_center,
            label: 'Drive Schedule',
            value: '3 upcoming drives',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment,
            label: 'Eligible Students',
            value: '82 students',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),
  'ai-risk-alert': FacultyFeatureConfig(
    key: 'ai-risk-alert',
    title: 'AI Risk Alert',
    subtitle: 'Low performer prediction and risk alerts.',
    sections: [
      FacultyFeatureSection(
        title: 'Risk Summary',
        items: [
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'Low Performer Risk',
            value: '18%',
            status: 'High',
          ),
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'Dropout Risk',
            value: '6%',
            status: 'Medium',
          ),
        ],
      ),
    ],
  ),
  'audit-log-viewer': FacultyFeatureConfig(
    key: 'audit-log-viewer',
    title: 'Audit Log Viewer',
    subtitle: 'Review system and access logs.',
    sections: [
      FacultyFeatureSection(
        title: 'Audit Logs',
        items: [
          FacultyFeatureItem(
            icon: Icons.fact_check,
            label: 'Attendance Edit',
            value: 'CS301 on Feb 10',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.fact_check,
            label: 'Grade Lock',
            value: 'CS302 on Feb 12',
            status: 'Info',
          ),
        ],
      ),
    ],
  ),
  'system-access-control': FacultyFeatureConfig(
    key: 'system-access-control',
    title: 'System Access Control',
    subtitle: 'Role-based access overview.',
    sections: [
      FacultyFeatureSection(
        title: 'Access Controls',
        items: [
          FacultyFeatureItem(
            icon: Icons.shield,
            label: 'Faculty Role',
            value: 'Standard permissions',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.shield,
            label: 'Admin Override',
            value: 'Disabled',
            status: 'Good',
          ),
        ],
      ),
    ],
  ),

  // AI feature pages
  'ai-grading': FacultyFeatureConfig(
    key: 'ai-grading',
    title: 'AI Grading & Evaluation',
    subtitle: 'Auto-evaluate and assist grading workflows.',
    sections: [
      FacultyFeatureSection(
        title: 'Automation',
        items: [
          FacultyFeatureItem(
            icon: Icons.auto_fix_high,
            label: 'MCQ Auto-Scoring',
            value: 'Ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.auto_fix_high,
            label: 'Subjective Scoring',
            value: 'AI-assisted',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.plagiarism,
            label: 'Plagiarism Detection',
            value: 'Enabled',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.compare_arrows,
            label: 'Similarity Detection',
            value: 'Cross-submission scan',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.calculate,
            label: 'Internal Marks Auto-Calc',
            value: 'Rules configured',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.tune,
            label: 'Grade Normalization',
            value: 'Suggestions available',
            status: 'Pending',
          ),
          FacultyFeatureItem(
            icon: Icons.analytics,
            label: 'Abnormal Pattern Detection',
            value: 'Monitor enabled',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.comment,
            label: 'Auto Feedback Comments',
            value: 'Template-based',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.trending_up,
            label: 'Performance Grade Prediction',
            value: 'Suggested ranges',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.rule,
            label: 'Auto Rubric Builder',
            value: 'Rubrics generated',
            status: 'Ready',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Run Auto-Grading',
            actionId: 'ai.grading.run',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Run Similarity Scan',
            actionId: 'ai.grading.similarity',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Normalize Grades',
            actionId: 'ai.grading.normalize',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Generate Feedback',
            actionId: 'ai.grading.feedback',
            icon: Icons.comment,
          ),
          FacultyFeatureAction(
            label: 'Generate Rubric',
            actionId: 'ai.grading.rubric',
            icon: Icons.play_arrow,
          ),
        ],
      ),
    ],
  ),
  'ai-student-intel': FacultyFeatureConfig(
    key: 'ai-student-intel',
    title: 'Student Performance Intelligence',
    subtitle: 'Risk prediction and weak topic analysis.',
    sections: [
      FacultyFeatureSection(
        title: 'Risk Predictions',
        items: [
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'Low Performer Prediction',
            value: '18% of class',
            status: 'High',
          ),
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'Dropout Risk Prediction',
            value: '6% of class',
            status: 'Medium',
          ),
          FacultyFeatureItem(
            icon: Icons.warning_amber,
            label: 'Backlog Probability',
            value: '22% of class',
            status: 'Medium',
          ),
          FacultyFeatureItem(
            icon: Icons.insights,
            label: 'Semester Result Forecast',
            value: 'Avg GPA 7.8',
            status: 'Info',
          ),
          FacultyFeatureItem(
            icon: Icons.topic,
            label: 'Weak Topics per Student',
            value: '12 flagged topics',
            status: 'High',
          ),
          FacultyFeatureItem(
            icon: Icons.topic,
            label: 'Weak Topics per Class',
            value: '3 core topics',
            status: 'Medium',
          ),
          FacultyFeatureItem(
            icon: Icons.compare,
            label: 'Student vs Class Average',
            value: 'Live comparison view',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.grid_view,
            label: 'Risk Heatmap',
            value: 'Interactive grid',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.lightbulb,
            label: 'Improvement Recommendations',
            value: 'Personalized guidance',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.supervisor_account,
            label: 'Smart Mentor Suggestions',
            value: 'Advisor mapping ready',
            status: 'Ready',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Run Risk Scan',
            actionId: 'ai.performance.scan',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Generate Recommendations',
            actionId: 'ai.performance.recommend',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Open Heatmap',
            actionId: 'ai.performance.heatmap',
            icon: Icons.grid_view,
          ),
        ],
      ),
    ],
  ),
  'ai-content-automation': FacultyFeatureConfig(
    key: 'ai-content-automation',
    title: 'AI Content Automation',
    subtitle: 'Generate lesson plans, quizzes, and content.',
    sections: [
      FacultyFeatureSection(
        title: 'Content Tools',
        items: [
          FacultyFeatureItem(
            icon: Icons.auto_stories,
            label: 'Lesson Plan Generator',
            value: 'Ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.menu_book,
            label: 'Syllabus-Based Plan',
            value: 'Auto mapped to units',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.quiz,
            label: 'Question Generator',
            value: 'MCQ + Descriptive',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.checklist,
            label: 'Auto-Generate MCQs',
            value: 'Question bank ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.edit_note,
            label: 'Descriptive Questions',
            value: 'Short + long answers',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.lightbulb,
            label: 'Model Answers',
            value: 'AI drafts',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.summarize,
            label: 'Revision Summary',
            value: 'Unit-level summaries',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.assignment,
            label: 'Assignment Questions',
            value: 'Auto-generated sets',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.description,
            label: 'Question Paper Blueprint',
            value: 'Exam structure ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.psychology,
            label: 'Bloom\'s Level Detection',
            value: 'Tagged per question',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.track_changes,
            label: 'Syllabus Progress Tracking',
            value: 'Auto progress updates',
            status: 'Active',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Generate Lesson Plan',
            actionId: 'ai.content.lessonPlan',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Generate Questions',
            actionId: 'ai.content.questions',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Create Blueprint',
            actionId: 'ai.content.blueprint',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Create Summary',
            actionId: 'ai.content.summary',
            icon: Icons.play_arrow,
          ),
        ],
      ),
    ],
  ),
  'ai-communication': FacultyFeatureConfig(
    key: 'ai-communication',
    title: 'Smart Communication',
    subtitle: 'AI drafts, summarization, and tone checks.',
    sections: [
      FacultyFeatureSection(
        title: 'Communication Tools',
        items: [
          FacultyFeatureItem(
            icon: Icons.email,
            label: 'Draft Email',
            value: 'Auto-generate drafts',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.reply,
            label: 'Auto-Reply',
            value: 'Common queries covered',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.label,
            label: 'Query Categorization',
            value: 'Student queries grouped',
            status: 'Active',
          ),
          FacultyFeatureItem(
            icon: Icons.translate,
            label: 'Translate Messages',
            value: 'Multilingual support',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.fact_check,
            label: 'Tone Checker',
            value: 'Official tone verified',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.groups,
            label: 'Bulk Personalized',
            value: 'Class-wise outreach',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.alarm,
            label: 'Smart Reminders',
            value: 'Auto reminder drafts',
            status: 'Ready',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Draft Message',
            actionId: 'ai.comm.draft',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Summarize Announcement',
            actionId: 'ai.comm.summarize',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Generate Reminders',
            actionId: 'ai.comm.reminders',
            icon: Icons.play_arrow,
          ),
        ],
      ),
    ],
  ),
  'ai-scheduling': FacultyFeatureConfig(
    key: 'ai-scheduling',
    title: 'Smart Scheduling',
    subtitle: 'Conflict-free schedules and workload balancing.',
    sections: [
      FacultyFeatureSection(
        title: 'Scheduling Tools',
        items: [
          FacultyFeatureItem(
            icon: Icons.calendar_today,
            label: 'Conflict Detection',
            value: 'No conflicts found',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.calendar_month,
            label: 'Timetable Generation',
            value: 'Auto-optimized',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.schedule,
            label: 'Workload Balance',
            value: 'Balanced',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.swap_horiz,
            label: 'Substitute Suggestions',
            value: '2 candidates',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.event_available,
            label: 'Exam Scheduling',
            value: 'Optimized slots',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.meeting_room,
            label: 'Meeting Time Suggestions',
            value: '3 available windows',
            status: 'Ready',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Optimize Timetable',
            actionId: 'ai.schedule.optimize',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Suggest Substitute',
            actionId: 'ai.schedule.substitute',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Suggest Meeting',
            actionId: 'ai.schedule.meeting',
            icon: Icons.play_arrow,
          ),
        ],
      ),
    ],
  ),
  'ai-security': FacultyFeatureConfig(
    key: 'ai-security',
    title: 'AI Security',
    subtitle: 'Suspicious logins and anomaly detection.',
    sections: [
      FacultyFeatureSection(
        title: 'Security Monitor',
        items: [
          FacultyFeatureItem(
            icon: Icons.security,
            label: 'Suspicious Logins',
            value: '0 today',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.shield,
            label: 'Brute-Force Detection',
            value: 'No threats',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.shield_moon,
            label: 'Unusual Grade Changes',
            value: 'No anomalies',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.shield,
            label: 'Role Misuse',
            value: 'No anomalies',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.psychology,
            label: 'Behavioral Anomalies',
            value: 'Stable',
            status: 'Good',
          ),
          FacultyFeatureItem(
            icon: Icons.lock_person,
            label: 'Auto-Lock Status',
            value: 'Enabled',
            status: 'Active',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Run Security Scan',
            actionId: 'ai.security.scan',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Lock Suspicious Accounts',
            actionId: 'ai.security.lock',
            icon: Icons.lock,
          ),
        ],
      ),
    ],
  ),
  'ai-reporting': FacultyFeatureConfig(
    key: 'ai-reporting',
    title: 'AI Reporting & Documentation',
    subtitle: 'Auto-generate reports and documentation.',
    sections: [
      FacultyFeatureSection(
        title: 'Reports',
        items: [
          FacultyFeatureItem(
            icon: Icons.description,
            label: 'Class Performance Report',
            value: 'Ready to generate',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.description,
            label: 'Semester Analysis Report',
            value: 'Draft template ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.bar_chart,
            label: 'Department Comparison Charts',
            value: 'Auto-generated',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.description,
            label: 'NAAC/NBA Drafts',
            value: 'Templates available',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.summarize,
            label: 'Faculty Workload Summary',
            value: 'Auto summary ready',
            status: 'Ready',
          ),
          FacultyFeatureItem(
            icon: Icons.trending_up,
            label: 'Next Semester Trend',
            value: 'Forecast ready',
            status: 'Ready',
          ),
        ],
        actions: [
          FacultyFeatureAction(
            label: 'Generate Report',
            actionId: 'ai.reporting.generate',
            icon: Icons.play_arrow,
          ),
          FacultyFeatureAction(
            label: 'Generate Dept Charts',
            actionId: 'ai.reporting.charts',
            icon: Icons.play_arrow,
          ),
        ],
      ),
    ],
  ),
};
