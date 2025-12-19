# Logo Integration Updates

## Your Logo
The uploaded logo features:
- Isometric layered infrastructure design
- Cyan circuit traces (#00D4FF approximate)
- Dark background
- "ThisByte, LLC" text
- "The Full Stack and Beneath" tagline

## Color Scheme Updates

Update `lib/utils/colors.dart` to match your logo's cyan:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Dark slate backgrounds (matching logo)
  static const primary = Color(0xFF1E293B);      // Slate 800
  static const secondary = Color(0xFF334155);    // Slate 700
  static const background = Color(0xFF0F172A);   // Slate 900 (matches logo bg)
  static const surface = Color(0xFF1E293B);      // Slate 800
  
  // Logo cyan accent - UPDATE THIS
  static const accent = Color(0xFF00D4FF);       // Bright cyan from logo
  static const accentLight = Color(0xFF33DDFF);  // Lighter cyan
  
  // Text colors
  static const textPrimary = Color(0xFFF1F5F9);  // Slate 100
  static const textSecondary = Color(0xFF94A3B8); // Slate 400
  static const textMuted = Color(0xFF64748B);    // Slate 500
  
  // Borders and dividers
  static const border = Color(0xFF334155);       // Slate 700
  static const divider = Color(0xFF1E293B);      // Slate 800
}
```

## Adding Logo to Flutter Project

### Step 1: Add logo to assets

```bash
# Create assets directory
mkdir -p assets/images

# Copy your logo
cp thisbyte-logo.png assets/images/thisbyte-logo.png
```

### Step 2: Update pubspec.yaml

Add this section to `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/thisbyte-logo.png
```

### Step 3: Update AppBarWidget

Replace the text logo in `lib/widgets/app_bar_widget.dart`:

```dart
// REPLACE the Logo section in AppBarWidget with:

// Logo
InkWell(
  onTap: () => context.go('/'),
  child: Image.asset(
    'assets/images/thisbyte-logo.png',
    height: 40, // Adjust size as needed
    fit: BoxFit.contain,
  ),
),
```

### Step 4: Update FooterWidget

Replace the text logo in `lib/widgets/footer_widget.dart`:

```dart
// REPLACE _FooterSection widget with:

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/thisbyte-logo.png',
          height: 50, // Adjust size as needed
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
```

## Alternative: Logo with Transparent Background

If you want to create a version with just the icon (no text):

### Option A: Full Logo (as uploaded)
- Use the full logo with text in header
- Keeps branding consistent
- Recommended approach

### Option B: Icon Only + Text Separately
If you have a version with just the isometric icon:
```dart
Row(
  children: [
    Image.asset('assets/images/thisbyte-icon.png', height: 40),
    SizedBox(width: 12),
    Text(
      'ThisByte',
      style: GoogleFonts.jetBrainsMono(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
)
```

## Logo Size Recommendations

For web display:
- **Header**: 40-50px height
- **Footer**: 50-60px height  
- **Favicon**: Create 512x512px version

## Creating Favicon

```bash
# Use ImageMagick or online tool to create favicon
# From your logo, create a 512x512 square version

# Then add to web/icons/ directory:
# - Icon-192.png (192x192)
# - Icon-512.png (512x512)
```

Update `web/manifest.json`:
```json
{
  "name": "ThisByte, LLC",
  "short_name": "ThisByte",
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

## Updated Deployment Steps

Add these steps to your deployment process:

1. Copy logo to `assets/images/`
2. Update `pubspec.yaml` with assets
3. Update `colors.dart` with logo cyan
4. Update `app_bar_widget.dart` to use image
5. Update `footer_widget.dart` to use image
6. Run `flutter pub get`
7. Test with `flutter run -d chrome`
8. Build and deploy

## Quick Integration Commands

```bash
# From project root
mkdir -p assets/images
cp ~/Downloads/thisbyte-logo.png assets/images/

# Update pubspec.yaml (manually add assets section)
# Update colors.dart (manually change accent color)
# Update widget files (manually replace text logo)

flutter pub get
flutter run -d chrome  # Test it
flutter build web --release
firebase deploy
```

