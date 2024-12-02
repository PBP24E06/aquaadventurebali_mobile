// To parse this JSON data, do
//
//     final forum = forumFromJson(jsonString);

import 'dart:convert';

List<Forum> forumFromJson(String str) => List<Forum>.from(json.decode(str).map((x) => forumFromJson(x)));

String forumToJson(List<Forum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
    String model;
    int pk;
    Fields fields;

    Forum({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String product;
    int user;
    String commenterName;
    String message;
    dynamic parent;
    DateTime createdAt;

    Fields({
        required this.product,
        required this.user,
        this.commenterName = "Anonymous",
        required this.message,
        this.parent,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        product: json["product"],
        user: json["user"],
        commenterName: json["commenter_name"] ?? "Anonymous",
        message: json["message"],
        parent: json["parent"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "user": user,
        "commenter_name": commenterName,
        "message": message,
        "parent": parent,
        "created_at": createdAt.toIso8601String(),
    };
}
