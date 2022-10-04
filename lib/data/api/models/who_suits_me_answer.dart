import 'package:lomo/util/constants.dart';

class WhoSuitsMeAnswer {
  WhoSuitsMeAnswer({
    this.id,
    this.name,
    this.isTrue = false,
    this.isSelected = false,
  });

  String? id;
  String? name;
  bool isTrue;
  bool isSelected;
  WhoSuitsMeAnswerStatus status = WhoSuitsMeAnswerStatus.init;

  factory WhoSuitsMeAnswer.fromJson(Map<String, dynamic> json) => WhoSuitsMeAnswer(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        isTrue: json["isTrue"] ?? false,
        isSelected: json["isSelected"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isTrue": isTrue,
        "isSelected": isSelected,
      };

  @override
  String toString() {
    return 'WhoSuitsMeAnswer{id: $id, name: $name, status: $status}';
  }
}
