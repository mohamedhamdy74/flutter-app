// To parse this JSON data, do
//
//     final CatgsModel = CatgsModelFromJson(jsonString);

import 'dart:convert';

CatgsModel CatgsModelFromJson(String str) =>
    CatgsModel.fromJson(json.decode(str));

String CatgsModelToJson(CatgsModel data) => json.encode(data.toJson());

class CatgsModel {
  String slug;
  String name;
  String url;

  CatgsModel({required this.slug, required this.name, required this.url});

  factory CatgsModel.fromJson(Map<String, dynamic> json) =>
      CatgsModel(slug: json["slug"], name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"slug": slug, "name": name, "url": url};
}
