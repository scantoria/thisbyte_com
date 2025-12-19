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
