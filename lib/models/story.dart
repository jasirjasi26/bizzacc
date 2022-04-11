// To parse this JSON data, do
//
//     final storydata = storydataFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

Storydata storydataFromJson(String str) => Storydata.fromJson(json.decode(str));

String storydataToJson(Storydata data) => json.encode(data.toJson());

class Storydata {
  Storydata({
    this.result,
    this.imagePath,
    this.stories,
  });

  bool result;
  String imagePath;
  List<Story> stories;

  factory Storydata.fromJson(Map<String, dynamic> json) => Storydata(
    result: json["result"],
    imagePath: json["image path"],
    stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "image path": imagePath,
    "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
  };
}

class Story {
  Story({
    this.id,
    this.userId,
    this.name,
    this.image,
    this.link,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String name;
  String image;
  String link;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    image: json["image"],
    link: json["link"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "image": image,
    "link": link,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
