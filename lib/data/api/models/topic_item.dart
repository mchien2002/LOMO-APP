import 'package:hive/hive.dart';
import 'package:lomo/data/api/models/topic_type.dart';
import 'package:lomo/data/database/db_type.dart';
import 'package:lomo/util/constants.dart';

part 'topic_item.g.dart';

@HiveType(typeId: SUBJECT)
class TopictItem extends HiveObject with DiscoveryItemGroup {
  TopictItem(
      {this.id,
      this.name,
      this.image,
      this.numberOfPost = 0,
      this.description,
      this.imageLocal,
      this.types = const []});

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  int? numberOfPost;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? imageLocal;
  bool? isCheck = false;
  List<TopicType> types;
  bool get check => isCheck ?? false;

  factory TopictItem.fromJson(Map<String, dynamic> json) => TopictItem(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        numberOfPost: json["numberOfPost"] ?? 0,
        description: json["description"] ?? "",
        imageLocal: json["imageLocal"],
        types: json["types"] != null
            ? List<TopicType>.from(json["types"].map((x) => TopicType.fromJson(x))).toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name ?? "",
        "image": image ?? "",
        "numberOfPost": numberOfPost ?? 0,
        "description": description ?? "",
        "imageLocal": imageLocal ?? "",
        "types": types.isNotEmpty
            ? List<dynamic>.from(
                types.map((x) => x.toJson()),
              )
            : []
      };
}
