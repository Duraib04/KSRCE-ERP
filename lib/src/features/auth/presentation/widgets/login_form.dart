import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../services/auth_service.dart';
import '../../data/auth_service.dart' as local_auth;
import '../../domain/models.dart';

// TODO: Create dedicated Alert widget
// TODO: Create PasswordStrength widget

class LoginForm extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> allowedPrefixes;
  final String placeholderId;
  final List<DemoCredential> demoCredentials;

  const LoginForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.allowedPrefixes,
    required this.placeholderId,
    required this.demoCredentials,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _localAuthService = local_auth.AuthService();

  // Background image - single static image
  final String _backgroundImage = 'assets/images/a-block.jpeg';

  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isSubmitting = false;
  String? _error;
  int? _lockDuration;
  int? _remainingAttempts;
  Timer? _lockTimer;
  String _selectedRole = 'STUDENT';

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _lockTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadRememberedUser() async {
    final rememberedId = await _localAuthService.getRememberedUser();
    if (rememberedId != null) {
      final prefix = rememberedId.replaceAll(RegExp(r'\d+$'), '').toUpperCase();
      if (widget.allowedPrefixes.contains(prefix)) {
        setState(() {
          _userIdController.text = rememberedId;
          _rememberMe = true;
          _selectedRole = _roleFromPrefix(prefix);
        });
      }
    }
  }

  String _roleFromPrefix(String prefix) {
    if (prefix == 'S') return 'STUDENT';
    if (prefix == 'FAC' || prefix == 'FA') return 'FACULTY';
    if (prefix == 'ADM') return 'ADMIN';
    return 'STUDENT';
  }

  void _startLockTimer(int seconds) {
    _lockTimer?.cancel(); // Cancel any existing timer
    setState(() {
      _lockDuration = seconds;
    });
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockDuration != null && _lockDuration! > 1) {
        setState(() {
          _lockDuration = _lockDuration! - 1;
        });
      } else {
        timer.cancel();
        setState(() {
          _lockDuration = null;
        });
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
      _remainingAttempts = null;
    });

    try {
      final result = await _localAuthService.login(
        _userIdController.text,
        _passwordController.text,
        _rememberMe,
      );

      if (result.success) {
        if (mounted) {
          final userId = _userIdController.text;
          final userPrefix = userId.replaceAll(RegExp(r'\d+$'), '').toUpperCase();
          
          // Determine user role and call auth service
          UserRole role;
          if (userPrefix == 'S') {
            role = UserRole.student;
          } else if (userPrefix == 'FAC' || userPrefix == 'FA') {
            role = UserRole.faculty;
          } else if (userPrefix == 'ADM') {
            role = UserRole.admin;
          } else {
            role = UserRole.student;
          }
          
          // Login through main auth service
          await AuthService.login(
            _userIdController.text,
            _passwordController.text,
            role,
          );

          // Navigate to appropriate dashboard
          if (role == UserRole.student) {
            context.go(StudentRoutes.dashboard);
          } else if (role == UserRole.faculty) {
            context.go(FacultyRoutes.dashboard);
          } else if (role == UserRole.admin) {
            context.go(AdminRoutes.dashboard);
          }
        }
      } else {
        setState(() {
          _error = result.message;
          _remainingAttempts = result.remainingAttempts;
        });
        if (result.lockDuration != null) {
          _startLockTimer(result.lockDuration!);
        }
      }
    } catch (e) {
      setState(() {
        _error = "An unexpected error occurred. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocked = _lockDuration != null && _lockDuration! > 0;
    final isDisabled = _isSubmitting || isLocked;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(theme),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 960;
              
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: isWide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 2,
                                child: _buildBrandPanel(theme),
                              ),
                              SizedBox(width: AppSpacing.xl),
                              Flexible(
                                flex: 2,
                                child: _buildFormCard(
                                  theme,
                                  isDisabled,
                                  isLocked,
                                  compact: false,
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: _buildFormCard(
                              theme,
                              isDisabled,
                              isLocked,
                              compact: true,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_backgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
        ),
        color: Colors.black,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.35),
              Colors.black.withValues(alpha: 0.65),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandPanel(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.radiusLg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.35),
            theme.colorScheme.secondary.withValues(alpha: 0.25),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ksrce-icon.jpeg',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            widget.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Unified ERP access for academics, attendance, and campus services.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildInfoPill('Academics', theme),
              _buildInfoPill('Attendance', theme),
              _buildInfoPill('Results', theme),
              _buildInfoPill('Communications', theme),
            ],
          ),
          SizedBox(height: AppSpacing.xxl),
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Secure, role-based access for students, faculty, and administration.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String label, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildFormCard(
    ThemeData theme,
    bool isDisabled,
    bool isLocked, {
    required bool compact,
  }) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusLg,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCardHeader(theme, compact: compact),
            Padding(
              padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
              child: _buildForm(theme, isDisabled, isLocked),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(ThemeData theme, {required bool compact}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        compact ? AppSpacing.lg : AppSpacing.xl,
        AppSpacing.xl,
        compact ? AppSpacing.md : AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ksrce-icon.jpeg',
                    width: AppIconSize.md,
                    height: AppIconSize.md,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'ERP Login',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Sign in with your institutional credentials.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme, bool isDisabled, bool isLocked) {
    final placeholderId = _rolePlaceholder();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Role Selection Buttons
          _buildRoleSelector(theme, isDisabled: isDisabled),
          SizedBox(height: AppSpacing.xl),
          
          // Alerts
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _Alert(type: _AlertType.destructive, message: _error!),
            ),
          if (isLocked)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _Alert(type: _AlertType.info, message: "Account locked. Try again in $_lockDuration seconds."),
            ),
          if (_remainingAttempts != null && _remainingAttempts! > 0 && _remainingAttempts! <= 2)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _Alert(type: _AlertType.warning, message: "Warning: $_remainingAttempts attempt${_remainingAttempts! != 1 ? 's' : ''} remaining before lockout."),
            ),

          SizedBox(height: AppSpacing.lg),
          
          // User ID Input
          _buildFormLabel(theme, "User ID"),
          SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _userIdController,
            enabled: !isDisabled,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: placeholderId,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(Icons.badge_rounded, color: theme.colorScheme.primary),
              prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your User ID';
              final prefix = value.replaceAll(RegExp(r'\d+$'), '').toUpperCase();
              if (!widget.allowedPrefixes.contains(prefix)) {
                 return 'Invalid ID for this portal.';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg),
          
          // Password Input
          _buildFormLabel(theme, "Password"),
          SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
            enabled: !isDisabled,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(Icons.lock_rounded, color: theme.colorScheme.primary),
              prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: isDisabled ? null : () => setState(() => _showPassword = !_showPassword),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: isDisabled ? null : (value) => setState(() => _rememberMe = value ?? false),
                    activeColor: theme.colorScheme.primary,
                  ),
                  Text(
                    "Remember me",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              TextButton(
                onPressed: isDisabled ? null : () {},
                child: Text(
                  "Forgot password?",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),

          // Login Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
              ),
              onPressed: isDisabled ? null : _handleSubmit,
              child: _isSubmitting
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      "Sign In",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          _buildDemoCredentials(theme),
          SizedBox(height: AppSpacing.md),
          
          // Back to Home
          Center(
            child: TextButton.icon(
              onPressed: isDisabled ? null : () => context.go('/'),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              label: Text(
                "Back to Home",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildDemoCredentials(ThemeData theme) {
    // Get credentials for the selected role only
    List<DemoCredential> filteredCredentials =
      widget.demoCredentials.where((c) => c.label.toUpperCase() == _selectedRole).toList();

    if (filteredCredentials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$_selectedRole Demo Credentials:",
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...filteredCredentials.map((c) => Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${c.label}:",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _userIdController.text = c.id;
                    _passwordController.text = c.password;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Credentials loaded for ${c.label}'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: Text(
                    "${c.id} / ${c.password}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildRoleSelector(ThemeData theme, {required bool isDisabled}) {
    final roles = [
      const (
        value: 'STUDENT',
        label: 'Student',
        icon: Icons.person_rounded,
      ),
      const (
        value: 'FACULTY',
        label: 'Faculty',
        icon: Icons.school_rounded,
      ),
      const (
        value: 'ADMIN',
        label: 'Admin',
        icon: Icons.admin_panel_settings_rounded,
      ),
    ];

    final selectedColor = _selectedRole == 'STUDENT'
        ? AppColors.student
        : _selectedRole == 'FACULTY'
            ? AppColors.faculty
            : AppColors.admin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SegmentedButton<String>(
          segments: roles
              .map(
                (role) => ButtonSegment<String>(
                  value: role.value,
                  label: Text(role.label),
                  icon: Icon(role.icon),
                ),
              )
              .toList(),
          selected: {_selectedRole},
          onSelectionChanged: isDisabled
              ? null
              : (selection) {
                  final nextRole = selection.first;
                  setState(() {
                    _selectedRole = nextRole;
                    _userIdController.clear();
                    _passwordController.clear();
                    _error = null;
                  });
                },
          showSelectedIcon: false,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? selectedColor.withValues(alpha: 0.12)
                  : theme.colorScheme.surface,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? selectedColor
                  : theme.colorScheme.onSurface,
            ),
            side: WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.selected)
                    ? selectedColor
                    : theme.colorScheme.outline,
                width: 1.2,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
            ),
            textStyle: WidgetStateProperty.all(
              theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _rolePlaceholder() {
    switch (_selectedRole) {
      case 'FACULTY':
        return 'Eg. FAC001';
      case 'ADMIN':
        return 'Eg. ADM001';
      default:
        return widget.placeholderId;
    }
  }
}

// Professional Alert Widget with Material Design 3 styling
enum _AlertType { destructive, warning, info }

class _Alert extends StatelessWidget {
  final _AlertType type;
  final String message;
  const _Alert({required this.type, required this.message});

  IconData get icon {
    switch (type) {
      case _AlertType.destructive: return Icons.error_rounded;
      case _AlertType.warning: return Icons.warning_amber_rounded;
      case _AlertType.info: return Icons.info_rounded;
    }
  }

  Color getColor(BuildContext context) {
    switch (type) {
      case _AlertType.destructive: return AppColors.error;
      case _AlertType.warning: return AppColors.warning;
      case _AlertType.info: return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(context);
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppIconSize.md),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

