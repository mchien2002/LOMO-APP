class TrackingRequest {
  TrackingRequest({
    this.event,
    this.post,
    this.banner,
    this.topic,
    this.quiz,
    this.profile,
    this.gift,
    this.session = 0,
  });

  String? event;
  String? post;
  String? banner;
  String? topic;
  String? quiz;
  String? profile;
  String? gift;
  int session;

  factory TrackingRequest.fromJson(Map<String, dynamic> json) =>
      TrackingRequest(
        event: json["event"],
        post: json["post"],
        banner: json["banner"],
        topic: json["topic"],
        quiz: json["quiz"],
        gift: json["gift"],
        profile: json["profile"],
        session: json["session"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "post": post,
        "banner": banner,
        "topic": topic,
        "quiz": quiz,
        "profile": profile,
        "session": session,
        "gift": gift
      };
}
