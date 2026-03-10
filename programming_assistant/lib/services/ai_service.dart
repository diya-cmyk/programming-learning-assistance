import 'dart:convert';
import 'package:http/http.dart' as http;

enum AIMode { chat, explain, debug, generate }

class AIService {
  static const String _apiKey = "Your Key";

  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

  static String _systemPromptFor(AIMode mode) {
    switch (mode) {
      case AIMode.chat:
        return "You are a beginner friendly programming tutor. Explain simply.";
      case AIMode.explain:
        return "Explain the given code line by line.";
      case AIMode.debug:
        return "Find errors in the code and explain the fix.";
      case AIMode.generate:
        return "Generate beginner friendly code with comments.";
    }
  }

  static Future<String> sendMessage(
    String userMessage, {
    AIMode mode = AIMode.chat,
  }) async {
    final prompt = "${_systemPromptFor(mode)}\n\n$userMessage";

    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Network error: $e";
    }
  }
}
