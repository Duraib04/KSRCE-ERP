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

  // Background image rotation
  late AnimationController _backgroundAnimationController;
  int _currentBackgroundIndex = 0;
  late Timer _backgroundTimer;
  final List<String> _backgroundImages = [
    'assets/images/a-block.jpeg',
    'assets/images/b-block.jpeg',
    'assets/images/c-block.jpeg',
    'assets/images/d-block.jpeg',
    'assets/images/f-block.jpeg',
  ];

  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isSubmitting = false;
  String? _error;
  int? _lockDuration;
  int? _remainingAttempts;
  Timer? _lockTimer;
  String? _selectedRole; // Track selected role

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
    
    // Initialize background animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Start background rotation timer (change every 5 seconds)
    _backgroundTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentBackgroundIndex = (_currentBackgroundIndex + 1) % _backgroundImages.length;
        });
        _backgroundAnimationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _lockTimer?.cancel();
    _backgroundTimer.cancel();
    _backgroundAnimationController.dispose();
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
        });
      }
    }
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
          // Animated rotating background
          _buildAnimatedBackground(),
          // Content on top
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(theme),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildForm(theme, isDisabled, isLocked),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - (_backgroundAnimationController.value * 0.2),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImages[_currentBackgroundIndex]),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.lg),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.student,
            AppColors.info,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.student.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // KSRCE Logo with glow
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ksrce-icon.jpeg',
                width: AppIconSize.lg,
                height: AppIconSize.lg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme, bool isDisabled, bool isLocked) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Role Selection Buttons
          _buildRoleSelector(theme),
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
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.placeholderId,
              prefixIcon: Icon(Icons.badge_rounded, color: AppColors.student),
              prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.outlineLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.outlineLight, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.student, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
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
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_rounded, color: AppColors.student),
              prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.textSecondaryLight,
                ),
                onPressed: isDisabled ? null : () => setState(() => _showPassword = !_showPassword),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.outlineLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.outlineLight, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.student, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusMd,
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
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
                    activeColor: AppColors.student,
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
                    color: AppColors.student,
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
                backgroundColor: AppColors.student,
                disabledBackgroundColor: AppColors.inactive,
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
                        color: Colors.white,
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
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.textSecondaryLight),
              label: Text(
                "Back to Home",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
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
    List<DemoCredential> filteredCredentials = _selectedRole != null
        ? widget.demoCredentials.where((c) => c.label.toUpperCase() == _selectedRole).toList()
        : widget.demoCredentials;

    if (filteredCredentials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedRole != null 
                ? "$_selectedRole Demo Credentials:"
                : "Demo Credentials:",
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondaryLight,
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
                    color: AppColors.textSecondaryLight,
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
                      color: AppColors.student,
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

  Widget _buildRoleSelector(ThemeData theme) {
    final roles = [
      {'label': 'Student', 'icon': Icons.person_rounded, 'color': AppColors.student},
      {'label': 'Faculty', 'icon': Icons.school_rounded, 'color': AppColors.faculty},
      {'label': 'Admin', 'icon': Icons.admin_panel_settings_rounded, 'color': AppColors.admin},
    ];
    
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
        Row(
          children: roles.map((role) {
            final label = role['label'] as String;
            final roleUpper = label.toUpperCase();
            final isSelected = _selectedRole == roleUpper;
            final color = role['color'] as Color;
            final icon = role['icon'] as IconData;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = roleUpper;
                    _userIdController.clear();
                    _passwordController.clear();
                    _error = null;
                  });
                },
                child: AnimatedContainer(
                  duration: AppDuration.fast,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                          )
                        : null,
                    color: isSelected ? null : AppColors.backgroundLight,
                    border: Border.all(
                      color: isSelected ? color : AppColors.outlineLight,
                      width: isSelected ? 2 : 1.5,
                    ),
                    borderRadius: AppRadius.radiusMd,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? Colors.white : color,
                        size: AppIconSize.md,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
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

