import 'dart:convert';

String extractErrorMessage(String error) {
  try {
    
    final jsonStart = error.indexOf('{');
    if (jsonStart != -1) {
      final jsonString = error.substring(jsonStart);
      final decoded = jsonDecode(jsonString);

      if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
        return decoded['message'];
      }
    }
  } catch (_) {
    
  }

  return error; 
}
