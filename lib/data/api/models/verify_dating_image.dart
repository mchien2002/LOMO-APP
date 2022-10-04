class VerifyDatingImage {
  VerifyDatingImage({
    this.verifyImages,
  });

  List<String>? verifyImages;

  factory VerifyDatingImage.fromJson(Map<String, dynamic> json) =>
      VerifyDatingImage(
        verifyImages: json["verifyImages"] != null
            ? List<String>.from(json["verifyImages"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "verifyImages": verifyImages?.isNotEmpty == true
            ? List<dynamic>.from(verifyImages!.map((x) => x))
            : [],
      };
}
