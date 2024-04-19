import 'dart:convert';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iuvo/view/smart_chat_screen/model/prompt_model.dart';

class OpenAIService {
  String openAiSecretKey =
      '0980a644-d996-4711-9ff4-c6375bcb99c2';
  Future<List<PromptModel>> chatGPTAPI(String prompt) async {
    List<PromptModel> _messages = [];
    _messages.add(PromptModel(role: 'user', content: prompt));
    print(_messages.length);
    try {
      final res = await http.post(
        Uri.parse(
          'https://api.caipacity.com/v1/chat/completions'
          ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiSecretKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": _messages,
        }),
      );
      print(res.statusCode);

      if (res.statusCode == 200) {
        print(true);
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        _messages.add(PromptModel(role: 'assistant', content: content));
        print(content);
        return _messages;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
