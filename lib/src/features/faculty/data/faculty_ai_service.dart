class FacultyAIService {
  static Future<String> runAction(
    String actionId, {
    Map<String, dynamic>? payload,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'Completed: $actionId';
  }

  static Future<Map<String, dynamic>> getPredictionSummary() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return {
      'lowPerformerRisk': 0.18,
      'dropoutRisk': 0.06,
      'backlogRisk': 0.22,
      'nextSemesterGpa': 7.8,
    };
  }
}
