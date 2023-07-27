import 'package:flutter/material.dart';
import 'package:meetup/view_models/onboarding.vm.dart';
import 'package:stacked/stacked.dart';
import 'package:easy_onboard/easy_onboard.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.nonReactive(
      viewModelBuilder: () => OnboardingViewModel(context),
      builder: (context, model, child) {
        return Onboard(
          primaryColor: const Color(0xff6C63FF),
          onboardPages: model.onBoardData.map((e) {
            return OnboardModel(
              imagePath: e.imgUrl!,
              title: e.title ?? "",
              subTitle: e.description ?? "",
            );
          }).toList(),
          lastText: 'Done',
          nextText: 'Next',
          skipText: 'Skip',
          skipButtonPressed: model.onDonePressed,
        );
      },
    );
  }
}
