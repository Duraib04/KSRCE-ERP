import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  int _selectedRole = 0;

  final List<String> _roles = ['Student', 'Faculty', 'Admin'];
  final List<IconData> _roleIcons = [Icons.school, Icons.person, Icons.admin_panel_settings];
  final List<String> _placeholders = ['Eg. STU001', 'Eg. FAC001', 'Eg. ADM001'];
  final Map<String, Map<String, String>> _demoCredentials = {
    'Student': {'userId': 'STU001', 'password': 'password123'},
    'Faculty': {'userId': 'FAC001', 'password': 'facultyPass789'},
    'Admin': {'userId': 'ADM001', 'password': 'adminSecure101'},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedRole = _tabController.index;
        _userIdController.clear();
        _passwordController.clear();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final ds = Provider.of<DataService>(context, listen: false);
    final userId = _userIdController.text.trim();
    final password = _passwordController.text;

    await Future.delayed(const Duration(milliseconds: 400));

    if (ds.login(userId, password)) {
      if (mounted) {
        final role = ds.currentRole;
        if (role == 'student') {
          context.go('/student/dashboard');
        } else if (role == 'admin') {
          context.go('/admin/dashboard');
        } else {
          context.go('/faculty/dashboard');
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid credentials. Try demo credentials below.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _fillDemo() {
    final demo = _demoCredentials[_roles[_selectedRole]]!;
    _userIdController.text = demo['userId']!;
    _passwordController.text = demo['password']!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0D1F3C), Color(0xFF0A1628)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: isWide ? 460 : double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF111D35),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1E3055)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18)),
                          const Spacer(),
                        ]),
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4A843), width: 2),
                            boxShadow: [BoxShadow(color: const Color(0xFFD4A843).withOpacity(0.2), blurRadius: 15, spreadRadius: 3)],
                          ),
                          child: ClipOval(
                            child: Container(
                              color: const Color(0xFF1A2A4A),
                              child: Image.network(
                                'https://www.ksrce.ac.in/images/ksrce-logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.school, size: 40, color: Color(0xFFD4A843))),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('ERP Login', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 6),
                        Text('Access your college ERP portal', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                        const SizedBox(height: 28),
                        Container(
                          decoration: BoxDecoration(color: const Color(0xFF0A1628), borderRadius: BorderRadius.circular(12)),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(12)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white, unselectedLabelColor: Colors.white54,
                            dividerColor: Colors.transparent,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            tabs: List.generate(3, (i) => Tab(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(_roleIcons[i], size: 18), const SizedBox(width: 6), Text(_roles[i]),
                              ]),
                            )),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Align(alignment: Alignment.centerLeft, child: Text('User ID', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _userIdController, style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: _placeholders[_selectedRole], hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.5)),
                            filled: true, fillColor: const Color(0xFF0A1628),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3055))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3055))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Please enter your User ID' : null,
                        ),
                        const SizedBox(height: 20),
                        Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController, obscureText: _obscurePassword, style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your password', hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.5)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white.withOpacity(0.5)),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true, fillColor: const Color(0xFF0A1628),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3055))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3055))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Please enter your password' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            SizedBox(width: 20, height: 20, child: Checkbox(
                              value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              activeColor: const Color(0xFF1565C0), side: const BorderSide(color: Colors.white38),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            )),
                            const SizedBox(width: 8),
                            Text('Remember me', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
                          ]),
                          TextButton(onPressed: () {}, child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF42A5F5), fontSize: 13))),
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity, height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4, disabledBackgroundColor: const Color(0xFF1565C0).withOpacity(0.6),
                            ),
                            child: _isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.login, size: 20), SizedBox(width: 8),
                                  Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity, padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1628), borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1E3055)),
                          ),
                          child: Column(children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.white.withOpacity(0.5)),
                                const SizedBox(width: 8),
                                Text('Demo Credentials (${_roles[_selectedRole]})',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500)),
                              ]),
                              TextButton(
                                onPressed: _fillDemo,
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), minimumSize: Size.zero),
                                child: const Text('Auto Fill', style: TextStyle(color: Color(0xFF42A5F5), fontSize: 12)),
                              ),
                            ]),
                            const SizedBox(height: 8),
                            Row(children: [
                              Text('ID: ', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                              Text(_demoCredentials[_roles[_selectedRole]]!['userId']!, style: const TextStyle(color: Color(0xFFD4A843), fontSize: 12, fontFamily: 'monospace')),
                              const SizedBox(width: 20),
                              Text('Pass: ', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                              Text(_demoCredentials[_roles[_selectedRole]]!['password']!, style: const TextStyle(color: Color(0xFFD4A843), fontSize: 12, fontFamily: 'monospace')),
                            ]),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

