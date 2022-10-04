class Checkin {
  //check: 1 da checkin,2:chua checkin,0:khong the checkin
  Checkin({this.check, this.candy});

  int? check;
  int? candy;

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        check: json["check"],
        candy: json["candy"],
      );

  Map<String, dynamic> toJson() => {
        "check": check,
        "candy": candy,
      };
}
