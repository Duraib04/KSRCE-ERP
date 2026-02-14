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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
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
          // Logo Container
          Container(
            decoration: BoxDecoration(
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
            child: ClipOval(
              child: Image.asset(
                'assets/images/ksrce-icon.jpeg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
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
              'Login',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.textPrimaryLight,
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
