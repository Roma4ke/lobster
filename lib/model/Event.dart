// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String name;
  String description;
  int date;
  String mix;
  String cover;
  Location location;

  Event({
    this.name,
    this.description,
    this.date,
    this.mix,
    this.cover,
    this.location,
  });

  static Event fromDocument(DocumentSnapshot document) => _fromMap(document.data);

  static Event _fromMap(Map<String, dynamic> data) => new Event.fromMap(data);


  Event.fromMap(Map<String, dynamic> data) : this(
    name: data["name"],
    description: data["description"],
    date: data["date"],
    mix: data["mix"],
    cover: data["cover"],
    location: Location._fromMap(data["location"]),
  );

  Map<String, dynamic> toMap() => {
    "name": this.name,
    "description": this.description,
    "date": this.date,
    "mix": this.mix,
    "cover": this.cover,
    "location": this.location.toMap(),
  };

  factory Event.fromJson(Map<String, dynamic> json) => new Event(
    name: json["name"],
    description: json["description"],
    date: json["date"],
    mix: json["mix"],
    cover: json["cover"],
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "date": date,
    "mix": mix,
    "cover": cover,
    "location": location.toJson(),
  };
}

class Location {
  String city;
  String street;
  String zipCode;
  String description;
  double long;
  double lat;

  Location({
    this.city,
    this.street,
    this.zipCode,
    this.description,
    this.long,
    this.lat,
  });

  static Location fromDocument(DocumentSnapshot document) => _fromMap(document.data);

  static Location _fromMap(Map<dynamic, dynamic> data) => new Location.fromMap(data);


  Location.fromMap(Map<dynamic, dynamic> data) : this(
    city: data["city"],
    street: data["street"],
    description: data["description"],
    zipCode: data["zipCode"],
    long: data["long"],
    lat: data["lot"],
  );

  Map<dynamic, dynamic> toMap() => {
    "city": this.city,
    "street": this.street,
    "description": this.description,
    "zipCode": this.zipCode,
    "long": this.long,
    "lat": this.lat,
  };

  factory Location.fromJson(Map<String, dynamic> json) => new Location(
    city: json["city"],
    street: json["street"],
    zipCode: json["zipCode"],
    description: json["description"],
    long: json["long"].toDouble(),
    lat: json["lat"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "street": street,
    "zipCode": zipCode,
    "description": description,
    "long": long,
    "lat": lat,
  };
}
