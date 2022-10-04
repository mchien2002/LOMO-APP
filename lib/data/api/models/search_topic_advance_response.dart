import 'package:lomo/data/api/models/topic_item.dart';

class SearchTopicAdvanceResponse {
  SearchTopicAdvanceResponse(
      {this.skip = 0, this.isFirst = true, this.list = const []});
  int skip;
  bool isFirst;
  List<TopictItem> list;

  factory SearchTopicAdvanceResponse.fromJson(Map<String, dynamic> json) =>
      SearchTopicAdvanceResponse(
        skip: json["skip"],
        isFirst: json["isFirst"],
        list: json["list"] == null
            ? []
            : List<TopictItem>.from(
                json["list"].map((x) => TopictItem.fromJson(x))).toList(),
      );

  Map<String, dynamic> toJson() => {
        "skip": skip,
        "isFirst": isFirst,
        "list": list.isNotEmpty == true
            ? List<dynamic>.from(list.map((x) => x.toJson()))
            : []
      };
}
