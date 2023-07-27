// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/services/auth.service.dart';

class Meeting {
  int? id;
  String? meetingID;
  String? meetingTitle;
  String? banner;
  String? created_at;
  bool isPublic;
  User? user;

  Meeting({
    this.id,
    this.meetingID,
    this.meetingTitle,
    this.banner,
    this.created_at,
    this.isPublic = true,
    this.user,
  });

  factory Meeting.fromJSON(Map<String, dynamic>? json) {
    final meeting = Meeting();
    if (json == null) {
      return meeting;
    }
    meeting.id = json.containsKey("id") ? json["id"] : null;
    meeting.meetingID = json["meeting_id"] ?? "";
    meeting.meetingTitle = json["meeting_title"] ?? "";
    meeting.banner = json["banner"] ?? "";
    meeting.isPublic = (json["public"] != null && json["public"] is bool)
        ? json["public"]
        : int.parse((json["public"] ?? "1").toString()) == 1;
    meeting.created_at = json["created_at"];
    meeting.user = json["user"] != null ? User.fromJson(json["user"]) : null;
    return meeting;
  }

  String get meetingDate {
    final formattedDateTime = DateTime.parse(created_at!);
    final dateClean =
        DateFormat("dd MMM, yyy | hh:mm a", translator.activeLanguageCode)
            .format(formattedDateTime);
    return dateClean.toString();
  }

  bool get mine {
    if (AuthServices.authenticated()) {
      return AuthServices.currentUser?.id == user?.id;
    } else {
      return false;
    }
  }
}
