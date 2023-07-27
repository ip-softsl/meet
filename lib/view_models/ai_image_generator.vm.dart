import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:meetup/views/pages/ai/widgets/ai_image_generator_settings.bottomsheet.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'base.view_model.dart';

class AIImageGeneratorViewModel extends MyBaseViewModel {
  AIImageGeneratorViewModel(BuildContext context) {
    viewContext = context;
  }

  List<dynamic> images = [];
  //settings
  int numberOfImages = 2;
  ImageSize imageSize = ImageSize.size256;

  final TextEditingController textEditingController = TextEditingController();

  //open bottom sheet
  openAISettings() async {
    showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AIImageGeneratorSettingsBottomsheet(viewModel: this);
      },
    );
  }

  resetAISettings() {
    numberOfImages = 2;
    imageSize = ImageSize.size256;
    notifyListeners();
  }

  //
  generateImage() async {
    //validate input
    final generateInput = textEditingController.text;
    if (generateInput.isEmpty) {
      viewContext!.showToast(msg: "Please enter text to generate image".tr());
      return;
    }
    //if word is les than 3 characters
    if (generateInput.length < 3) {
      viewContext!.showToast(
          msg: "Please enter more than 3 characters to generate image".tr());
      return;
    }

    //
    setBusy(true);

    try {
      //generate image
      final openAI = await ApiService().getOpenAI();
      String prompt = generateInput;
      final request = GenerateImage(
        prompt,
        numberOfImages,
        size: imageSize,
        responseFormat: Format.url,
      );
      final response = await openAI.generateImage(request);
      //if response is successful
      if (response!.data != null) {
        //clear images
        images.clear();
        //
        for (var element in response.data!) {
          images.add(element!.url);
        }

        //clear input
        textEditingController.clear();
        //notify listeners
        notifyListeners();
      } else {
        viewContext!.showToast(
          bgColor: Colors.red,
          textColor: Colors.white,
          msg: "Failed to generate image".tr(),
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      viewContext!.showToast(
        bgColor: Colors.red,
        textColor: Colors.white,
        msg: error.toString(),
        position: VxToastPosition.top,
      );
    }
    setBusy(false);
  }

  //
  downloadImage(link) async {
    //download image from link
    try {
      launchUrlString(link);
    } catch (error) {
      viewContext!.showToast(
        bgColor: Colors.red,
        textColor: Colors.white,
        msg: error.toString(),
        position: VxToastPosition.top,
      );
    }
  }
}
