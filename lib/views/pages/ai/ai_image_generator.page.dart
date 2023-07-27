import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/view_models/ai_image_generator.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_list_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AIImageGeneratorPage extends StatefulWidget {
  const AIImageGeneratorPage({super.key});
  @override
  _AIImageGeneratorPageState createState() => _AIImageGeneratorPageState();
}

class _AIImageGeneratorPageState extends State<AIImageGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AIImageGeneratorViewModel>.reactive(
      viewModelBuilder: () => AIImageGeneratorViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          title: "AI Image Generator".tr(),
          showAppBar: true,
          showLeadingAction: true,
          body: VStack(
            [
              //images listview
              Expanded(
                child: CustomListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  isLoading: model.isBusy,
                  itemBuilder: (context, index) {
                    final imageUrl = model.images[index] ?? "";
                    return VStack(
                      [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          progressIndicatorBuilder: (context, url, progress) {
                            return const BusyIndicator();
                          },
                          errorWidget: (context, imageUrl, progress) {
                            return Image.asset(
                              AppImages.appLogo,
                            );
                          },
                          fit: BoxFit.cover,
                          height: context.percentHeight * 25,
                          width: double.infinity,
                        ).cornerRadius(10),
                        //
                        CustomButton(
                          onPressed: () {
                            model.downloadImage(imageUrl);
                          },
                          child: const Icon(
                            LineIcons.download,
                            color: Colors.white,
                          ),
                        ),
                        5.heightBox,
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => 10.heightBox,
                  dataSet: model.images,
                ),
              ),
              10.heightBox,

              //input and send button
              VStack(
                [
                  //input
                  TextField(
                    minLines: 2,
                    maxLines: 4,
                    controller: model.textEditingController,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Enter text here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  10.heightBox,
                  //send button
                  HStack(
                    [
                      //options bottomsheet
                      CustomButton(
                        child: const Icon(LineIcons.cog),
                        onPressed: model.openAISettings,
                      ).w(60).h(50),
                      10.widthBox,
                      //
                      CustomButton(
                        loading: model.isBusy,
                        onPressed: model.generateImage,
                        child: HStack(
                          [
                            const Icon(LineIcons.magic),
                            5.widthBox,
                            "Generate".tr().text.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                          alignment: MainAxisAlignment.center,
                        ),
                      ).wFull(context).h(50).expand(),
                    ],
                  ),
                ],
              ).p(12).box.color(context.colors.background).shadowXl.make(),
            ],
          ),
        );
      },
    );
  }
}
