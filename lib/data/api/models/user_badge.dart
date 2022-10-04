class UserBadge {
  UserBadge({
    this.icon,
    this.name,
  });

  String? icon;
  String? name;

  factory UserBadge.fromJson(Map<String, dynamic> json) => UserBadge(
        icon: json["icon"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "name": name,
      };
}
