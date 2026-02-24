import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 24),
                _buildProfileHeader(isMobile),
                const SizedBox(height: 24),
                if (isMobile) ...[
                  _buildPersonalInfo(isMobile),
                  const SizedBox(height: 24),
                  _buildAcademicInfo(isMobile),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPersonalInfo(isMobile)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildAcademicInfo(isMobile)),
                    ],
                  ),
                const SizedBox(height: 24),
                _buildContactInfo(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: isMobile
          ? Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFD4A843),
                  child: Text('RA', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Rahul Anand', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Roll No: 727622BCS052', style: TextStyle(fontSize: 16, color: Color(0xFFD4A843))),
                    SizedBox(height: 4),
                    Text('B.E. Computer Science & Engineering', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text('3rd Year | Semester 5 | Section B', style: TextStyle(fontSize: 14, color: Colors.white60)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFD4A843),
                  child: Text('RA', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Rahul Anand', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Roll No: 727622BCS052', style: TextStyle(fontSize: 16, color: Color(0xFFD4A843))),
                    SizedBox(height: 4),
                    Text('B.E. Computer Science & Engineering', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text('3rd Year | Semester 5 | Section B', style: TextStyle(fontSize: 14, color: Colors.white60)),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPersonalInfo(bool isMobile) {
    final details = [
      {'label': 'Date of Birth', 'value': '15 March 2004'},
      {'label': 'Gender', 'value': 'Male'},
      {'label': 'Blood Group', 'value': 'B+'},
      {'label': 'Nationality', 'value': 'Indian'},
      {'label': 'Religion', 'value': 'Hindu'},
      {'label': 'Community', 'value': 'BC'},
      {'label': 'Mother Tongue', 'value': 'Tamil'},
      {'label': 'Aadhaar No', 'value': 'XXXX-XXXX-5678'},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.person, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...details.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: Colors.white54, fontSize: 14))),
                Flexible(child: Text(d['value']!, style: const TextStyle(color: Colors.white, fontSize: 14))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo(bool isMobile) {
    final details = [
      {'label': 'Register Number', 'value': '727622BCS052'},
      {'label': 'Batch', 'value': '2022 - 2026'},
      {'label': 'Admission Year', 'value': '2022'},
      {'label': 'Admission Type', 'value': 'Counselling'},
      {'label': 'Department', 'value': 'Computer Science & Engg'},
      {'label': 'Current CGPA', 'value': '8.42'},
      {'label': 'Class Advisor', 'value': 'Dr. S. Meena'},
      {'label': 'HOD', 'value': 'Dr. N. Srinivasan'},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.school, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Academic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...details.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: Colors.white54, fontSize: 14))),
                Flexible(child: Text(d['value']!, style: const TextStyle(color: Colors.white, fontSize: 14))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    final details = [
      {'label': 'Email', 'value': 'rahul.anand@ksrce.ac.in', 'icon': Icons.email},
      {'label': 'Phone', 'value': '+91 9876543210', 'icon': Icons.phone},
      {'label': 'Parent Phone', 'value': '+91 9876543211', 'icon': Icons.phone_in_talk},
      {'label': 'Address', 'value': '42, Gandhi Nagar, Tiruchengode, Namakkal - 637215, Tamil Nadu', 'icon': Icons.location_on},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.contact_mail, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          Wrap(
            spacing: 40,
            runSpacing: 12,
            children: details.map((d) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(d['icon'] as IconData, color: const Color(0xFF1565C0), size: 18),
                const SizedBox(width: 8),
                Text('${d['label']}: ', style: const TextStyle(color: Colors.white54, fontSize: 14)),
                Text(d['value'] as String, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
