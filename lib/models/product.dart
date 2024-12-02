// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    String model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    String name;
    String kategori;
    int harga;
    String toko;
    String alamat;
    String kontak;
    String gambar;

    Fields({
        required this.name,
        required this.kategori,
        required this.harga,
        required this.toko,
        required this.alamat,
        required this.kontak,
        required this.gambar,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        kategori: json["kategori"],
        harga: json["harga"],
        toko: json["toko"],
        alamat: json["alamat"],
        kontak: json["kontak"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "kategori": kategori,
        "harga": harga,
        "toko": toko,
        "alamat": alamat,
        "kontak": kontak,
        "gambar": gambar,
    };
}
