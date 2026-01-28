import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';

class GeminiService {
  final String _apiKey;
  final String _modelName;

  GeminiService(this._apiKey, {String modelName = 'gemini-2.5-flash'})
      : _modelName = modelName;

  Future<List<String>> breakDownTask(Session session, String taskDescription) async {
    try {
      final model = GenerativeModel(
        model: _modelName,
        apiKey: _apiKey,
      );

      final prompt = 'Break down the following task into 3-5 subtasks suitable for Pomodoro sessions. '
          'Return ONLY a raw JSON array of strings. Do not include markdown formatting like ```json ... ```. '
          'Task: "$taskDescription"';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      final responseText = response.text;
      if (responseText == null) {
        throw Exception('Empty response from Gemini');
      }

      session.log('[GeminiService] Raw Response: $responseText');

      final cleanJson = responseText
          .replaceAll(RegExp(r'^```json\s*'), '')
          .replaceAll(RegExp(r'\s*```$'), '')
          .trim();

      final List<dynamic> parsed = jsonDecode(cleanJson);
      return parsed.map((e) => e.toString()).toList();

    } catch (e, stackTrace) {
      session.log(
        'Gemini API Error',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      // Fallback
      return [];
    }
  }
}
