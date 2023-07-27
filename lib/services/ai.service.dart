import 'dart:convert';
import 'package:meetup/services/auth.service.dart';
import 'package:singleton/singleton.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ApiService {
  //ENUM for pref AI_SETTINGS
  static String aiSettings = "ai_settings";

  /// Factory method that reuse same instance automatically
  factory ApiService() => Singleton.lazy(() => ApiService._());

  /// Private constructor
  ApiService._();

  //save ai app settings json
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    return await AuthServices.prefs!
        .setString(aiSettings, jsonEncode(settings));
  }

  //fetch ai app settings json
  Map<String, dynamic> getAppSettings() {
    return jsonDecode(AuthServices.prefs!.getString(aiSettings) ?? "{}");
  }

  //getters
  bool get isAIChatEnabled {
    return getAppSettings()["chatbot"] ?? false;
  }

  bool get isAIImageGenerationEnabled {
    return getAppSettings()["image_generation"] ?? false;
  }

  String get openAIApiKey {
    return getAppSettings()["api_key"] ?? "";
  }

  //
  Future<OpenAI> getOpenAI() async {
    final openAI = OpenAI.instance.build(
      token: openAIApiKey,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
      enableLog: true,
    );
    return openAI;
  }
}
