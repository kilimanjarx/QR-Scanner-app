// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
    Meta meta;
    List<Response> response;

    Customer({
        this.meta,
        this.response,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        meta: Meta.fromJson(json["meta"]),
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class Meta {
    bool error;
    String message;
    int statusCode;

    Meta({
        this.error,
        this.message,
        this.statusCode,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        error: json["error"],
        message: json["message"],
        statusCode: json["statusCode"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "statusCode": statusCode,
    };
}

class Response {
    String invoiceNo;
    String email;
    String description;
    String currency;
    String amount;
    int status;
    int totalPax;
    int numberOfSeats;
    AtedAt createdAt;
    AtedAt updatedAt;
    dynamic registeredCustomer;
    dynamic notes;
    Tags tags;

    Response({
        this.invoiceNo,
        this.email,
        this.description,
        this.currency,
        this.amount,
        this.status,
        this.totalPax,
        this.numberOfSeats,
        this.createdAt,
        this.updatedAt,
        this.registeredCustomer,
        this.notes,
        this.tags,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        invoiceNo: json["invoiceNo"],
        email: json["email"],
        description: json["description"],
        currency: json["currency"],
        amount: json["amount"],
        status: json["status"],
        totalPax: json["totalPax"],
        numberOfSeats: json["numberOfSeats"],
        createdAt: AtedAt.fromJson(json["createdAt"]),
        updatedAt: AtedAt.fromJson(json["updatedAt"]),
        registeredCustomer: json["registeredCustomer"],
        notes: json["notes"],
        tags: Tags.fromJson(json["tags"]),
    );

    Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "email": email,
        "description": description,
        "currency": currency,
        "amount": amount,
        "status": status,
        "totalPax": totalPax,
        "numberOfSeats": numberOfSeats,
        "createdAt": createdAt.toJson(),
        "updatedAt": updatedAt.toJson(),
        "registeredCustomer": registeredCustomer,
        "notes": notes,
        "tags": tags.toJson(),
    };
}

class AtedAt {
    DateTime date;
    int timezoneType;
    String timezone;

    AtedAt({
        this.date,
        this.timezoneType,
        this.timezone,
    });

    factory AtedAt.fromJson(Map<String, dynamic> json) => AtedAt(
        date: DateTime.parse(json["date"]),
        timezoneType: json["timezone_type"],
        timezone: json["timezone"],
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
    };
}

class Tags {
    String vimigo;

    Tags({
        this.vimigo,
    });

    factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        vimigo: json["vimigo"],
    );

    Map<String, dynamic> toJson() => {
        "vimigo": vimigo,
    };
}
