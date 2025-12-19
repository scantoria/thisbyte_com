# REVISED: Colors & Widgets (Logo-Matched)

## Use This Instead of Original colors.dart

This version matches your logo's cyan accent color.

### Updated lib/utils/colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Dark backgrounds matching your logo
  static const primary = Color(0xFF1A2332);      // Darker slate (logo bg)
  static const secondary = Color(0xFF243447);    // Medium slate
  static const background = Color(0xFF0F1419);   // Very dark (logo bg)
  static const surface = Color(0xFF1A2332);      // Card surfaces
  
  // Logo cyan accent - EXACT match to your logo
  static const accent = Color(0xFF00D4FF);       // Bright cyan from logo
  static const accentLight = Color(0xFF33DDFF);  // Lighter cyan for hovers
  static const accentDark = Color(0xFF00A8CC);   // Darker cyan for depth
  
  // Text colors
  static const textPrimary = Color(0xFFF1F5F9);  // White-ish
  static const textSecondary = Color(0xFF94A3B8); // Gray
  static const textMuted = Color(0xFF64748B);    // Muted gray
  
  // Borders and dividers
  static const border = Color(0xFF2D3748);       // Subtle borders
  static const divider = Color(0xFF1A2332);      // Dividers
}
```

---

## Updated AppBarWidget with Logo Image

Replace your `lib/widgets/app_bar_widget.dart` with this version:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

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
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo - Using actual logo image
              InkWell(
                onTap: () => context.go('/'),
                child: Image.asset(
                  'assets/images/thisbyte-logo.png',
                  height: 45,
                  fit: BoxFit.contain,
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

## Updated FooterWidget with Logo Image

Replace your `lib/widgets/footer_widget.dart` with this version:

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
```

---

## Don't Forget: Update pubspec.yaml

Add this to your `pubspec.yaml` file:

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/thisbyte-logo.png
```

---

## Summary of Changes

✅ **colors.dart** - Cyan accent matching your logo (#00D4FF)
✅ **app_bar_widget.dart** - Uses actual logo image instead of text
✅ **footer_widget.dart** - Uses actual logo image instead of text
✅ **pubspec.yaml** - Declares logo asset

These files replace the originals - use these versions for a perfect logo match!

