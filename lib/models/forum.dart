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
        fields: Fields.fromJson(json["fields"], json["pk"]), // Pass pk to Fields
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int pk; // Include `pk` for parsing
  String product;
  int user;
  String commenterName;
  String message;
  dynamic parent;
  DateTime createdAt;

  Fields({
    required this.pk,
    required this.product,
    required this.user,
    this.commenterName = "Anonymous",
    required this.message,
    this.parent,
    required this.createdAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json, int forumPk) => Fields(
        pk: forumPk, // Assign the forum's pk to this field
        product: json["product"],
        user: json["user"],
        commenterName: json["commenter_name"] ?? "Anonymous",
        message: json["message"],
        parent: json["parent"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk, // Include pk in serialization
        "product": product,
        "user": user,
        "commenter_name": commenterName,
        "message": message,
        "parent": parent,
        "created_at": createdAt.toIso8601String(),
      };
}
