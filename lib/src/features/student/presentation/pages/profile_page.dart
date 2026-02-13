import 'package:flutter/material.dart';

class StudentProfilePage extends StatefulWidget {
  final String userId;

  const StudentProfilePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late StudentProfileData profileData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    profileData = StudentProfileData(
      name: 'Rahul Kumar',
      registrationNumber: 'S20210001',
      email: 'rahul.kumar@college.edu',
      phone: '+91 9876543210',
      dateOfBirth: '15-05-2003',
      gender: 'Male',
      department: 'Computer Science',
      semester: 'IV',
      batch: '2021-2025',
      address: '123 Main Street, City, State',
      parentName: 'Suresh Kumar',
      parentPhone: '+91 9999999999',
      emergencyContact: '+91 9876543210',
      gpa: 3.85,
      totalCreditsCompleted: 56,
      totalCreditsRequired: 120,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade200,
                      child: Text(
                        profileData.name[0],
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profileData.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profileData.registrationNumber,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProfileStat('GPA', profileData.gpa.toStringAsFixed(2)),
                        _ProfileStat(
                            'Credits',
                            '${profileData.totalCreditsCompleted}/'
                            '${profileData.totalCreditsRequired}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Basic Information
            _buildSection(
              'Basic Information',
              [
                _buildInfoRow('Email', profileData.email),
                _buildInfoRow('Phone', profileData.phone),
                _buildInfoRow('Date of Birth', profileData.dateOfBirth),
                _buildInfoRow('Gender', profileData.gender),
              ],
            ),
            const SizedBox(height: 16),

            // Academic Information
            _buildSection(
              'Academic Information',
              [
                _buildInfoRow('Department', profileData.department),
                _buildInfoRow('Semester', 'IV'),
                _buildInfoRow('Batch', profileData.batch),
              ],
            ),
            const SizedBox(height: 16),

            // Personal Information
            _buildSection(
              'Personal Information',
              [
                _buildInfoRow('Address', profileData.address),
                _buildInfoRow('Parent Name', profileData.parentName),
                _buildInfoRow('Parent Phone', profileData.parentPhone),
                _buildInfoRow('Emergency Contact', profileData.emergencyContact),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile feature coming soon')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class StudentProfileData {
  final String name;
  final String registrationNumber;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String department;
  final String semester;
  final String batch;
  final String address;
  final String parentName;
  final String parentPhone;
  final String emergencyContact;
  final double gpa;
  final int totalCreditsCompleted;
  final int totalCreditsRequired;

  StudentProfileData({
    required this.name,
    required this.registrationNumber,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.department,
    required this.semester,
    required this.batch,
    required this.address,
    required this.parentName,
    required this.parentPhone,
    required this.emergencyContact,
    required this.gpa,
    required this.totalCreditsCompleted,
    required this.totalCreditsRequired,
  });
}
