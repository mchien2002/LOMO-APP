import 'package:lomo/data/api/models/new_feed.dart';

class TimeLineResponse {
  final int skip;
  final List<dynamic>? times;

  final List<NewFeed> list;

  TimeLineResponse(
      {this.skip = 1, this.times = const [], this.list = const []});

  factory TimeLineResponse.fromJson(Map<String, dynamic> json) =>
      TimeLineResponse(
        skip: json["skip"] ?? 1,
        times: json["times"],
        list: json["list"] == null
            ? []
            : List<NewFeed>.from(json["list"].map((x) => NewFeed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "skip": skip,
        "times": times,
        "list": list.isNotEmpty == true
            ? List<dynamic>.from(list.map((x) => x.toJson()))
            : [],
      };
}
