import 'package:lomo/data/api/models/user.dart';

class SearchUserAdvanceResponse {
  SearchUserAdvanceResponse(
      {this.skip = 0, this.isFirst = true, this.list = const []});
  int skip;
  bool isFirst;
  List<User> list;

  factory SearchUserAdvanceResponse.fromJson(Map<String, dynamic> json) =>
      SearchUserAdvanceResponse(
        skip: json["skip"],
        isFirst: json["isFirst"],
        list: json["list"] == null
            ? []
            : List<User>.from(json["list"].map((x) => User.fromJson(x)))
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
