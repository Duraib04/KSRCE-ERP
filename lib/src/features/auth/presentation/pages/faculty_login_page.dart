import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/security_flags.dart';
import '../widgets/login_form.dart';
import '../../domain/models.dart';

class FacultyLoginPage extends StatelessWidget {
  const FacultyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showDemoCredentials = kEnableDemoAuth || kDebugMode;

    const String title = 'K.S.R. College of Engineering';
    const String subtitle = 'Faculty Portal | ERP Login';
    const List<String> allowedPrefixes = ['FAC'];
    const String placeholderId = 'Eg. FAC001';
    final List<DemoCredential> demoCredentials = showDemoCredentials
        ? const [
            DemoCredential(label: 'Faculty', id: 'FAC001', password: 'demo123'),
          ]
        : const [];

    return LoginForm(
      title: title,
      subtitle: subtitle,
      allowedPrefixes: allowedPrefixes,
      placeholderId: placeholderId,
      demoCredentials: demoCredentials,
    );
  }
}
