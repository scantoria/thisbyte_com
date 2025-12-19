# Google Analytics Integration for ThisByte

## Why Google Analytics + Firebase Analytics Together?

**Firebase Analytics:** 
- Mobile app tracking
- User behavior in Flutter app
- Event tracking (button clicks, form submissions)
- Integrated with other Firebase services

**Google Analytics 4 (GA4):**
- Web traffic analysis
- Acquisition channels (how people find you)
- Conversion tracking
- E-commerce tracking (future)
- Better business intelligence dashboards
- Integration with Google Ads (if you run ads later)

**Best Practice:** Use BOTH - Firebase Analytics is automatically linked to Google Analytics 4.

---

## Part 1: Set Up Google Analytics 4

### Step 1: Create GA4 Property

1. Go to https://analytics.google.com/
2. Click "Admin" (bottom left gear icon)
3. Click "Create Property"
4. Enter property details:
   - **Property name:** ThisByte Website
   - **Reporting time zone:** America/New_York (or your timezone)
   - **Currency:** USD
5. Click "Next"
6. Fill out business details:
   - **Industry:** Computer and Electronics
   - **Business size:** Small (1-10 employees)
7. Select objectives:
   - ✅ Generate leads
   - ✅ Examine user behavior
8. Click "Create"

### Step 2: Set Up Web Data Stream

1. In the new property, click "Data Streams"
2. Click "Add stream" → "Web"
3. Enter website details:
   - **Website URL:** https://thisbyte.com
   - **Stream name:** ThisByte Website
4. **Enable Enhanced Measurement** (toggle ON) - this auto-tracks:
   - Page views
   - Scrolls
   - Outbound clicks
   - Site search
   - Video engagement
   - File downloads
5. Click "Create stream"
6. **Save your Measurement ID** (looks like G-XXXXXXXXXX)

---

## Part 2: Add GA4 to Flutter Web

### Option A: Add via web/index.html (Recommended for Web)

Add this to your `web/index.html` just before closing `</head>` tag:

```html
<!-- Google Analytics 4 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX', {
    'send_page_view': false  // We'll handle this in Flutter
  });
</script>
```

Replace `G-XXXXXXXXXX` with your actual Measurement ID.

### Option B: Flutter Package Integration

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_analytics: ^10.7.4
  firebase_analytics_web: ^0.5.5+7
```

Run: `flutter pub get`

---

## Part 3: Create Analytics Service

Create `lib/services/analytics_service.dart`:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:html' as html;

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Initialize analytics
  static Future<void> init() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  // Track page views
  static Future<void> logPageView(String pageName, String pageClass) async {
    await _analytics.logScreenView(
      screenName: pageName,
      screenClass: pageClass,
    );
    
    // Also send to GA4 via gtag
    _sendToGtag('page_view', {
      'page_title': pageName,
      'page_location': html.window.location.href,
      'page_path': html.window.location.pathname,
    });
  }

  // Track contact form submission
  static Future<void> logContactFormSubmit({
    required String name,
    required String email,
    required String company,
  }) async {
    await _analytics.logEvent(
      name: 'contact_form_submit',
      parameters: {
        'form_name': 'contact',
        'has_company': company.isNotEmpty,
      },
    );
    
    _sendToGtag('generate_lead', {
      'value': 1,
      'currency': 'USD',
    });
  }

  // Track service page interest
  static Future<void> logServiceInterest(String serviceName) async {
    await _analytics.logEvent(
      name: 'service_interest',
      parameters: {
        'service_name': serviceName,
      },
    );
    
    _sendToGtag('view_item', {
      'items': [
        {
          'item_name': serviceName,
          'item_category': 'Service',
        }
      ],
    });
  }

  // Track CTA button clicks
  static Future<void> logCTAClick(String ctaLocation, String ctaText) async {
    await _analytics.logEvent(
      name: 'cta_click',
      parameters: {
        'cta_location': ctaLocation,
        'cta_text': ctaText,
      },
    );
    
    _sendToGtag('select_content', {
      'content_type': 'button',
      'item_id': ctaLocation,
    });
  }

  // Track outbound link clicks
  static Future<void> logOutboundLink(String url, String linkText) async {
    await _analytics.logEvent(
      name: 'outbound_click',
      parameters: {
        'link_url': url,
        'link_text': linkText,
      },
    );
  }

  // Track time on page (call when leaving)
  static Future<void> logTimeOnPage(String pageName, int seconds) async {
    await _analytics.logEvent(
      name: 'time_on_page',
      parameters: {
        'page_name': pageName,
        'duration_seconds': seconds,
      },
    );
  }

  // Set user properties
  static Future<void> setUserProperties({
    String? userType,
    String? industry,
  }) async {
    if (userType != null) {
      await _analytics.setUserProperty(name: 'user_type', value: userType);
    }
    if (industry != null) {
      await _analytics.setUserProperty(name: 'industry', value: industry);
    }
  }

  // Helper to send events to GA4 via gtag
  static void _sendToGtag(String eventName, Map<String, dynamic> parameters) {
    try {
      html.window.callMethod('gtag', ['event', eventName, parameters]);
    } catch (e) {
      print('Error sending to gtag: $e');
    }
  }
}
```

---

## Part 4: Update Main App to Track Navigation

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';  // Add this
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/privacy_screen.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AnalyticsService.init();  // Add this
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        AnalyticsService.logPageView('Home', 'HomeScreen');  // Add this
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        AnalyticsService.logPageView('Services', 'ServicesScreen');  // Add this
        return const ServicesScreen();
      },
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) {
        AnalyticsService.logPageView('Contact', 'ContactScreen');  // Add this
        return const ContactScreen();
      },
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) {
        AnalyticsService.logPageView('Privacy', 'PrivacyScreen');  // Add this
        return const PrivacyScreen();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ThisByte, LLC',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

## Part 5: Update Contact Form to Track Conversions

Update the `_submitForm` method in `lib/screens/contact_screen.dart`:

```dart
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
      // Track successful form submission
      await AnalyticsService.logContactFormSubmit(
        name: _nameController.text,
        email: _emailController.text,
        company: _companyController.text,
      );
      
      _nameController.clear();
      _emailController.clear();
      _companyController.clear();
      _messageController.clear();
    }
  }
}
```

---

## Part 6: Track CTA Button Clicks

Update buttons in your screens to track clicks:

**Example in home_screen.dart:**

```dart
ElevatedButton(
  onPressed: () {
    AnalyticsService.logCTAClick('hero_section', 'Start a Project');
    context.go('/contact');
  },
  style: ElevatedButton.styleFrom(
    // ... styling
  ),
  child: Text('Start a Project'),
),
```

---

## Part 7: Set Up Conversion Goals in GA4

1. Go to GA4 → Admin → Events
2. Click "Create event"
3. Create custom events for key conversions:

**Lead Generation Event:**
- Event name: `generate_lead`
- Already triggered when contact form submits

**Conversion Setup:**
1. Go to Admin → Conversions
2. Click "New conversion event"
3. Add these events as conversions:
   - `contact_form_submit`
   - `generate_lead`

---

## Part 8: Set Up Custom Dimensions

Track additional business context:

1. Go to Admin → Custom Definitions → Custom Dimensions
2. Click "Create custom dimension"

**Recommended Dimensions:**

| Dimension Name | Event Parameter | Scope |
|----------------|-----------------|-------|
| Service Interest | service_name | Event |
| CTA Location | cta_location | Event |
| Has Company | has_company | Event |
| Form Name | form_name | Event |

---

## Part 9: Create Useful Reports

### Key Reports to Set Up:

**1. Acquisition Report**
- Shows how people find you (Google, LinkedIn, Direct, etc.)
- Path: Reports → Acquisition → Traffic acquisition

**2. Engagement Report**
- Shows which pages get most engagement
- Path: Reports → Engagement → Pages and screens

**3. Conversion Report**
- Tracks contact form submissions
- Path: Reports → Conversions

**4. Custom Exploration: Lead Quality**
- Segment: Users who submitted contact form
- Dimensions: Session source, Landing page, Company provided
- Metrics: Conversions, Engagement time

---

## Part 10: Link Firebase to Google Analytics

This should happen automatically, but verify:

1. Go to Firebase Console → Project Settings
2. Click "Integrations" tab
3. Under Google Analytics, click "Manage"
4. Verify your GA4 property is linked

---

## Part 11: Set Up Google Tag Manager (Optional but Recommended)

For more advanced tracking without code changes:

1. Go to https://tagmanager.google.com/
2. Create new account: "ThisByte"
3. Create container: "ThisByte Website" (Web)
4. Get GTM container code
5. Add to `web/index.html`:

```html
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-XXXXXX');</script>
<!-- End Google Tag Manager -->
```

Replace GTM-XXXXXX with your container ID.

---

## Part 12: Testing Your Analytics

### Test in Chrome DevTools:

1. Open DevTools (F12)
2. Go to Network tab
3. Filter: "collect" or "analytics"
4. Navigate your site
5. See analytics requests firing

### Use GA4 DebugView:

1. In GA4, go to Configure → DebugView
2. Add `?debug_mode=true` to your URL
3. See events in real-time

### Use Google Analytics Debugger Extension:

1. Install: https://chrome.google.com/webstore (search "Google Analytics Debugger")
2. Enable extension
3. Open console to see GA events

---

## Part 13: Key Metrics to Monitor

### Weekly Metrics:
- **Sessions:** Total visits
- **Users:** Unique visitors
- **Page views:** Which pages are popular
- **Avg. engagement time:** How long people stay
- **Bounce rate:** % who leave immediately

### Monthly Metrics:
- **Traffic sources:** Where visitors come from
- **Top landing pages:** Entry points
- **Contact form conversions:** Lead generation
- **New vs. returning users:** Growth indicator

### Quarterly Goals:
- **Lead conversion rate:** % of visitors who contact you
- **Source quality:** Which channels bring best leads
- **Content performance:** Which pages drive conversions

---

## Part 14: Privacy Compliance

### Update Privacy Policy

Add to `lib/screens/privacy_screen.dart`:

```dart
_section(
  'Analytics and Cookies',
  'We use Google Analytics to understand how visitors interact with our website. '
  'This service uses cookies to collect anonymous information such as:\n\n'
  '• Pages visited\n'
  '• Time spent on site\n'
  '• Traffic sources\n'
  '• Geographic location (city/country level)\n\n'
  'You can opt out of Google Analytics by installing the Google Analytics Opt-out Browser Add-on.',
),
```

### Cookie Consent (Optional for Now)

Since you're B2B and analytics are essential, you may not need a cookie banner immediately. However, if targeting EU clients:

```dart
// Add to homepage on first visit
if (needsConsent) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cookie Notice'),
      content: Text('We use cookies to analyze site traffic and improve your experience.'),
      actions: [
        TextButton(
          onPressed: () {
            // Set consent
            Navigator.pop(context);
          },
          child: Text('Accept'),
        ),
      ],
    ),
  );
}
```

---

## Part 15: Quick Setup Checklist

**Immediate Setup:**
- [ ] Create GA4 property
- [ ] Get Measurement ID (G-XXXXXXXXXX)
- [ ] Add gtag code to web/index.html
- [ ] Add firebase_analytics to pubspec.yaml
- [ ] Create analytics_service.dart
- [ ] Update main.dart with page tracking
- [ ] Update contact form with conversion tracking

**Configuration:**
- [ ] Set up conversion events in GA4
- [ ] Create custom dimensions
- [ ] Link Firebase to GA4 (verify)
- [ ] Set up Google Search Console
- [ ] Test with DebugView

**Ongoing:**
- [ ] Check analytics weekly
- [ ] Review traffic sources monthly
- [ ] Analyze conversion funnel quarterly
- [ ] Adjust strategy based on data

---

## Expected Results

**Week 1-4:** Baseline data collection
**Month 2-3:** Identify traffic patterns
**Month 3-6:** Optimize based on data

**What to look for:**
- Which pages convert best?
- Which traffic sources bring quality leads?
- Where do people drop off?
- What content resonates?

---

## Integration with Firebase Functions

You can also send analytics from your contact form function:

```typescript
// In functions/src/index.ts
import * as admin from 'firebase-admin';

admin.initializeApp();

export const sendContactEmail = functions.https.onCall(async (data, context) => {
  // ... email sending code ...
  
  // Log to Firebase Analytics
  await admin.analytics().logEvent('contact_form_backend', {
    success: true,
    hasCompany: !!data.company,
  });
  
  return { success: true };
});
```

---

This comprehensive analytics setup gives you full visibility into your website performance and lead generation effectiveness!

