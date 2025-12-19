# ThisByte Website - Complete Deployment Guide

## Quick Start Checklist

- [ ] Flutter installed and working
- [ ] Node.js and npm installed (for Firebase CLI)
- [ ] Firebase CLI installed globally
- [ ] Created Firebase project: thisbyte-com

---

## Complete Step-by-Step Deployment

### PHASE 1: Project Setup

```bash
# 1. Create Flutter project
flutter create thisbyte_website
cd thisbyte_website

# 2. Enable web support
flutter config --enable-web

# 3. Create directory structure
mkdir -p lib/screens lib/widgets lib/utils
```

### PHASE 2: Add Dependencies

Edit `pubspec.yaml` and add these dependencies under the `dependencies:` section:

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

Then run:
```bash
flutter pub get
```

### PHASE 3: Create All Flutter Files

Copy code from the provided instruction documents into these files:

1. **lib/utils/colors.dart** - Color scheme
2. **lib/utils/firebase_service.dart** - Firebase service
3. **lib/widgets/app_bar_widget.dart** - Navigation bar
4. **lib/widgets/footer_widget.dart** - Footer
5. **lib/main.dart** - Main app entry
6. **lib/screens/home_screen.dart** - Home page
7. **lib/screens/services_screen.dart** - Services page
8. **lib/screens/contact_screen.dart** - Contact form
9. **lib/screens/privacy_screen.dart** - Privacy policy

### PHASE 4: Firebase Setup

```bash
# 1. Install Firebase CLI
npm install -g firebase-tools

# 2. Login to Firebase
firebase login

# 3. Initialize Firebase in your project
firebase init

# During initialization, select:
# - Hosting
# - Functions
# 
# Project setup:
# - Create a new project called: thisbyte-com
#
# Hosting setup:
# - Public directory: build/web
# - Configure as single-page app: Yes
# - Set up automatic builds: No
#
# Functions setup:
# - Language: TypeScript
# - ESLint: Yes
# - Install dependencies: Yes
```

### PHASE 5: Configure FlutterFire

```bash
# 1. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Configure FlutterFire for your project
flutterfire configure --project=thisbyte-com

# This will create firebase_options.dart automatically
```

### PHASE 6: Setup Firebase Functions

```bash
# 1. Navigate to functions directory
cd functions

# 2. Install nodemailer
npm install nodemailer
npm install --save-dev @types/nodemailer

# 3. Replace functions/src/index.ts with the provided code

# 4. Configure email settings in index.ts:
#    - EMAIL_USER: your Gmail address
#    - EMAIL_PASS: Gmail app password (see instructions below)
#    - RECIPIENT_EMAIL: where you want form submissions sent

# 5. Return to project root
cd ..
```

#### Setting up Gmail App Password:

1. Go to Google Account: https://myaccount.google.com/
2. Navigate to Security
3. Enable 2-Step Verification if not already enabled
4. Go to "App passwords"
5. Generate a new app password for "Mail"
6. Copy the 16-character password
7. Use this in your `index.ts` file as `EMAIL_PASS`

### PHASE 7: Build and Test Locally

```bash
# Test locally in Chrome
flutter run -d chrome

# If everything looks good, build for production
flutter build web --release
```

### PHASE 8: Deploy to Firebase

```bash
# 1. Deploy hosting
firebase deploy --only hosting

# 2. Deploy functions
firebase deploy --only functions

# 3. Or deploy everything at once
firebase deploy
```

### PHASE 9: View Your Live Site

```bash
# Open your deployed site
firebase open hosting:site

# Your site will be at: https://thisbyte-com.web.app
# Or your custom domain if configured
```

---

## Custom Domain Setup (Optional)

### Connect thisbyte.com to Firebase Hosting:

```bash
# 1. Add custom domain in Firebase Console
# Go to: Firebase Console > Hosting > Add custom domain

# 2. Follow Firebase's DNS configuration instructions
# You'll need to add these DNS records to your domain registrar:

# A Records (point to Firebase IPs):
# Host: @
# Value: Get from Firebase Console

# TXT Record (for verification):
# Host: @
# Value: Get from Firebase Console
```

---

## Troubleshooting

### Common Issues:

**Issue: Flutter web not working**
```bash
flutter config --enable-web
flutter clean
flutter pub get
```

**Issue: Firebase functions failing**
```bash
cd functions
npm install
firebase deploy --only functions
```

**Issue: Email not sending**
- Check Gmail app password is correct
- Verify EMAIL_USER and RECIPIENT_EMAIL are set
- Check Firebase Functions logs: `firebase functions:log`

**Issue: Build errors**
```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## Maintenance Commands

```bash
# View Firebase hosting logs
firebase hosting:log

# View functions logs
firebase functions:log

# Redeploy after code changes
flutter build web --release
firebase deploy

# Test locally before deploying
flutter run -d chrome
```

---

## Project Structure Overview

```
thisbyte_website/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Auto-generated by FlutterFire
│   ├── screens/
│   │   ├── home_screen.dart         # Home page
│   │   ├── services_screen.dart     # Services page
│   │   ├── contact_screen.dart      # Contact form
│   │   └── privacy_screen.dart      # Privacy policy
│   ├── widgets/
│   │   ├── app_bar_widget.dart      # Navigation bar
│   │   └── footer_widget.dart       # Footer
│   └── utils/
│       ├── colors.dart              # Color scheme
│       └── firebase_service.dart    # Firebase integration
├── functions/
│   └── src/
│       └── index.ts                 # Contact form email handler
├── build/
│   └── web/                         # Built website files
├── firebase.json                    # Firebase configuration
└── pubspec.yaml                     # Flutter dependencies
```

---

## Next Steps

1. ✅ Deploy website to Firebase
2. ✅ Test contact form functionality
3. ✅ Verify all pages work correctly
4. Configure custom domain (thisbyte.com)
5. Set up SSL certificate (automatic with Firebase)
6. Add Google Analytics (optional)
7. Set up Firebase monitoring (optional)

---

## Support & Resources

- Flutter Web: https://docs.flutter.dev/platform-integration/web
- Firebase Hosting: https://firebase.google.com/docs/hosting
- Firebase Functions: https://firebase.google.com/docs/functions
- FlutterFire: https://firebase.flutter.dev/

