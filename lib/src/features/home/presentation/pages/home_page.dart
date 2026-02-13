import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';

/// Modern home page displayed before login with professional design.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 0.6 + index * 0.1, curve: Curves.easeOut),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoint.tablet;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/d-block.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppSpacing.lg : AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppConstraints.pageMaxWidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Section
                    _buildAnimatedLogoSection(theme),
                    SizedBox(height: AppSpacing.xxxl),

                    // Feature Cards with Staggered Animation
                    _buildFeatureCardsGrid(context, theme, isMobile),
                    SizedBox(height: AppSpacing.xxxl),

                    // Call to Action Section
                    _buildCallToActionSection(context, theme, isMobile),
                    SizedBox(height: AppSpacing.xl),

                    // Footer
                    _buildFooter(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogoSection(ThemeData theme) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Column(
        children: [
          // Logo Container with gradient
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.student,
                  AppColors.info.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.student.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 8,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.school_rounded,
              size: AppIconSize.xxl,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.xl),

          // Title with Modern Styling
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.student, AppColors.info],
            ).createShader(bounds),
            child: Text(
              'KSRCE ERP',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Subtitle
          Text(
            'KSR College of Engineering',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Enterprise Resource Planning System',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCardsGrid(BuildContext context, ThemeData theme, bool isMobile) {
    final features = [
      _FeatureData(
        icon: Icons.person_rounded,
        title: 'For Students',
        description: 'Access courses, assignments,\nresults, and attendance',
        color: AppColors.student,
        gradient: [AppColors.studentLight, AppColors.student],
      ),
      _FeatureData(
        icon: Icons.school_rounded,
        title: 'For Faculty',
        description: 'Manage classes, grades,\nand attendance records',
        color: AppColors.faculty,
        gradient: [AppColors.facultyLight, AppColors.faculty],
      ),
      _FeatureData(
        icon: Icons.admin_panel_settings_rounded,
        title: 'For Admins',
        description: 'Oversee students, faculty,\nand system settings',
        color: AppColors.admin,
        gradient: [AppColors.adminLight, AppColors.admin],
      ),
    ];

    if (isMobile) {
      return Column(
        children: List.generate(
          features.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: _buildAnimatedFeatureCard(index, features[index], context),
          ),
        ),
      );
    } else {
      return Row(
        children: List.generate(
          features.length,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: _buildAnimatedFeatureCard(index, features[index], context),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAnimatedFeatureCard(int index, _FeatureData feature, BuildContext context) {
    return ScaleTransition(
      scale: _cardAnimations[index],
      child: FadeTransition(
        opacity: _cardAnimations[index],
        child: MouseRegion(
          onEnter: (_) {},
          onExit: (_) {},
          child: AnimatedContainer(
            duration: AppDuration.medium,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: feature.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.radiusLg,
              boxShadow: [
                BoxShadow(
                  color: feature.color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: AppRadius.radiusMd,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      feature.icon,
                      size: AppIconSize.lg,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Title
                  Text(
                    feature.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    feature.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Learn More Arrow
                  Row(
                    children: [
                      Text(
                        'Learn More',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallToActionSection(BuildContext context, ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Headline
        Text(
          'Ready to Get Started?',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.md),

        // Subheadline
        Text(
          'Login to access your personalized dashboard',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.85),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xl),

        // CTA Button
        SizedBox(
          width: isMobile ? double.infinity : 300,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/login'),
            icon: Icon(Icons.arrow_forward_rounded, size: AppIconSize.md),
            label: Text(
              'Get Started',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.student,
              elevation: AppElevation.lg,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.radiusLg,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Divider(
          color: Colors.white.withOpacity(0.2),
          height: 1,
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '© 2025 KSRCE',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              '•',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              'v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<Color> gradient;

  _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.gradient,
  });
}
