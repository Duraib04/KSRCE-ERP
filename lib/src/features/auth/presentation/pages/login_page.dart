import 'package:flutter/material.dart';

import '../../domain/models.dart';
import '../widgets/login_form.dart';

/// A page that displays the login form.
///
/// This widget acts as a provider for the data required by the [LoginForm].
/// In a real-world scenario, this data might be fetched from a remote config
/// or based on the specific login URL (e.g., student vs. faculty portal).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuration that was previously passed as props to the React component.
    const String title = "K.S.R. College of Engineering";
    const String subtitle = "Autonomous Institution | Tiruchengode, Tamil Nadu";
    const List<String> allowedPrefixes = ["S", "ADM"]; // For Student and Admin
    const String placeholderId = "Eg. S20210001";
    const List<DemoCredential> demoCredentials = [
      DemoCredential(label: "Student", id: "S20210001", password: "demo123"),
      DemoCredential(label: "Admin", id: "ADM001", password: "admin123"),
    ];

    return const LoginForm(
      title: title,
      subtitle: subtitle,
      allowedPrefixes: allowedPrefixes,
      placeholderId: placeholderId,
      demoCredentials: demoCredentials,
    );
  }
}
