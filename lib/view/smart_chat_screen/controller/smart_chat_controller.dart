import 'package:get/get.dart';
import 'package:iuvo/services/open_ai_services.dart';
import 'package:iuvo/view/smart_chat_screen/model/prompt_model.dart';

class SmartChatController extends GetxController {
  RxList<PromptModel>? _messagesList = <PromptModel>[].obs;
  final OpenAIService openAIService = OpenAIService();
  List<PromptModel>? get messagesList => _messagesList!.value;
  
  void sendMessage(String msg) async {
    final chatgptData = await openAIService.chatGPTAPI(msg);
    _messagesList!.addAll(chatgptData);

    print(_messagesList!.length);
  }
}
