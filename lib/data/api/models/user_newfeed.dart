import 'package:lomo/data/api/models/new_feed.dart';

class UserNewFeed {
  UserNewFeed({this.date, this.data});
  String? date;
  List<NewFeed>? data;

  factory UserNewFeed.fromJson(Map<String, dynamic> json) {
    final userNewFeed = UserNewFeed(
      date: json["date"],
      data: json["data"] != null
          ? List<NewFeed>.from(json["data"].map((x) => NewFeed.fromJson(x)))
          : [],
    );
    return userNewFeed;
  }
  Map<String, dynamic> toJson() => {
        "date": date,
        "data": data?.isNotEmpty == true
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };
}
