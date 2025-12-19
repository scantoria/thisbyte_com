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
