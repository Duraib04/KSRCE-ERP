import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

import 'faculty_repository.dart';

/// Faculty service implementation using FacultyDataService and repository pattern
class FacultyService implements FacultyRepository {
  final FacultyRepository _repository;

  FacultyService({FacultyRepository? repository})
      : _repository = repository ?? FacultyRepositoryImpl();

  @override
  Future<FacultyProfile> getFacultyProfile(String facultyId) =>
      _repository.getFacultyProfile(facultyId);

  @override
  Future<List<ClassAssignment>> getMyClasses(String facultyId) =>
      _repository.getMyClasses(facultyId);

  @override
  Future<ClassAssignment> getClassDetails(String courseId) =>
      _repository.getClassDetails(courseId);

  @override
  Future<List<ClassAttendance>> getClassAttendanceHistory(String courseId) =>
      _repository.getClassAttendanceHistory(courseId);

  @override
  Future<ClassAttendance> getTodayAttendance(String courseId) =>
      _repository.getTodayAttendance(courseId);

  @override
  Future<bool> markAttendance(ClassAttendance attendance) =>
      _repository.markAttendance(attendance);

  @override
  Future<List<GradeEntry>> getCourseGrades(String courseId) =>
      _repository.getCourseGrades(courseId);

  @override
  Future<bool> updateGrade(String gradeId, int marks) =>
      _repository.updateGrade(gradeId, marks);

  @override
  Future<bool> submitAllGrades(String courseId) =>
      _repository.submitAllGrades(courseId);

  @override
  Future<List<ScheduleEntry>> getWeeklySchedule(String facultyId) =>
      _repository.getWeeklySchedule(facultyId);

  @override
  Future<List<Notice>> getMyNotices(String facultyId) =>
      _repository.getMyNotices(facultyId);

  @override
  Future<bool> postNotice(Notice notice) => _repository.postNotice(notice);

  @override
  Future<bool> deleteNotice(String noticeId) =>
      _repository.deleteNotice(noticeId);

  @override
  Future<Map<String, double>> getFacultyAnalytics(String facultyId) =>
      _repository.getFacultyAnalytics(facultyId);

  @override
  Future<String> exportAttendanceCsv(String courseId) =>
      _repository.exportAttendanceCsv(courseId);

  @override
  Future<String> exportAttendancePdf(String courseId) =>
      _repository.exportAttendancePdf(courseId);

  @override
  Future<String> exportGradesCsv(String courseId) =>
      _repository.exportGradesCsv(courseId);

  @override
  Future<String> exportGradesPdf(String courseId) =>
      _repository.exportGradesPdf(courseId);
}

