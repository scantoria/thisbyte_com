import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.all(isMobile ? 30 : 50),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FooterSection(),
                _FooterLinks(),
              ],
            )
          else
            Column(
              children: [
                _FooterSection(),
                const SizedBox(height: 30),
                _FooterLinks(),
              ],
            ),
          const SizedBox(height: 30),
          Divider(color: AppColors.border),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} ThisByte, LLC. All rights reserved.',
            style: GoogleFonts.ibmPlexSans(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/thisbyte-logo.png',
          height: 55,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FooterLink('Privacy Policy', '/privacy'),
        const SizedBox(width: 30),
        _FooterLink('Contact', '/contact'),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String route;

  const _FooterLink(this.label, this.route);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSans(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
