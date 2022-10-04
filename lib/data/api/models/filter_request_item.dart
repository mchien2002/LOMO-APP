import 'dart:convert';

import '../api_constants.dart';

FilterRequestItem filterRequestItemFromJson(String str) =>
    FilterRequestItem.fromJson(json.decode(str));

String filterRequestItemToJson(FilterRequestItem data) =>
    json.encode(data.toJson());

class FilterRequestItem {
  FilterRequestItem({
    this.key = "",
    this.value,
  });

  String key;
  dynamic value;

  factory FilterRequestItem.fromJson(Map<String, dynamic> json) =>
      FilterRequestItem(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };

  // dùng cho trường hợp Array data
  List<String?> getArrayDataValues() => (value as String).split(",").toList();

  @override
  String toString() {
    return 'FilterRequestItem{\$key: $key  \$value: $value }';
  }
}

class ArrayData {
  ArrayData({required this.key, required this.values});

  String key;
  List<dynamic> values;

  FilterRequestItem toFilterRequestItem() =>
      FilterRequestItem(key: key, value: values.join(","));
}

class GetQueryParam {
  GetQueryParam({
    this.page,
    this.limit,
    this.sorts,
    this.filters,
    this.isDefault,
    this.skip,
  });

  int? page;
  int? limit;
  int? skip;
  List<FilterRequestItem>? sorts;
  List<FilterRequestItem>? filters;
  bool? isDefault;

  factory GetQueryParam.fromJson(Map<String, dynamic> json) => GetQueryParam(
        page: json["page"] ?? 1,
        limit: json["limit"] ?? PAGE_SIZE,
        sorts: json["sorts"] != null
            ? List<FilterRequestItem>.from(
                json["sorts"].map((x) => FilterRequestItem.fromJson(x)))
            : [],
        filters: json["filters"] != null
            ? List<FilterRequestItem>.from(
                json["filters"].map((x) => FilterRequestItem.fromJson(x)))
            : [],
        isDefault: json["isDefault"] ?? false,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      if (page != null) "page": page,
      if (limit != null) "limit": limit,
      if (sorts?.isNotEmpty == true)
        "sort": sorts?.map((x) => "${x.key}:${x.value}").toList().join(","),
      if (skip != null) "skip": skip,
    };
    filters?.forEach((element) {
      data["${element.key}"] = element.value;
    });

    return data;
  }

  @override
  String toString() {
    return 'FilterRequestItem{sorts: $sorts  filters: $filters ,isDefault $isDefault }';
  }
}
