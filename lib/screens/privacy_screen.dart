import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 80,
                vertical: isMobile ? 60 : 100,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: isMobile ? 36 : 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isMobile ? 10 : 15),
                    Text(
                      'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: isMobile ? 40 : 60),
                    _section(
                      'Introduction',
                      'ThisByte, LLC ("we", "our", or "us") respects your privacy and is committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you visit our website or use our services.',
                    ),
                    _section(
                      'Information We Collect',
                      'We may collect personal information that you voluntarily provide to us when you:\n\n• Contact us through our website\n• Request information about our services\n• Engage with us for professional services\n\nThis information may include your name, email address, company name, and any other details you choose to provide.',
                    ),
                    _section(
                      'How We Use Your Information',
                      'We use the information we collect to:\n\n• Respond to your inquiries\n• Provide requested services\n• Communicate about projects and services\n• Improve our website and services\n• Comply with legal obligations',
                    ),
                    _section(
                      'Data Security',
                      'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                    ),
                    _section(
                      'Third-Party Services',
                      'We may use third-party services (such as hosting providers and email services) that may collect and process your data. These services have their own privacy policies.',
                    ),
                    _section(
                      'Your Rights',
                      'You have the right to:\n\n• Access your personal data\n• Request correction of your data\n• Request deletion of your data\n• Object to processing of your data\n• Request restriction of processing',
                    ),
                    _section(
                      'Analytics and Cookies',
                      'We use Google Analytics and Firebase Analytics to understand how visitors interact with our website. These services use cookies to collect anonymous information such as:\n\n• Pages visited\n• Time spent on site\n• Traffic sources\n• Geographic location (city/country level)\n• Device and browser information\n\nThis information helps us improve our website and services. You can opt out of Google Analytics by installing the Google Analytics Opt-out Browser Add-on available at https://tools.google.com/dlpage/gaoptout',
                    ),
                    _section(
                      'Contact Us',
                      'If you have questions about this privacy policy or our data practices, please contact us through our website contact form.',
                    ),
                    SizedBox(height: isMobile ? 40 : 60),
                    Text(
                      '© ${DateTime.now().year} ThisByte, LLC. All rights reserved.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
