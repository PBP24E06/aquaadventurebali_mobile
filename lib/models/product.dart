// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Model model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    Kategori kategori;
    int harga;
    Toko toko;
    String alamat;
    Kontak kontak;
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
        kategori: kategoriValues.map[json["kategori"]]!,
        harga: json["harga"],
        toko: tokoValues.map[json["toko"]]!,
        alamat: json["alamat"],
        kontak: kontakValues.map[json["kontak"]]!,
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "kategori": kategoriValues.reverse[kategori],
        "harga": harga,
        "toko": tokoValues.reverse[toko],
        "alamat": alamat,
        "kontak": kontakValues.reverse[kontak],
        "gambar": gambar,
    };
}

enum Kategori {
    BOOTS,
    FIN,
    GLOVE,
    MASK,
    OTHERS,
    PANTS,
    REGULATOR,
    SNORKEL,
    WETSUIT
}

final kategoriValues = EnumValues({
    "Boots": Kategori.BOOTS,
    "Fin": Kategori.FIN,
    "Glove": Kategori.GLOVE,
    "Mask": Kategori.MASK,
    "Others": Kategori.OTHERS,
    "Pants": Kategori.PANTS,
    "Regulator": Kategori.REGULATOR,
    "Snorkel": Kategori.SNORKEL,
    "Wetsuit": Kategori.WETSUIT
});

enum Kontak {
    THE_081337950505,
    THE_081353333387,
    THE_087788990006,
    THE_087852252294,
    THE_087861050111
}

final kontakValues = EnumValues({
    "0813-3795-0505": Kontak.THE_081337950505,
    "0813-5333-3387": Kontak.THE_081353333387,
    "0877-8899-0006": Kontak.THE_087788990006,
    "0878-5225-2294": Kontak.THE_087852252294,
    "0878-6105-0111": Kontak.THE_087861050111
});

enum Toko {
    BALI_DIVE_SHOP,
    DIVE_HUB,
    OCEAN_KING_DIVE_SHOP,
    SARANABAHARI,
    SCUBA_GEAR_INDONESIA
}

final tokoValues = EnumValues({
    "Bali Dive Shop": Toko.BALI_DIVE_SHOP,
    "Dive Hub": Toko.DIVE_HUB,
    "Ocean King Dive Shop": Toko.OCEAN_KING_DIVE_SHOP,
    "Saranabahari": Toko.SARANABAHARI,
    "Scuba Gear Indonesia": Toko.SCUBA_GEAR_INDONESIA
});

enum Model {
    MAIN_PRODUCT
}

final modelValues = EnumValues({
    "main.product": Model.MAIN_PRODUCT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
