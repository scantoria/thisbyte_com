import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:js_util' as js_util;

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
      'page_location': _getCurrentUrl(),
      'page_path': _getCurrentPath(),
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
      if (js_util.hasProperty(js_util.globalThis, 'gtag')) {
        js_util.callMethod(
          js_util.globalThis,
          'gtag',
          ['event', eventName, js_util.jsify(parameters)]
        );
      }
    } catch (e) {
      print('Error sending to gtag: $e');
    }
  }

  // Helper to get current URL
  static String _getCurrentUrl() {
    try {
      final location = js_util.getProperty(js_util.globalThis, 'location');
      return js_util.getProperty(location, 'href') as String;
    } catch (e) {
      return '';
    }
  }

  // Helper to get current path
  static String _getCurrentPath() {
    try {
      final location = js_util.getProperty(js_util.globalThis, 'location');
      return js_util.getProperty(location, 'pathname') as String;
    } catch (e) {
      return '';
    }
  }
}
