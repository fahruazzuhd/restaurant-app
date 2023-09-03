import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

import '../../provider/restaurant_provider.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<Restaurants> listTopHeadlines() async {
    try {
      final listResponse = await http.get(Uri.parse("$_baseUrl/list"));
      if (listResponse.statusCode == 200) {
        return Restaurants.fromJson(json.decode(listResponse.body));
      } else {
        throw Exception('Failed to load list'); // Modifikasi di sini
      }
    } catch (e) {
      throw NoInternetException('No Internet Connection'); // Modifikasi di sini
    }
  }

  Future<RestaurantDetail> detailTopHeadlines(String restaurantId) async {
    try {
      final listResponse = await http.get(Uri.parse("$_baseUrl/detail/$restaurantId"));
      if (listResponse.statusCode == 200) {
        return RestaurantDetail.fromJson(json.decode(listResponse.body));
      } else {
        throw Exception('Failed to load detail'); // Modifikasi pesan error di sini
      }
    } catch (e) {
      throw NoInternetException('No Internet Connection');
    }
  }

  Future<RestaurantSearch> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RestaurantSearch.fromJson(data);
      } else {
        throw Exception('Failed to search for restaurants');
      }
    } catch (e) {
      throw NoInternetException('No Internet Connection');
    }
  }
}

class NoInternetException implements Exception {
  final String message;

  NoInternetException(this.message);
}
