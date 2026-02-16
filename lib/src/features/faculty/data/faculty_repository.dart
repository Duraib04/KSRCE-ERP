import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

/// Repository interface for faculty operations.
/// Provides API-ready structure for future backend integration.
/// Currently uses mock data; replace with actual API calls when backend is ready.
abstract class FacultyRepository {
  Future<FacultyProfile> getFacultyProfile(String facultyId);
  Future<List<ClassAssignment>> getMyClasses(String facultyId);
  Future<ClassAssignment> getClassDetails(String courseId);
  Future<List<ClassAttendance>> getClassAttendanceHistory(String courseId);
  Future<ClassAttendance> getTodayAttendance(String courseId);
  Future<bool> markAttendance(ClassAttendance attendance);
  Future<List<GradeEntry>> getCourseGrades(String courseId);
  Future<bool> updateGrade(String gradeId, int marks);
  Future<bool> submitAllGrades(String courseId);
  Future<List<ScheduleEntry>> getWeeklySchedule(String facultyId);
  Future<List<Notice>> getMyNotices(String facultyId);
  Future<bool> postNotice(Notice notice);
  Future<bool> deleteNotice(String noticeId);
  Future<Map<String, double>> getFacultyAnalytics(String facultyId);
  Future<String> exportAttendanceCsv(String courseId);
  Future<String> exportAttendancePdf(String courseId);
  Future<String> exportGradesCsv(String courseId);
  Future<String> exportGradesPdf(String courseId);
}

/// Mock implementation of FacultyRepository using FacultyDataService
class FacultyRepositoryImpl implements FacultyRepository {
  @override
  Future<FacultyProfile> getFacultyProfile(String facultyId) {
    return FacultyDataService.getFacultyProfile(facultyId);
  }

  @override
  Future<List<ClassAssignment>> getMyClasses(String facultyId) {
    return FacultyDataService.getMyClasses(facultyId);
  }

  @override
  Future<ClassAssignment> getClassDetails(String courseId) {
    return FacultyDataService.getClassDetails(courseId);
  }

  @override
  Future<List<ClassAttendance>> getClassAttendanceHistory(String courseId) {
    return FacultyDataService.getClassAttendanceHistory(courseId);
  }

  @override
  Future<ClassAttendance> getTodayAttendance(String courseId) {
    return FacultyDataService.getTodayAttendance(courseId);
  }

  @override
  Future<bool> markAttendance(ClassAttendance attendance) async {
    // Mock implementation
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => true,
    );
  }

  @override
  Future<List<GradeEntry>> getCourseGrades(String courseId) {
    return FacultyDataService.getCourseGrades(courseId);
  }

  @override
  Future<bool> updateGrade(String gradeId, int marks) {
    return FacultyDataService.updateGrade(gradeId, marks);
  }

  @override
  Future<bool> submitAllGrades(String courseId) {
    return FacultyDataService.submitAllGrades(courseId);
  }

  @override
  Future<List<ScheduleEntry>> getWeeklySchedule(String facultyId) {
    return FacultyDataService.getWeeklySchedule(facultyId);
  }

  @override
  Future<List<Notice>> getMyNotices(String facultyId) {
    return FacultyDataService.getMyNotices(facultyId);
  }

  @override
  Future<bool> postNotice(Notice notice) {
    return FacultyDataService.postNotice(notice);
  }

  @override
  Future<bool> deleteNotice(String noticeId) {
    return FacultyDataService.deleteNotice(noticeId);
  }

  @override
  Future<Map<String, double>> getFacultyAnalytics(String facultyId) {
    return FacultyDataService.getFacultyAnalytics(facultyId);
  }

  @override
  Future<String> exportAttendanceCsv(String courseId) {
    return FacultyDataService.exportAttendanceCsv(courseId);
  }

  @override
  Future<String> exportAttendancePdf(String courseId) {
    return FacultyDataService.exportAttendancePdf(courseId);
  }

  @override
  Future<String> exportGradesCsv(String courseId) {
    return FacultyDataService.exportGradesCsv(courseId);
  }

  @override
  Future<String> exportGradesPdf(String courseId) {
    return FacultyDataService.exportGradesPdf(courseId);
  }
}
