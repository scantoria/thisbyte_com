import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),
            const _ValueSection(),
            const _CTASection(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accurate IT Engineering',
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 12 : 14,
              color: AppColors.accent,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

          SizedBox(height: isMobile ? 20 : 30),

          Text(
            'The Full Stack\nand Beneath',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 40 : 72,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3, end: 0),

          SizedBox(height: isMobile ? 20 : 30),

          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'We engineer the underlying infrastructure, security governance, and network architecture to ensure your software is compliant, resilient, and cost-effective.',
              style: GoogleFonts.ibmPlexSans(
                fontSize: isMobile ? 16 : 20,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3, end: 0),

          SizedBox(height: isMobile ? 30 : 50),

          ElevatedButton(
            onPressed: () => context.go('/contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 30 : 40,
                vertical: isMobile ? 18 : 22,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Text(
              'Start a Project',
              style: GoogleFonts.ibmPlexSans(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}

class _ValueSection extends StatelessWidget {
  const _ValueSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What We Do Differently',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 15 : 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'We go beyond code to address the complete technology ecosystem—systems, networks, and infrastructure.',
              style: GoogleFonts.ibmPlexSans(
                fontSize: isMobile ? 16 : 18,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 40 : 60),
          _ValueGrid(),
        ],
      ),
    );
  }
}

class _ValueGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final values = [
      {
        'title': 'Executive-Level Expertise',
        'description': 'Proven track record stabilizing federal healthcare systems and architecting ATO-compliant environments with 100% audit success.',
      },
      {
        'title': 'Complete Infrastructure Focus',
        'description': 'We engineer security governance, network architecture, and cloud infrastructure—not just application code.',
      },
      {
        'title': 'Enterprise Standards for SMBs',
        'description': 'Bringing federal-grade compliance and architecture to small and mid-sized businesses without enterprise budgets.',
      },
    ];

    return isMobile
        ? Column(
            children: values.map((v) => Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _ValueCard(
                title: v['title']!,
                description: v['description']!,
              ),
            )).toList(),
          )
        : Wrap(
            spacing: 30,
            runSpacing: 30,
            children: values.map((v) => SizedBox(
              width: (MediaQuery.of(context).size.width - 160 - 60) / 3,
              child: _ValueCard(
                title: v['title']!,
                description: v['description']!,
              ),
            )).toList(),
          );
  }
}

class _ValueCard extends StatelessWidget {
  final String title;
  final String description;

  const _ValueCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 2,
            color: AppColors.accent,
            margin: const EdgeInsets.only(bottom: 20),
          ),
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          Text(
            'Ready to build something reliable?',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 20 : 30),
          Text(
            'Let\'s discuss your technology infrastructure needs.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 16 : 18,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 30 : 40),
          ElevatedButton(
            onPressed: () => context.go('/contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 30 : 40,
                vertical: isMobile ? 18 : 22,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Text(
              'Get in Touch',
              style: GoogleFonts.ibmPlexSans(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
