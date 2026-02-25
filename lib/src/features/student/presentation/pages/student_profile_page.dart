import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});
  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool _showEditForm = false;
  bool _showMyRequests = false;
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _parentPhoneCtrl = TextEditingController();
  final _bloodGroupCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _parentPhoneCtrl.dispose();
    _bloodGroupCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _initControllers(Map<String, dynamic> student) {
    _phoneCtrl.text = (student['phone'] as String?) ?? '';
    _emailCtrl.text = (student['email'] as String?) ?? '';
    _addressCtrl.text = (student['address'] as String?) ?? '';
    _parentPhoneCtrl.text = (student['parentPhone'] as String?) ?? '';
    _bloodGroupCtrl.text = (student['bloodGroup'] as String?) ?? '';
    _reasonCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      final student = ds.currentStudent ?? {};
      final name = (student['name'] as String?) ?? 'Student';
      final rollNo = (student['studentId'] as String?) ?? ds.currentUserId ?? '';
      final dept = (student['department'] as String?) ?? '';
      final year = (student['year'] as String?) ?? '';
      final section = (student['section'] as String?) ?? '';
      final email = (student['email'] as String?) ?? '';
      final phone = (student['phone'] as String?) ?? '';
      final dob = (student['dateOfBirth'] as String?) ?? '';
      final bloodGroup = (student['bloodGroup'] as String?) ?? '';
      final address = (student['address'] as String?) ?? '';
      final parentName = (student['parentName'] as String?) ?? '';
      final parentPhone = (student['parentPhone'] as String?) ?? '';
      final cgpa = ds.currentCGPA;
      final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
      final myRequests = ds.getMyEditRequests(rollNo);
      final chain = ds.getStudentApprovalChain(rollNo);
      final pendingCount = myRequests.where((r) => r['status'] != 'approved' && r['status'] != 'rejected').length;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                _actionBtn(Icons.edit, 'Edit Profile', AppColors.primary, () {
                  setState(() { _showEditForm = !_showEditForm; _showMyRequests = false; });
                  if (_showEditForm) _initControllers(student);
                }),
                const SizedBox(width: 10),
                Stack(children: [
                  _actionBtn(Icons.history, 'My Requests', AppColors.accent, () {
                    setState(() { _showMyRequests = !_showMyRequests; _showEditForm = false; });
                  }),
                  if (pendingCount > 0)
                    Positioned(top: 0, right: 0, child: Container(
                      width: 18, height: 18, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(9)),
                      alignment: Alignment.center,
                      child: Text('$pendingCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )),
                ]),
              ]),
              const SizedBox(height: 20),
              _profileHeader(isMobile, name, initials, rollNo, dept, year, section),
              const SizedBox(height: 20),
              if (_showEditForm) ...[_buildEditForm(ds, student, chain), const SizedBox(height: 20)],
              if (_showMyRequests) ...[_buildMyRequests(myRequests), const SizedBox(height: 20)],
              if (isMobile) ...[
                _personalInfo(isMobile, dob, bloodGroup),
                const SizedBox(height: 20),
                _academicInfo(isMobile, rollNo, dept, year, cgpa),
              ] else
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _personalInfo(isMobile, dob, bloodGroup)),
                  const SizedBox(width: 20),
                  Expanded(child: _academicInfo(isMobile, rollNo, dept, year, cgpa)),
                ]),
              const SizedBox(height: 20),
              _contactInfo(email, phone, parentName, parentPhone, address),
              const SizedBox(height: 20),
              _approvalChainInfo(chain),
            ]),
          );
        }),
      );
    });
  }

  Widget _buildEditForm(DataService ds, Map<String, dynamic> student, Map<String, String> chain) {
    final mentorName = chain['mentorName'] ?? 'Mentor';
    final adviserName = chain['classAdviserName'] ?? 'Class Adviser';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.edit_note, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          const Expanded(child: Text('Request Profile Edit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))),
          IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => setState(() => _showEditForm = false)),
        ]),
        const SizedBox(height: 6),
        Text('Changes sent to Mentor ($mentorName), then forwarded to Class Adviser ($adviserName) for approval.',
          style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 16),
        Wrap(spacing: 16, runSpacing: 12, children: [
          SizedBox(width: 280, child: _editField(_phoneCtrl, 'Phone Number', Icons.phone)),
          SizedBox(width: 280, child: _editField(_emailCtrl, 'Email', Icons.email)),
          SizedBox(width: 280, child: _editField(_parentPhoneCtrl, 'Parent Phone', Icons.phone_in_talk)),
          SizedBox(width: 280, child: _editField(_bloodGroupCtrl, 'Blood Group', Icons.bloodtype)),
        ]),
        const SizedBox(height: 12),
        _editField(_addressCtrl, 'Address', Icons.location_on),
        const SizedBox(height: 12),
        _editField(_reasonCtrl, 'Reason for change *', Icons.notes),
        const SizedBox(height: 16),
        Align(alignment: Alignment.centerRight, child: ElevatedButton.icon(
          onPressed: () => _submitStudentRequest(ds, student, chain),
          icon: const Icon(Icons.send, size: 16), label: const Text('Submit Request'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        )),
      ]),
    );
  }

  void _submitStudentRequest(DataService ds, Map<String, dynamic> student, Map<String, String> chain) {
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide a reason for the change')));
      return;
    }
    final changes = <String, Map<String, String>>{};
    final fields = {'phone': _phoneCtrl.text, 'email': _emailCtrl.text, 'parentPhone': _parentPhoneCtrl.text, 'bloodGroup': _bloodGroupCtrl.text, 'address': _addressCtrl.text};
    for (final e in fields.entries) {
      final old = (student[e.key] as String?) ?? '';
      if (e.value.trim() != old && e.value.trim().isNotEmpty) changes[e.key] = {'old': old, 'new': e.value.trim()};
    }
    if (changes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No changes detected')));
      return;
    }
    ds.submitProfileEditRequest({
      'requesterId': student['studentId'], 'requesterName': student['name'] ?? '', 'requesterRole': 'student',
      'departmentId': student['departmentId'] ?? '', 'changes': changes, 'reason': _reasonCtrl.text.trim(),
      'status': 'pending_mentor', 'currentApprover': 'mentor',
      'approvalChain': [
        {'role': 'mentor', 'approverId': chain['mentorId'], 'approverName': chain['mentorName'], 'status': 'pending', 'date': '', 'remarks': ''},
        {'role': 'classAdviser', 'approverId': chain['classAdviserId'], 'approverName': chain['classAdviserName'], 'status': 'pending', 'date': '', 'remarks': ''},
      ],
    });
    setState(() => _showEditForm = false);
    final mName = chain['mentorName'] ?? 'Mentor';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit request submitted to $mName'), backgroundColor: AppColors.secondary));
  }

  Widget _buildMyRequests(List<Map<String, dynamic>> requests) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.history, color: AppColors.accent, size: 22), const SizedBox(width: 10),
          const Text('My Edit Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => setState(() => _showMyRequests = false)),
        ]),
        const SizedBox(height: 12),
        if (requests.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No edit requests yet', style: TextStyle(color: AppColors.textLight)))),
        ...requests.map((r) => _requestCard(r)),
      ]),
    );
  }

  Widget _requestCard(Map<String, dynamic> req) {
    final status = req['status'] as String? ?? '';
    final color = status == 'approved' ? AppColors.secondary : status == 'rejected' ? Colors.red : AppColors.accent;
    final icon = status == 'approved' ? Icons.check_circle : status == 'rejected' ? Icons.cancel : Icons.hourglass_top;
    final changes = (req['changes'] as Map<String, dynamic>?) ?? {};
    final chainList = (req['approvalChain'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 18), const SizedBox(width: 8),
          Text(_statusLabel(status), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          const Spacer(),
          Text(req['submittedDate'] ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
        ]),
        const SizedBox(height: 8),
        ...changes.entries.map((e) {
          final c = e.value as Map<String, dynamic>;
          final oldVal = c['old']?.toString() ?? '';
          final newVal = c['new']?.toString() ?? '';
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            _tag(e.key, AppColors.primary), const SizedBox(width: 8),
            Text(oldVal, style: const TextStyle(color: AppColors.textLight, fontSize: 12, decoration: TextDecoration.lineThrough)),
            const Text(' > ', style: TextStyle(color: AppColors.textMedium, fontSize: 12)),
            Text(newVal, style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600)),
          ]));
        }),
        if ((req['reason'] ?? '').toString().isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 4), child: Text('Reason: ${req["reason"]}', style: const TextStyle(color: AppColors.textMedium, fontSize: 12, fontStyle: FontStyle.italic))),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: chainList.map((s) {
          final step = s as Map<String, dynamic>;
          final sc = step['status'] == 'approved' ? AppColors.secondary : step['status'] == 'rejected' ? Colors.red : AppColors.textLight;
          final si = step['status'] == 'approved' ? Icons.check : step['status'] == 'rejected' ? Icons.close : Icons.schedule;
          final stepRole = step['role']?.toString() ?? '';
          final stepStatus = step['status'] == 'pending' ? ' (pending)' : '';
          return Chip(avatar: Icon(si, size: 14, color: sc), label: Text('$stepRole$stepStatus', style: TextStyle(color: sc, fontSize: 11)),
            backgroundColor: sc.withOpacity(0.08), side: BorderSide.none, padding: EdgeInsets.zero, visualDensity: VisualDensity.compact);
        }).toList()),
      ]),
    );
  }

  Widget _approvalChainInfo(Map<String, String> chain) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.verified_user, color: AppColors.primary, size: 20), SizedBox(width: 8),
          Text('Edit Approval Chain', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark))]),
        const SizedBox(height: 12),
        Row(children: [
          _chainStep('You', 'Student', AppColors.accent), _arrow(),
          _chainStep(chain['mentorName'] ?? '-', 'Mentor', AppColors.primary), _arrow(),
          _chainStep(chain['classAdviserName'] ?? '-', 'Class Adviser', AppColors.secondary),
        ]),
      ]),
    );
  }

  Widget _chainStep(String name, String role, Color color) {
    return Expanded(child: Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(role, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(name, style: const TextStyle(color: AppColors.textDark, fontSize: 12), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      ]),
    ));
  }

  Widget _arrow() => const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Icon(Icons.arrow_forward, size: 16, color: AppColors.textLight));

  String _statusLabel(String s) {
    switch (s) {
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      case 'pending_mentor': return 'Pending Mentor Review';
      case 'pending_classAdviser': return 'Pending Class Adviser';
      default: return s;
    }
  }

  Widget _profileHeader(bool isMobile, String name, String initials, String rollNo, String dept, String year, String section) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: isMobile
        ? Column(children: [
            CircleAvatar(radius: 50, backgroundColor: AppColors.accent, child: Text(initials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text('Roll No: $rollNo', style: const TextStyle(fontSize: 16, color: AppColors.accent)),
            const SizedBox(height: 4),
            Text('$dept | Year $year | Sec $section', style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
          ])
        : Row(children: [
            CircleAvatar(radius: 50, backgroundColor: AppColors.accent, child: Text(initials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(width: 24),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('Roll No: $rollNo', style: const TextStyle(fontSize: 16, color: AppColors.accent)),
              const SizedBox(height: 4),
              Text('$dept | Year $year | Section $section', style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
            ]),
          ]),
    );
  }

  Widget _personalInfo(bool isMobile, String dob, String bloodGroup) {
    final details = [{'label': 'Date of Birth', 'value': dob}, {'label': 'Blood Group', 'value': bloodGroup}];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.person, color: AppColors.primary, size: 20), SizedBox(width: 8),
          Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))]),
        const SizedBox(height: 16),
        ...details.where((d) => d['value']!.isNotEmpty).map((d) => Padding(padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: AppColors.textLight, fontSize: 14))),
            Flexible(child: Text(d['value']!, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ]),
        )),
      ]),
    );
  }

  Widget _academicInfo(bool isMobile, String rollNo, String dept, String year, double cgpa) {
    final cgpaStr = cgpa.toStringAsFixed(1);
    final details = [{'label': 'Register Number', 'value': rollNo}, {'label': 'Department', 'value': dept}, {'label': 'Year', 'value': year}, {'label': 'Current CGPA', 'value': cgpaStr}];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.school, color: AppColors.primary, size: 20), SizedBox(width: 8),
          Text('Academic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))]),
        const SizedBox(height: 16),
        ...details.map((d) => Padding(padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: AppColors.textLight, fontSize: 14))),
            Flexible(child: Text(d['value']!, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ]),
        )),
      ]),
    );
  }

  Widget _contactInfo(String email, String phone, String parentName, String parentPhone, String address) {
    final details = <Map<String, dynamic>>[
      if (email.isNotEmpty) {'label': 'Email', 'value': email, 'icon': Icons.email},
      if (phone.isNotEmpty) {'label': 'Phone', 'value': phone, 'icon': Icons.phone},
      if (parentName.isNotEmpty) {'label': 'Parent', 'value': parentName, 'icon': Icons.person_outline},
      if (parentPhone.isNotEmpty) {'label': 'Parent Phone', 'value': parentPhone, 'icon': Icons.phone_in_talk},
      if (address.isNotEmpty) {'label': 'Address', 'value': address, 'icon': Icons.location_on},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.contact_mail, color: AppColors.primary, size: 20), SizedBox(width: 8),
          Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))]),
        const SizedBox(height: 16),
        ...details.map((d) {
          final label = d['label'] as String;
          final value = d['value'] as String;
          final ic = d['icon'] as IconData;
          return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
            Icon(ic, color: AppColors.primary, size: 18), const SizedBox(width: 8),
            Text('$label: ', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
            Flexible(child: Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ]));
        }),
      ]),
    );
  }

  Widget _editField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(controller: ctrl, style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 18),
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13), filled: true, fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
      ));
  }

  Widget _tag(String text, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
    child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)));

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon, size: 16), label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), textStyle: const TextStyle(fontSize: 13)));
  }
}
