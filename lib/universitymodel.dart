// To parse this JSON data, do
//
//     final universityModel = universityModelFromJson(jsonString);

import 'dart:convert';

List<UniversityModel> universityModelFromJson(String str) =>
    List<UniversityModel>.from(
        json.decode(str).map((x) => UniversityModel.fromJson(x)));

String universityModelToJson(List<UniversityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UniversityModel {
  String alphaTwoCode;
  String name;
  dynamic domains;
  dynamic webPages;
  String country;
  String? stateProvince;

  UniversityModel({
    required this.alphaTwoCode,
    required this.name,
    required this.domains,
    required this.webPages,
    required this.country,
    required this.stateProvince,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      UniversityModel(
        alphaTwoCode: json["alpha_two_code"].toString(),
        name: json["name"].toString(),
        domains: json["domains"],
        webPages: (json["web_pages"]),
        country: json["country"].toString(),
        stateProvince: json["state-province"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "alpha_two_code": alphaTwoCode,
        "name": name,
        "domains": List<dynamic>.from(domains.map((x) => x)),
        "web_pages": List<dynamic>.from(webPages.map((x) => x)),
        "country": country,
        "state-province": stateProvince,
      };
}
