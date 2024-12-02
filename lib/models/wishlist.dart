// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

Wishlist wishlistFromJson(String str) => Wishlist.fromJson(json.decode(str));

String wishlistToJson(Wishlist data) => json.encode(data.toJson());

class Wishlist {
    String model;
    int pk;
    Fields fields;

    Wishlist({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
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

    Fields({
        required this.product,
        required this.user,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        product: json["product"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "user": user,
    };
}
