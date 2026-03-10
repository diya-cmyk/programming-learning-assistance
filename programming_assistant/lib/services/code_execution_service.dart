import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CodeExecutionService {
  static const String _baseUrl = "https://ce.judge0.com";

  static const Map<String, int> languageIds = {
    'python': 71,
    'cpp': 54,
    'java': 62,
    'javascript': 63,
    'c': 50,
  };

  static Future<String> executeCode(String code, String language) async {
    final langId = languageIds[language.toLowerCase()] ?? 71;

    final submitResponse = await http.post(
      Uri.parse("$_baseUrl/submissions?base64_encoded=false&wait=false"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"source_code": code, "language_id": langId}),
    );

    if (submitResponse.statusCode != 201) {
      return "Submission failed.";
    }

    final token = jsonDecode(submitResponse.body)["token"];

    await Future.delayed(const Duration(seconds: 2));

    final resultResponse = await http.get(
      Uri.parse("$_baseUrl/submissions/$token?base64_encoded=false"),
    );

    final data = jsonDecode(resultResponse.body);

    if (data["stdout"] != null) {
      return data["stdout"];
    }

    if (data["stderr"] != null) {
      return "Error: ${data["stderr"]}";
    }

    if (data["compile_output"] != null) {
      return "Compile Error: ${data["compile_output"]}";
    }

    return "No output.";
  }
}
