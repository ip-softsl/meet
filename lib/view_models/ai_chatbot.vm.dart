import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:velocity_x/velocity_x.dart';
import 'base.view_model.dart';

class AIChatBotViewModel extends MyBaseViewModel {
  AIChatBotViewModel(BuildContext context) {
    viewContext = context;
  }

  List<Map<String, String>> messages = [];
  String conversionId = "";
  ScrollController chatMessagesScrollController = ScrollController();
  OpenAI? openAI;
  final TextEditingController textEditingController = TextEditingController();

  @override
  initialise() async {
    openAI = await ApiService().getOpenAI();
  }

  //
  sendMessage() async {
    //validate input
    final generateInput = textEditingController.text;
    if (generateInput.isEmpty) {
      viewContext!.showToast(
        msg: "Please enter message".tr(),
        textColor: Colors.white,
        bgColor: Colors.red,
      );
      return;
    }
    //if word is les than 3 characters
    if (generateInput.length < 2) {
      viewContext!.showToast(
        msg: "Please enter more than 2 characters to send message".tr(),
        textColor: Colors.white,
        bgColor: Colors.red,
      );
      return;
    }

    //
    messages.add({
      "role": "user",
      "content": generateInput,
    });
    textEditingController.clear();
    //scroll to bottom
    scrollToBottom();

    //
    setBusy(true);

    try {
      //generate chat
      final request = ChatCompleteText(
        messages: messages,
        maxToken: 200,
        model: ChatModel.gptTurbo,
      );

      final response = await openAI?.onChatCompletion(request: request);
      conversionId = response?.conversionId ?? "";
      for (var element in response?.choices ?? []) {
        if (element.message == null) continue;
        messages.add({
          "role": "assistant",
          "content": element.message!.content,
        });
        //
        scrollToBottom();
      }
    } catch (error) {
      viewContext!.showToast(msg: error.toString());
    }
    setBusy(false);
  }

  //
  scrollToBottom() async {
    //download image from link
    try {
      chatMessagesScrollController
          .jumpTo(chatMessagesScrollController.position.maxScrollExtent);
      //
      chatMessagesScrollController.animateTo(
        chatMessagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (error) {
      viewContext!.showToast(msg: error.toString());
    }
  }
}
