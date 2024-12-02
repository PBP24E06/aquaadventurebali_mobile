// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    int rating;
    String reviewText;

    Fields({
        required this.product,
        required this.user,
        required this.rating,
        required this.reviewText,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        product: json["product"],
        user: json["user"],
        rating: json["rating"],
        reviewText: json["review_text"],
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "user": user,
        "rating": rating,
        "review_text": reviewText,
    };
}
