// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    String model;
    int pk;
    Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
    int user;
    String role;
    String profilePicture;
    dynamic alamat;
    dynamic birthdate;
    dynamic phoneNumber;
    dynamic bio;
    DateTime dateJoined;
    String username;

    Fields({
        required this.user,
        required this.role,
        required this.profilePicture,
        required this.alamat,
        required this.birthdate,
        required this.phoneNumber,
        required this.bio,
        required this.dateJoined,
        required this.username,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        role: json["role"],
        profilePicture: json["profile_picture"],
        alamat: json["alamat"],
        birthdate: json["birthdate"],
        phoneNumber: json["phone_number"],
        bio: json["bio"],
        dateJoined: DateTime.parse(json["date_joined"]),
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "role": role,
        "profile_picture": profilePicture,
        "alamat": alamat,
        "birthdate": birthdate,
        "phone_number": phoneNumber,
        "bio": bio,
        "date_joined": dateJoined.toIso8601String(),
        "username": username,
    };
}
