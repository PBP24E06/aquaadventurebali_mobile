// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
    String model;
    int pk;
    Fields fields;

    Report({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
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
    String subject;
    String message;
    String status;
    DateTime createdAt;

    Fields({
        required this.product,
        required this.user,
        required this.subject,
        required this.message,
        required this.status,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        product: json["product"],
        user: json["user"],
        subject: json["subject"],
        message: json["message"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "user": user,
        "subject": subject,
        "message": message,
        "status": status,
        "created_at": createdAt.toIso8601String(),
    };
}
