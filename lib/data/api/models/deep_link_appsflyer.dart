class DeepLinkApp {
  String? pid;
  String? uid;

  DeepLinkApp({this.pid, this.uid});

  factory DeepLinkApp.fromJson(Map<String, dynamic> json) => DeepLinkApp(
        pid: json["p_id"],
        uid: json["u_id"],
      );

  Map<String, dynamic> toJson() => {"p_id": pid, "u_id": uid};
}
