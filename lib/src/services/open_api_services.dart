import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pintu/src/utils/secrets.dart';
class AIServices{
final List<Map<String, String>> messages = [];

Future<String> checkImageOrNot(String prompt) async {
  try {
    final res = await http.post(
      Uri.parse(
        'https://api.openai.com/v1/chat/completions',
      ),
      headers: {
        'Content-Type': 'applicaton/json',
        'Authorization': 'Bearer $OPENAIAPIKEY'
      },
      body: jsonEncode(
        {
          'model': 'gpt-3.5-turbo',
          "messages": [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        },
      ),
    );
    print(res.body);

    if (res.statusCode == 200) {
      String content = jsonDecode(res.body)['choices'][0]['message']['content'];
      content = content.trim();

      switch (content) {
        case 'Yes':
        case 'yes':
        case 'Yes.':
        case 'yes.':
          final res = await dallEAI(prompt);
          return res;
        default:
          final res = await chatGPT(prompt);
          return res;
      }
    }
    return 'An internal error occurred';
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

Future<String> chatGPT(String prompt) async {
  messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAIAPIKEY',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
}

Future<String> dallEAI(String prompt) async {
  return '';
}

}
