import 'package:meta/meta.dart';
import 'dart:convert';

class Restaurants {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  Restaurants({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory Restaurants.fromRawJson(String str) => Restaurants.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
    error: json["error"],
    message: json["message"],
    count: json["count"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class RestaurantSearch {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  RestaurantSearch({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearch.fromRawJson(String str) => RestaurantSearch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantSearch.fromJson(Map<String, dynamic> json) => RestaurantSearch(
    error: json["error"],
    founded: json["founded"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "founded": founded,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromRawJson(String str) => Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}
