class UploadAvatarResponse {
  UploadAvatarResponse({
     this.link,
  });

  String? link;

  factory UploadAvatarResponse.fromJson(Map<String, dynamic> json) =>
      UploadAvatarResponse(
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
      };
}
