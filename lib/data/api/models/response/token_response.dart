class TokenResponse {
  TokenResponse(
      {this.accessToken, this.refreshToken, this.netaloToken, this.id});

  String? accessToken;
  String? refreshToken;
  String? netaloToken;
  String? id;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        netaloToken: json["netalo_token"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "netalo_token": netaloToken,
        "id": id,
      };
}
