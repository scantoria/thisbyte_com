# ThisByte Flutter Code Implementation

## File Structure
```
thisbyte_website/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── services_screen.dart
│   │   ├── contact_screen.dart
│   │   └── privacy_screen.dart
│   ├── widgets/
│   │   ├── app_bar_widget.dart
│   │   └── footer_widget.dart
│   └── utils/
│       ├── colors.dart
│       └── firebase_service.dart
├── functions/
│   └── src/
│       └── index.ts
└── pubspec.yaml
```

## Step-by-Step Code Creation

### 1. Update pubspec.yaml dependencies section

Replace the dependencies section with:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  google_fonts: ^6.1.0
  url_launcher: ^6.2.2
  firebase_core: ^2.24.2
  cloud_functions: ^4.5.0
  flutter_animate: ^4.3.0
  go_router: ^13.0.0
```

Run: `flutter pub get`

---

### 2. Create lib/utils/colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Elegant slate and warm accent palette
  static const primary = Color(0xFF1E293B);      // Slate 800
  static const secondary = Color(0xFF334155);    // Slate 700
  static const background = Color(0xFF0F172A);   // Slate 900
  static const surface = Color(0xFF1E293B);      // Slate 800
  
  // Warm copper accent for professionalism
  static const accent = Color(0xFFD4A574);       // Warm copper/gold
  static const accentLight = Color(0xFFE8C4A0);  // Light copper
  
  // Text colors
  static const textPrimary = Color(0xFFF1F5F9);  // Slate 100
  static const textSecondary = Color(0xFF94A3B8); // Slate 400
  static const textMuted = Color(0xFF64748B);    // Slate 500
  
  // Borders and dividers
  static const border = Color(0xFF334155);       // Slate 700
  static const divider = Color(0xFF1E293B);      // Slate 800
}
```

---

### 3. Create lib/utils/firebase_service.dart

```dart
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  static Future<bool> sendContactForm({
    required String name,
    required String email,
    required String company,
    required String message,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendContactEmail');
      await callable.call({
        'name': name,
        'email': email,
        'company': company,
        'message': message,
      });
      return true;
    } catch (e) {
      print('Error sending contact form: $e');
      return false;
    }
  }
}
```

---

### 4. Create lib/widgets/app_bar_widget.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.from import(Size(double.infinity, 70));

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              InkWell(
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    Text(
                      '<',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppColors.accent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ThisByte',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      '/>',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppColors.accent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Navigation
              if (!isMobile)
                Row(
                  children: [
                    _NavLink('Home', '/'),
                    const SizedBox(width: 30),
                    _NavLink('Services', '/services'),
                    const SizedBox(width: 30),
                    _NavLink('Contact', '/contact'),
                  ],
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.accent),
                  onPressed: () => _showMobileMenu(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MobileNavItem('Home', '/', context),
            _MobileNavItem('Services', '/services', context),
            _MobileNavItem('Contact', '/contact', context),
            _MobileNavItem('Privacy', '/privacy', context),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String route;
  
  const _NavLink(this.label, this.route);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isActive = currentRoute == widget.route;
    
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => context.go(widget.route),
        child: Text(
          widget.label,
          style: GoogleFonts.ibmPlexSans(
            color: isActive ? AppColors.accent : 
                   isHovered ? AppColors.accentLight : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final String route;
  final BuildContext parentContext;
  
  const _MobileNavItem(this.label, this.route, this.parentContext);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.ibmPlexSans(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        parentContext.go(route);
      },
    );
  }
}
```

---

### 5. Create lib/widgets/footer_widget.dart

```dart
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
        Row(
          children: [
            Text(
              '<',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ThisByte',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/>',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'The Full Stack and Beneath',
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
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
```

---

Continue to next message for screens implementation...

