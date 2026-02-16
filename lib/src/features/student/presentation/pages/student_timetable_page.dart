import 'package:flutter/material.dart';
import '../../../data/student_data_service.dart';
import '../../../domain/student_models.dart';

class StudentTimetablePage extends StatefulWidget {
  final String userId;

  const StudentTimetablePage({super.key, required this.userId});

  @override
  State<StudentTimetablePage> createState() => _StudentTimetablePageState();
}

class _StudentTimetablePageState extends State<StudentTimetablePage> with SingleTickerProviderStateMixin {
  List<TimetableEntry>? _timetable;
  bool _isLoading = true;
  late TabController _tabController;
  
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    _loadTimetable();
    
    // Set initial tab to current day (Monday = 0, Sunday = 6)
    final currentDay = DateTime.now().weekday - 1; // Monday = 0
    if (currentDay >= 0 && currentDay < _days.length) {
      _tabController.index = currentDay;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTimetable() async {
    try {
      final timetable = await StudentDataService.getTimetable(widget.userId);
      if (mounted) {
        setState(() {
          _timetable = timetable;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading timetable: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Timetable'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _days.map((day) {
            final isToday = _isToday(day);
            return Tab(
              child: Row(
                children: [
                  Text(day),
                  if (isToday) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, size: 6),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _timetable == null || _timetable!.isEmpty
              ? const Center(child: Text('No timetable available'))
              : RefreshIndicator(
                  onRefresh: _loadTimetable,
                  child: TabBarView(
                    controller: _tabController,
                    children: _days.map((day) => _buildDaySchedule(day)).toList(),
                  ),
                ),
    );
  }

  Widget _buildDaySchedule(String day) {
    final dayEntries = _timetable!
        .where((entry) => entry?.day == day)
        .toList()
      ..sort((a, b) => (a?.startTime ?? '').compareTo(b?.startTime ?? ''));

    if (dayEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No classes scheduled',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dayEntries.length,
      itemBuilder: (context, index) {
        final entry = dayEntries[index];
        final isCurrentClass = _isCurrentClass(entry);
        final isUpcoming = _isUpcomingClass(entry);
        
        return _buildClassCard(entry, isCurrentClass, isUpcoming);
      },
    );
  }

  Widget _buildClassCard(TimetableEntry entry, bool isCurrentClass, bool isUpcoming) {
    Color borderColor;
    Color? backgroundColor;
    
    if (isCurrentClass) {
      borderColor = Colors.green;
      backgroundColor = Colors.green[50];
    } else if (isUpcoming) {
      borderColor = Colors.orange;
      backgroundColor = Colors.orange[50];
    } else {
      borderColor = Colors.grey[300]!;
      backgroundColor = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: () => _showClassDetails(entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      entry.courseCode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isCurrentClass)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ONGOING',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    )
                  else if (isUpcoming)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'UP NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.courseName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(Icons.person, entry.faculty),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(Icons.access_time, '${entry.startTime} - ${entry.endTime}'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(Icons.meeting_room, entry.room),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showClassDetails(TimetableEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.courseCode,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                entry.courseName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildDetailRow(Icons.person, 'Faculty', entry.faculty),
              _buildDetailRow(Icons.calendar_today, 'Day', entry.day),
              _buildDetailRow(Icons.access_time, 'Time', '${entry.startTime} - ${entry.endTime}'),
              _buildDetailRow(Icons.meeting_room, 'Room', entry.room),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isToday(String day) {
    final today = DateTime.now();
    final weekday = today.weekday; // 1 = Monday, 7 = Sunday
    
    return (weekday == 1 && day == 'Monday') ||
           (weekday == 2 && day == 'Tuesday') ||
           (weekday == 3 && day == 'Wednesday') ||
           (weekday == 4 && day == 'Thursday') ||
           (weekday == 5 && day == 'Friday');
  }

  bool _isCurrentClass(TimetableEntry entry) {
    if (!_isToday(entry.day)) return false;
    
    final now = TimeOfDay.now();
    final start = _parseTime(entry.startTime);
    final end = _parseTime(entry.endTime);
    
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  bool _isUpcomingClass(TimetableEntry entry) {
    if (!_isToday(entry.day)) return false;
    
    final now = TimeOfDay.now();
    final start = _parseTime(entry.startTime);
    
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    
    // Check if class starts within next 30 minutes
    return startMinutes > nowMinutes && startMinutes - nowMinutes <= 30;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minuteParts = parts[1].split(' ');
    final minute = int.parse(minuteParts[0]);
    
    if (minuteParts.length > 1 && minuteParts[1].toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (minuteParts.length > 1 && minuteParts[1].toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }
    
    return TimeOfDay(hour: hour, minute: minute);
  }
}
