class DatingFilter {
  DatingFilter({
    this.distance,
    this.gender,
    this.role,
    this.sogiescs,
    this.ages,
    this.provinces,
    this.zodiacs,
    this.careers,
    this.literacys,
  });

  double? distance;
  String? gender;
  String? role;
  List<String>? sogiescs;
  List<int>? ages;
  List<String>? provinces;
  List<String>? zodiacs;
  List<String>? careers;
  List<String>? literacys;

  factory DatingFilter.fromJson(Map<String, dynamic> json) => DatingFilter(
        distance: json["distance"],
        gender: json["gender"],
        role: json["role"],
        sogiescs: json["sogiescs"] == null
            ? []
            : List<String>.from(json["sogiescs"].map((x) => x)),
        ages: json["ages"] == null
            ? []
            : List<int>.from(json["ages"].map((x) => x)),
        provinces: json["provinces"] == null
            ? []
            : List<String>.from(json["provinces"].map((x) => x)),
        zodiacs: json["zodiacs"] == null
            ? []
            : List<String>.from(json["zodiacs"].map((x) => x)),
        careers: json["careers"] == null
            ? []
            : List<String>.from(json["careers"].map((x) => x)),
        literacys: json["literacys"] == null
            ? []
            : List<String>.from(json["literacys"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance ?? null,
        "gender": gender ?? "",
        "role": role ?? "",
        "sogiescs":
            sogiescs == null ? [] : List<dynamic>.from(sogiescs!.map((x) => x)),
        "ages": ages == null ? [] : List<dynamic>.from(ages!.map((x) => x)),
        "provinces": provinces == null
            ? []
            : List<dynamic>.from(provinces!.map((x) => x)),
        "zodiacs":
            zodiacs == null ? [] : List<dynamic>.from(zodiacs!.map((x) => x)),
        "careers":
            careers == null ? [] : List<dynamic>.from(careers!.map((x) => x)),
        "literacys": literacys == null
            ? []
            : List<dynamic>.from(literacys!.map((x) => x)),
      };
}
