import 'package:lomo/data/api/models/new_feed.dart';

class SearchPostAdvanceResponse {
  SearchPostAdvanceResponse(
      {this.skip = 0, this.isFirst = true, this.list = const []});
  int skip;
  bool isFirst;
  List<NewFeed> list;

  factory SearchPostAdvanceResponse.fromJson(Map<String, dynamic> json) =>
      SearchPostAdvanceResponse(
        skip: json["skip"],
        isFirst: json["isFirst"],
        list: json["list"] == null
            ? []
            : List<NewFeed>.from(json["list"].map((x) => NewFeed.fromJson(x)))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        "skip": skip,
        "isFirst": isFirst,
        "list": list.isNotEmpty == true
            ? List<dynamic>.from(list.map((x) => x.toJson()))
            : []
      };
}
