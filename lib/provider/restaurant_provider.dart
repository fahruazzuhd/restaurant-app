import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

import '../data/api/restaurant_api_service.dart';
import '../data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late Restaurants _restaurants;
  late RestaurantDetail _detail;
  late RestaurantSearch _search;
  late ResultState _state;
  List<Restaurant> _searchResults = [];

  String _message = '';

  String get message => _message;

  Restaurants get listResult => _restaurants;
  RestaurantDetail get detailResult => _detail;
  RestaurantSearch get searchResult => _search;
  List<Restaurant> get searchResults => _searchResults;

  ResultState get state => _state;

  Future<void> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.listTopHeadlines();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = 'Tidak ada data restoran';
      } else {
        _state = ResultState.hasData;
        _restaurants = restaurant;
        _searchResults = restaurant.restaurants; // Tambahkan ini
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is NoInternetException) {
        _message = 'Tidak ada koneksi internet';
      } else {
        _message = 'Terjadi kesalahan: $e';
      }
    }
  }

  Future<void> fetchDetailRestaurant(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.detailTopHeadlines(restaurantId);
      _state = ResultState.hasData;
      notifyListeners();
      _detail = restaurantDetail;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is NoInternetException) {
        _message = 'Tidak ada koneksi internet';
      } else {
        _message = 'Terjadi kesalahan: $e';
      }
    }
  }

  Future<void> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantFound = await apiService.listTopHeadlines(); // Mendapatkan semua restaurant

      final filteredRestaurants = restaurantFound.restaurants.where((restaurant) {
        final restaurantName = restaurant.name.toLowerCase();
        final queryLowerCase = query.toLowerCase();
        return restaurantName.contains(queryLowerCase);
      }).toList();

      if (filteredRestaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = 'Tidak ada restoran yang ditemukan untuk pencarian: "$query"';
      } else {
        _state = ResultState.hasData;
        _searchResults = filteredRestaurants; // Perbarui hasil pencarian
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is NoInternetException) {
        _message = 'Tidak ada koneksi internet';
      } else {
        _message = 'Terjadi kesalahan: $e';
      }
    }
  }
}
