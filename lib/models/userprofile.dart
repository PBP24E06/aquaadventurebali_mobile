// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    String model;
    int pk;
    Fields fields;

    UserProfile({
        required this.model,
        required  this.pk,
        required this.fields,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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

    Fields({
        required this.user,
        required this.role,
        required this.profilePicture,
        this.alamat,
        this.birthdate,
        this.phoneNumber,
        this.bio,
        required this.dateJoined,
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
    };
}
