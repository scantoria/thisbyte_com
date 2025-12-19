# ThisByte Flutter Final Screens & Firebase (Part 4)

### 9. Create lib/screens/contact_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/firebase_service.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final success = await FirebaseService.sendContactForm(
        name: _nameController.text,
        email: _emailController.text,
        company: _companyController.text,
        message: _messageController.text,
      );
      
      setState(() {
        _isSubmitting = false;
        _submitted = success;
      });
      
      if (success) {
        _nameController.clear();
        _emailController.clear();
        _companyController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ContactHero(),
            _ContactForm(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _ContactHero() {
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
            'Contact',
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 12 : 14,
              color: AppColors.accent,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 30),
          Text(
            'Let's Talk',
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
              'Ready to modernize your infrastructure or discuss a project? Get in touch and let's explore how we can help.',
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

  Widget _ContactForm() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _submitted
            ? _SuccessMessage()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                      controller: _companyController,
                      label: 'Company (Optional)',
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
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
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Send Message',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.ibmPlexSans(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.ibmPlexSans(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _SuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.accent),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 60,
            color: AppColors.accent,
          ),
          const SizedBox(height: 20),
          Text(
            'Message Sent Successfully',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Thank you for reaching out. We'll get back to you within 24 hours.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => setState(() => _submitted = false),
            child: Text(
              'Send Another Message',
              style: GoogleFonts.ibmPlexSans(
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 10. Create lib/screens/privacy_screen.dart

```dart
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
```

---

### 11. Create Firebase Cloud Function - functions/src/index.ts

After running `firebase init` and setting up Functions, replace the content of `functions/src/index.ts` with:

```typescript
import * as functions from 'firebase-functions';
import * as nodemailer from 'nodemailer';

// Configure your email settings here
const EMAIL_USER = 'your-email@gmail.com'; // Replace with your email
const EMAIL_PASS = 'your-app-password'; // Replace with Gmail app password
const RECIPIENT_EMAIL = 'contact@thisbyte.com'; // Where form submissions go

const transporter = nodemailer.createTransporter({
  service: 'gmail',
  auth: {
    user: EMAIL_USER,
    pass: EMAIL_PASS,
  },
});

export const sendContactEmail = functions.https.onCall(async (data, context) => {
  const { name, email, company, message } = data;

  // Validate data
  if (!name || !email || !message) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Name, email, and message are required.'
    );
  }

  const mailOptions = {
    from: EMAIL_USER,
    to: RECIPIENT_EMAIL,
    replyTo: email,
    subject: `New Contact Form Submission from ${name}`,
    html: `
      <h2>New Contact Form Submission</h2>
      <p><strong>Name:</strong> ${name}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Company:</strong> ${company || 'Not provided'}</p>
      <p><strong>Message:</strong></p>
      <p>${message}</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true };
  } catch (error) {
    console.error('Error sending email:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send email');
  }
});
```

**Important Firebase Function Notes:**

1. You'll need to configure Gmail app password:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate an app password for "Mail"
   - Use that password in EMAIL_PASS

2. Update the email addresses in the code

3. Install nodemailer in functions directory:
   ```bash
   cd functions
   npm install nodemailer
   npm install --save-dev @types/nodemailer
   ```

---

Continue to deployment instructions in next message...

