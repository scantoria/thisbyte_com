import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _ServicesHero(),
            const _ServicesGrid(),
            const _ApproachSection(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _ServicesHero extends StatelessWidget {
  const _ServicesHero();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 12 : 14,
              color: AppColors.accent,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 30),
          Text(
            'How We Help',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 36 : 56,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 15 : 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Comprehensive IT engineering services that address your entire technology ecosystem.',
              style: GoogleFonts.ibmPlexSans(
                fontSize: isMobile ? 16 : 18,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final services = [
      {
        'title': 'Custom Platform Development',
        'description': 'Replace manual processes and Excel sheets with modern, tailored applications built on robust stacks like React.js and Node.js.',
      },
      {
        'title': 'Integration & Automation',
        'description': 'Deploy orchestration platforms and RPA solutions to connect disparate technologies and eliminate repetitive manual tasks.',
      },
      {
        'title': 'Governance as a Service',
        'description': 'Establish documented, repeatable processes for risk management and compliance based on federal-level standards.',
      },
      {
        'title': 'Cloud Modernization',
        'description': 'Architect scalable Azure/AWS environments and redesign networks for measurable cost savings and improved reliability.',
      },
      {
        'title': 'Mobile Application Products',
        'description': 'Proprietary applications launched on Google Play Store and Apple App Store, with a growing product pipeline.',
      },
      {
        'title': 'Fractional CIO Services',
        'description': 'Strategic technology leadership, governance oversight, and budget management without full-time executive costs.',
      },
    ];

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
      child: isMobile
          ? Column(
              children: services.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _ServiceCard(
                  title: s['title']!,
                  description: s['description']!,
                ),
              )).toList(),
            )
          : Wrap(
              spacing: 30,
              runSpacing: 30,
              children: services.map((s) => SizedBox(
                width: (MediaQuery.of(context).size.width - 160 - 30) / 2,
                child: _ServiceCard(
                  title: s['title']!,
                  description: s['description']!,
                ),
              )).toList(),
            ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;

  const _ServiceCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 22,
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

class _ApproachSection extends StatelessWidget {
  const _ApproachSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Approach',
            style: GoogleFonts.ibmPlexSans(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 50),
          _ApproachStep(
            number: '01',
            title: 'Discovery & Assessment',
            description: 'We analyze your current technology landscape, identifying gaps, risks, and opportunities for improvement.',
          ),
          SizedBox(height: isMobile ? 30 : 40),
          _ApproachStep(
            number: '02',
            title: 'Strategic Planning',
            description: 'Develop a comprehensive roadmap that aligns technology investments with your business objectives.',
          ),
          SizedBox(height: isMobile ? 30 : 40),
          _ApproachStep(
            number: '03',
            title: 'Implementation',
            description: 'Execute with precision, building secure, scalable infrastructure and applications that meet compliance requirements.',
          ),
          SizedBox(height: isMobile ? 30 : 40),
          _ApproachStep(
            number: '04',
            title: 'Ongoing Support',
            description: 'Provide continuous governance, optimization, and strategic guidance to ensure long-term success.',
          ),
          SizedBox(height: isMobile ? 40 : 60),
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
              'Discuss Your Project',
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

class _ApproachStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _ApproachStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.jetBrainsMono(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
            color: AppColors.accent.withOpacity(0.3),
          ),
        ),
        SizedBox(width: isMobile ? 20 : 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: isMobile ? 15 : 16,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
