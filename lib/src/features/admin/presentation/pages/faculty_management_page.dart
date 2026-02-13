import 'package:flutter/material.dart';

class FacultyManagementPage extends StatefulWidget {
  final String userId;

  const FacultyManagementPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FacultyManagementPage> createState() => _FacultyManagementPageState();
}

class _FacultyManagementPageState extends State<FacultyManagementPage> {
  late List<FacultyMember> facultyList;
  String searchQuery = '';
  String selectedDepartment = 'All';

  @override
  void initState() {
    super.initState();
    _loadFacultyList();
  }

  void _loadFacultyList() {
    facultyList = [
      FacultyMember(
        employeeId: 'F001',
        name: 'Dr. Rajesh Kumar',
        department: 'Computer Science',
        designation: 'Associate Professor',
        email: 'rajesh@college.edu',
        phone: '+91 98765 12340',
        status: 'Active',
        coursesTeaching: 3,
      ),
      FacultyMember(
        employeeId: 'F002',
        name: 'Prof. Meera Singh',
        department: 'Computer Science',
        designation: 'Professor',
        email: 'meera@college.edu',
        phone: '+91 98765 12341',
        status: 'Active',
        coursesTeaching: 2,
      ),
      FacultyMember(
        employeeId: 'F003',
        name: 'Dr. Anil Patel',
        department: 'Electronics',
        designation: 'Assistant Professor',
        email: 'anil@college.edu',
        phone: '+91 98765 12342',
        status: 'Active',
        coursesTeaching: 4,
      ),
      FacultyMember(
        employeeId: 'F004',
        name: 'Ms. Priya Verma',
        department: 'Computer Science',
        designation: 'Assistant Professor',
        email: 'priya@college.edu',
        phone: '+91 98765 12343',
        status: 'On Leave',
        coursesTeaching: 0,
      ),
    ];
  }

  List<FacultyMember> getFilteredFacultyList() {
    List<FacultyMember> filtered = facultyList;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((faculty) =>
              faculty.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              faculty.employeeId
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedDepartment != 'All') {
      filtered =
          filtered.where((faculty) => faculty.department == selectedDepartment).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Management'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or ID',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDepartment,
                    isExpanded: true,
                    underline: Container(),
                    items: [
                      'All',
                      'Computer Science',
                      'Electronics',
                      'Mechanical',
                    ]
                        .map((dept) => DropdownMenuItem(
                              value: dept,
                              child: Text(dept),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value ?? 'All';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Faculty List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: getFilteredFacultyList().length,
              itemBuilder: (context, index) {
                return _buildFacultyCard(getFilteredFacultyList()[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFacultyDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Faculty',
      ),
    );
  }

  Widget _buildFacultyCard(FacultyMember faculty) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showFacultyDetails(faculty);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faculty.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          faculty.designation,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(faculty.status),
                    backgroundColor: faculty.status == 'Active'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    labelStyle: TextStyle(
                      color: faculty.status == 'Active'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FacultyInfo('Emp ID', faculty.employeeId),
                  _FacultyInfo('Department', faculty.department),
                  _FacultyInfo('Courses', '${faculty.coursesTeaching}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFacultyDetails(FacultyMember faculty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(faculty.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Employee ID', faculty.employeeId),
            _DetailRow('Designation', faculty.designation),
            _DetailRow('Department', faculty.department),
            _DetailRow('Email', faculty.email),
            _DetailRow('Phone', faculty.phone),
            _DetailRow('Status', faculty.status),
            _DetailRow('Courses Teaching', '${faculty.coursesTeaching}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${faculty.name} information updated')),
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAddFacultyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Faculty Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter faculty name',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Employee ID',
                  hintText: 'Enter employee ID',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter phone number',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Faculty member added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _FacultyInfo extends StatelessWidget {
  final String label;
  final String value;

  const _FacultyInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class FacultyMember {
  final String employeeId;
  final String name;
  final String department;
  final String designation;
  final String email;
  final String phone;
  final String status;
  final int coursesTeaching;

  FacultyMember({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.designation,
    required this.email,
    required this.phone,
    required this.status,
    required this.coursesTeaching,
  });
}
