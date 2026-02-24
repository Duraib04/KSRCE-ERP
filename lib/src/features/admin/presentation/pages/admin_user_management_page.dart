// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key});
  @override
  State<AdminUserManagementPage> createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Upload data
  List<Map<String, String>> _uploadedRows = [];
  List<String> _uploadedHeaders = [];
  Set<int> _selectedForVerification = {};
  bool _isUploading = false;
  String _uploadFileName = '';

  // Users data (from DataService)
  List<Map<String, dynamic>> _allUsers = [];
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _roleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUsers();
  }

  void _loadUsers() {
    final ds = Provider.of<DataService>(context, listen: false);
    _allUsers = List<Map<String, dynamic>>.from(ds.users.map((u) {
      return {
        'userId': u['userId'] ?? '',
        'password': u['password'] ?? '',
        'role': u['role'] ?? 'student',
        'name': u['name'] ?? u['userId'] ?? '',
        'status': u['status'] ?? 'active',
      };
    }));
    // Merge student names
    for (var s in ds.students) {
      final idx = _allUsers.indexWhere((u) => u['userId'] == s['studentId']);
      if (idx >= 0) {
        _allUsers[idx]['name'] = s['name'] ?? _allUsers[idx]['name'];
        _allUsers[idx]['department'] = s['department'] ?? '';
        _allUsers[idx]['email'] = s['email'] ?? '';
        _allUsers[idx]['phone'] = s['phone'] ?? '';
        _allUsers[idx]['year'] = '${s['year'] ?? ''}';
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ===== CSV/Excel Upload =====
  void _pickFile() {
    final input = html.FileUploadInputElement()..accept = '.csv,.xlsx,.xls';
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files == null || files.isEmpty) return;
      final file = files[0];
      setState(() { _isUploading = true; _uploadFileName = file.name; });
      final reader = html.FileReader();
      reader.onLoadEnd.listen((e) {
        final content = reader.result as String;
        _parseCSV(content);
        setState(() { _isUploading = false; });
      });
      reader.readAsText(file);
    });
  }

  void _parseCSV(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.isEmpty) return;
    final headers = lines[0].split(',').map((h) => h.trim().replaceAll('"', '')).toList();
    final rows = <Map<String, String>>[];
    for (var i = 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      final values = lines[i].split(',').map((v) => v.trim().replaceAll('"', '')).toList();
      final row = <String, String>{};
      for (var j = 0; j < headers.length && j < values.length; j++) {
        row[headers[j]] = values[j];
      }
      rows.add(row);
    }
    setState(() {
      _uploadedHeaders = headers;
      _uploadedRows = rows;
      _selectedForVerification = {};
      _tabController.animateTo(1); // Switch to preview tab
    });
  }

  void _toggleSelectAll(bool? val) {
    setState(() {
      if (val == true) {
        _selectedForVerification = Set<int>.from(List.generate(_uploadedRows.length, (i) => i));
      } else {
        _selectedForVerification.clear();
      }
    });
  }

  void _verifyAndSave() {
    if (_selectedForVerification.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one record to verify'), backgroundColor: Colors.red));
      return;
    }
    final ds = Provider.of<DataService>(context, listen: false);
    int addedCount = 0;
    for (final idx in _selectedForVerification) {
      final row = _uploadedRows[idx];
      // Add to users
      final userId = row['userId'] ?? row['studentId'] ?? row['Student ID'] ?? row['user_id'] ?? 'NEW${idx}';
      final existing = ds.users.indexWhere((u) => u['userId'] == userId);
      if (existing < 0) {
        ds.users.add({
          'userId': userId,
          'password': row['password'] ?? 'default123',
          'role': row['role'] ?? 'student',
          'name': row['name'] ?? row['Name'] ?? '',
          'status': 'active',
        });
        addedCount++;
      }
      // Also add to students if role is student
      final role = row['role'] ?? 'student';
      if (role == 'student') {
        final existingStu = ds.students.indexWhere((s) => s['studentId'] == userId);
        if (existingStu < 0) {
          ds.students.add({
            'studentId': userId,
            'name': row['name'] ?? row['Name'] ?? '',
            'department': row['department'] ?? row['Department'] ?? '',
            'year': int.tryParse(row['year'] ?? row['Year'] ?? '1') ?? 1,
            'email': row['email'] ?? row['Email'] ?? '',
            'phone': row['phone'] ?? row['Phone'] ?? '',
          });
        }
      }
    }
    ds.notifyListeners();
    _loadUsers();
    setState(() {
      _uploadedRows.clear();
      _uploadedHeaders.clear();
      _selectedForVerification.clear();
      _tabController.animateTo(2); // Switch to manage tab
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$addedCount users verified and added to database!'), backgroundColor: const Color(0xFF4CAF50)));
  }

  // ===== User CRUD =====
  void _addUser() => _showUserDialog(null);
  void _editUser(int index) => _showUserDialog(index);

  void _showUserDialog(int? editIndex) {
    final isEdit = editIndex != null;
    final user = isEdit ? _allUsers[editIndex] : <String, dynamic>{};
    final idCtrl = TextEditingController(text: user['userId'] ?? '');
    final nameCtrl = TextEditingController(text: user['name'] ?? '');
    final passCtrl = TextEditingController(text: user['password'] ?? '');
    final deptCtrl = TextEditingController(text: user['department'] ?? '');
    final emailCtrl = TextEditingController(text: user['email'] ?? '');
    final phoneCtrl = TextEditingController(text: user['phone'] ?? '');
    String role = user['role'] ?? 'student';

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setDState) {
      return AlertDialog(
        backgroundColor: const Color(0xFF111D35),
        title: Text(isEdit ? 'Edit User' : 'Add New User', style: const TextStyle(color: Colors.white)),
        content: SizedBox(width: 400, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          _dialogField('User ID', idCtrl, enabled: !isEdit),
          _dialogField('Full Name', nameCtrl),
          _dialogField('Password', passCtrl, obscure: true),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: role, dropdownColor: const Color(0xFF0D1F3C),
            decoration: _inputDeco('Role'),
            style: const TextStyle(color: Colors.white),
            items: ['student', 'faculty', 'admin'].map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
            onChanged: (v) => setDState(() => role = v!),
          ),
          const SizedBox(height: 8),
          _dialogField('Department', deptCtrl),
          _dialogField('Email', emailCtrl),
          _dialogField('Phone', phoneCtrl),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
            onPressed: () {
              if (idCtrl.text.isEmpty || nameCtrl.text.isEmpty) return;
              final ds = Provider.of<DataService>(context, listen: false);
              if (isEdit) {
                final uIdx = ds.users.indexWhere((u) => u['userId'] == _allUsers[editIndex]['userId']);
                if (uIdx >= 0) {
                  ds.users[uIdx] = {'userId': idCtrl.text, 'password': passCtrl.text, 'role': role, 'name': nameCtrl.text, 'status': _allUsers[editIndex]['status'] ?? 'active'};
                }
              } else {
                ds.users.add({'userId': idCtrl.text, 'password': passCtrl.text.isEmpty ? 'default123' : passCtrl.text, 'role': role, 'name': nameCtrl.text, 'status': 'active'});
                if (role == 'student') {
                  ds.students.add({'studentId': idCtrl.text, 'name': nameCtrl.text, 'department': deptCtrl.text, 'email': emailCtrl.text, 'phone': phoneCtrl.text, 'year': 1});
                }
              }
              ds.notifyListeners();
              _loadUsers();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'User updated!' : 'User added!'), backgroundColor: const Color(0xFF4CAF50)));
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      );
    }));
  }

  void _deleteUser(int index) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF111D35),
      title: const Text('Remove User', style: TextStyle(color: Colors.white)),
      content: Text('Are you sure you want to permanently remove ${_allUsers[index]['name']}?', style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            final ds = Provider.of<DataService>(context, listen: false);
            ds.users.removeWhere((u) => u['userId'] == _allUsers[index]['userId']);
            ds.students.removeWhere((s) => s['studentId'] == _allUsers[index]['userId']);
            ds.notifyListeners();
            _loadUsers();
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User removed!'), backgroundColor: Colors.red));
          },
          child: const Text('Remove'),
        ),
      ],
    ));
  }

  void _changeStatus(int index, String newStatus) {
    final ds = Provider.of<DataService>(context, listen: false);
    final uIdx = ds.users.indexWhere((u) => u['userId'] == _allUsers[index]['userId']);
    if (uIdx >= 0) {
      ds.users[uIdx]['status'] = newStatus;
      ds.notifyListeners();
      _loadUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User status changed to $newStatus'), backgroundColor: const Color(0xFF1565C0)));
    }
  }

  Widget _dialogField(String label, TextEditingController ctrl, {bool obscure = false, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(controller: ctrl, obscureText: obscure, enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDeco(label)),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label, labelStyle: const TextStyle(color: Colors.white54),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1E3055))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1565C0))),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1E3055))),
    filled: true, fillColor: const Color(0xFF0D1F3C),
  );

  List<Map<String, dynamic>> get _filteredUsers {
    return _allUsers.where((u) {
      final matchesSearch = _searchQuery.isEmpty || u.values.any((v) => v.toString().toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesStatus = _statusFilter == 'All' || u['status'] == _statusFilter.toLowerCase();
      final matchesRole = _roleFilter == 'All' || u['role'] == _roleFilter.toLowerCase();
      return matchesSearch && matchesStatus && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header
      Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('User Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 4),
            Text('Upload, verify, and manage all users', style: TextStyle(fontSize: 14, color: Colors.white54)),
          ])),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
            onPressed: _addUser,
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text('Add User'),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      // Tab bar
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(12)),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(12)),
          labelColor: Colors.white, unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.upload_file, size: 18), const SizedBox(width: 8), const Text('Upload')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.preview, size: 18), const SizedBox(width: 8), Text('Preview (${_uploadedRows.length})')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.people, size: 18), const SizedBox(width: 8), Text('Manage (${_allUsers.length})')])),
          ],
        ),
      ),
      const SizedBox(height: 16),
      // Tab views
      Expanded(child: TabBarView(controller: _tabController, children: [
        _buildUploadTab(),
        _buildPreviewTab(),
        _buildManageTab(),
      ])),
    ]);
  }

  // ===== TAB 1: Upload =====
  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        // Upload area
        InkWell(
          onTap: _pickFile,
          child: Container(
            width: double.infinity, height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E3055), width: 2, strokeAlign: BorderSide.strokeAlignInside),
            ),
            child: _isUploading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF1565C0).withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Click to upload CSV/Excel file', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Supported formats: .csv, .xlsx, .xls', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5))),
                  if (_uploadFileName.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: Text('Last uploaded: $_uploadFileName', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13)),
                    ),
                  ],
                ]),
          ),
        ),
        const SizedBox(height: 24),
        // CSV Format Guide
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E3055))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.info_outline, color: Color(0xFFD4A843), size: 20),
              SizedBox(width: 8),
              Text('CSV Format Guide', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 12),
            Text('Your CSV file should have these column headers:', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF0A1628), borderRadius: BorderRadius.circular(8)),
              child: const SelectableText(
                'userId,name,password,role,department,year,email,phone\nSTU006,John Doe,pass123,student,CSE,2,john@email.com,9876543210\nFAC002,Dr. Smith,fac456,faculty,ECE,,,',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF4CAF50)),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _formatChip('userId', true), _formatChip('name', true), _formatChip('password', false),
              _formatChip('role', false), _formatChip('department', false), _formatChip('year', false),
              _formatChip('email', false), _formatChip('phone', false),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        // Download template
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1E3055)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _downloadTemplate,
          icon: const Icon(Icons.download, color: Color(0xFF1565C0)),
          label: const Text('Download CSV Template', style: TextStyle(color: Color(0xFF1565C0))),
        )),
      ]),
    );
  }

  Widget _formatChip(String label, bool required) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: required ? const Color(0xFF1565C0).withOpacity(0.15) : const Color(0xFF1E3055),
        borderRadius: BorderRadius.circular(12),
        border: required ? Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)) : null,
      ),
      child: Text('$label${required ? " *" : ""}',
        style: TextStyle(fontSize: 12, color: required ? const Color(0xFF42A5F5) : Colors.white54)),
    );
  }

  void _downloadTemplate() {
    const csv = 'userId,name,password,role,department,year,email,phone\nSTU006,John Doe,pass123,student,CSE,2,john@email.com,9876543210\n';
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)..setAttribute('download', 'student_template.csv')..click();
    html.Url.revokeObjectUrl(url);
  }

  // ===== TAB 2: Preview & Verify =====
  Widget _buildPreviewTab() {
    if (_uploadedRows.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.table_chart_outlined, size: 64, color: Colors.white.withOpacity(0.2)),
        const SizedBox(height: 16),
        Text('No data to preview', style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.4))),
        const SizedBox(height: 8),
        Text('Upload a CSV file first', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.3))),
      ]));
    }
    return Column(children: [
      // Toolbar
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
        child: Row(children: [
          Text('${_uploadedRows.length} records loaded', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Text('${_selectedForVerification.length} selected', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
          ),
          const Spacer(),
          Checkbox(
            value: _selectedForVerification.length == _uploadedRows.length && _uploadedRows.isNotEmpty,
            onChanged: _toggleSelectAll,
            activeColor: const Color(0xFF1565C0),
            side: const BorderSide(color: Colors.white54),
          ),
          const Text('Select All', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            onPressed: _verifyAndSave,
            icon: const Icon(Icons.check_circle, size: 18),
            label: const Text('Verify & Save to Database'),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      // Table
      Expanded(child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFF0D1F3C)),
          columnSpacing: 24,
          columns: [
            const DataColumn(label: Text('', style: TextStyle(color: Colors.white70))),
            const DataColumn(label: Text('#', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            ..._uploadedHeaders.map((h) => DataColumn(label: Text(h, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)))),
          ],
          rows: List.generate(_uploadedRows.length, (i) {
            final row = _uploadedRows[i];
            final selected = _selectedForVerification.contains(i);
            return DataRow(
              color: WidgetStateProperty.all(selected ? const Color(0xFF1565C0).withOpacity(0.1) : Colors.transparent),
              cells: [
                DataCell(Checkbox(value: selected, activeColor: const Color(0xFF1565C0), side: const BorderSide(color: Colors.white54),
                  onChanged: (v) => setState(() { if (v == true) _selectedForVerification.add(i); else _selectedForVerification.remove(i); }))),
                DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.white54))),
                ..._uploadedHeaders.map((h) => DataCell(Text(row[h] ?? '', style: const TextStyle(color: Colors.white)))),
              ],
            );
          }),
        ))),
      )),
    ]);
  }

  // ===== TAB 3: Manage Users =====
  Widget _buildManageTab() {
    final filtered = _filteredUsers;
    return Column(children: [
      // Search & Filters
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
        child: Wrap(spacing: 12, runSpacing: 12, children: [
          SizedBox(width: 300, child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search users...', hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true, fillColor: const Color(0xFF0D1F3C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          )),
          _filterDropdown('Status', _statusFilter, ['All', 'Active', 'Suspended', 'Terminated'], (v) => setState(() => _statusFilter = v!)),
          _filterDropdown('Role', _roleFilter, ['All', 'Student', 'Faculty', 'Admin'], (v) => setState(() => _roleFilter = v!)),
          Text('${filtered.length} users', style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ]),
      ),
      const SizedBox(height: 12),
      // Users table
      Expanded(child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFF0D1F3C)),
          columnSpacing: 20,
          columns: const [
            DataColumn(label: Text('#', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('User ID', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Name', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Role', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Department', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
          ],
          rows: List.generate(filtered.length, (i) {
            final u = filtered[i];
            final origIdx = _allUsers.indexOf(u);
            return DataRow(cells: [
              DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.white54))),
              DataCell(Text(u['userId'] ?? '', style: const TextStyle(color: Color(0xFF42A5F5), fontWeight: FontWeight.w500))),
              DataCell(Text(u['name'] ?? '', style: const TextStyle(color: Colors.white))),
              DataCell(_roleBadge(u['role'] ?? 'student')),
              DataCell(Text(u['department'] ?? '-', style: const TextStyle(color: Colors.white70))),
              DataCell(_statusBadge(u['status'] ?? 'active')),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                _actionBtn(Icons.edit, 'Edit', const Color(0xFF1565C0), () => _editUser(origIdx)),
                _actionBtn(Icons.pause_circle, 'Suspend', const Color(0xFFFF9800), () => _changeStatus(origIdx, 'suspended')),
                _actionBtn(Icons.block, 'Terminate', const Color(0xFFEF5350), () => _changeStatus(origIdx, 'terminated')),
                _actionBtn(Icons.play_circle, 'Activate', const Color(0xFF4CAF50), () => _changeStatus(origIdx, 'active')),
                _actionBtn(Icons.delete_forever, 'Remove', Colors.red, () => _deleteUser(origIdx)),
              ])),
            ]);
          }),
        ))),
      )),
    ]);
  }

  Widget _filterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        value: value, dropdownColor: const Color(0xFF0D1F3C),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text('$label: $i'))).toList(),
        onChanged: onChanged,
      )),
    );
  }

  Widget _roleBadge(String role) {
    final color = role == 'admin' ? const Color(0xFFD4A843) : role == 'faculty' ? const Color(0xFF7E57C2) : const Color(0xFF1565C0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(role.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _statusBadge(String status) {
    final color = status == 'active' ? const Color(0xFF4CAF50) : status == 'suspended' ? const Color(0xFFFF9800) : const Color(0xFFEF5350);
    final icon = status == 'active' ? Icons.check_circle : status == 'suspended' ? Icons.pause_circle : Icons.cancel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String tooltip, Color color, VoidCallback onTap) {
    return Tooltip(message: tooltip, child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(6),
      child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon, size: 18, color: color)),
    ));
  }
}
