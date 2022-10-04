// To parse this JSON data, do
//
//     final ipWifi = ipWifiFromJson(jsonString);

import 'dart:convert';

IpWifi ipWifiFromJson(String str) => IpWifi.fromJson(json.decode(str));

String ipWifiToJson(IpWifi data) => json.encode(data.toJson());

class IpWifi {
  IpWifi({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.ipWifiAs,
    this.query,
  });

  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? ipWifiAs;
  String? query;

  factory IpWifi.fromJson(Map<String, dynamic> json) => IpWifi(
        status: json["status"],
        country: json["country"],
        countryCode: json["countryCode"],
        region: json["region"],
        regionName: json["regionName"],
        city: json["city"],
        zip: json["zip"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        timezone: json["timezone"],
        isp: json["isp"],
        org: json["org"],
        ipWifiAs: json["as"],
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "country": country,
        "countryCode": countryCode,
        "region": region,
        "regionName": regionName,
        "city": city,
        "zip": zip,
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "isp": isp,
        "org": org,
        "as": ipWifiAs,
        "query": query,
      };
}
