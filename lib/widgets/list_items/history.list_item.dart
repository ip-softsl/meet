import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/models/meeting.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem(this.meeting, this.onCallPressed, {Key? key})
      : super(key: key);

  final Meeting meeting;
  final Function onCallPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            //banner
            CachedNetworkImage(
              imageUrl: meeting.banner!,
              fit: BoxFit.cover,
              errorWidget: (context, url, progress) {
                return Image.asset(
                  AppImages.onboarding1,
                  fit: BoxFit.fill,
                );
              },
            ).w(context.percentWidth * 20).h(110),
            //details
            VStack(
              [
                //
                VStack(
                  [
                    meeting.meetingTitle!.text.make(),
                    meeting.meetingID!.text.lg.semiBold.make(),
                    meeting.meetingDate.text.make(),
                    meeting.isPublic
                        ? "Public".tr().text.purple500.make()
                        : "Private".tr().text.red500.make(),
                  ],
                ),
              ],
              crossAlignment: CrossAxisAlignment.start,
              alignment: MainAxisAlignment.center,
            ).p(12).expand(),
          ],
        ),

        //
        //rejoin
        ElevatedButton(
          onPressed: () => onCallPressed(),
          child: HStack(
            [
              const Icon(
                LineIcons.video,
                size: 18,
              ),
              8.widthBox,
              "Rejoin".tr().text.sm.make(),
            ],
          ),
        ).wFull(context).p(5),
      ],
    )
        .box
        .margin(const EdgeInsets.all(5))
        .color(context.theme.cardColor)
        .roundedSM
        .clip(Clip.antiAlias)
        .outerShadow
        .make();
  }
}
