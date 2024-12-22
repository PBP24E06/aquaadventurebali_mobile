// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

List<Transaction> transactionFromJson(String str) => List<Transaction>.from(json.decode(str).map((x) => Transaction.fromJson(x)));

String transactionToJson(List<Transaction> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
    String model;
    String pk;
    Fields fields;

    Transaction({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
    String name;
    String email;
    String phoneNumber;
    DateTime checkoutTime;

    Fields({
        required this.product,
        required this.user,
        required this.name,
        required this.email,
        required this.phoneNumber,
        required this.checkoutTime,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        product: json["product"],
        user: json["user"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        checkoutTime: DateTime.parse(json["checkout_time"]),
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "user": user,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "checkout_time": checkoutTime.toIso8601String(),
    };
}
