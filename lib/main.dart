import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/pages/restaurant_detail_page.dart';
import 'package:restaurant_app/pages/restaurant_list_page.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

import 'data/api/restaurant_api_service.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RestaurantProvider(apiService: ApiService()),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      initialRoute: RestaurantListPage.routeName,
      routes: {
        RestaurantListPage.routeName: (context) => const RestaurantListPage(),
        RestaurantDetailPage.routeName: (context) {
          // Menerima argument dari Navigator
          final String? restaurantId =
          ModalRoute.of(context)?.settings.arguments as String?;
          // Membuat instance RestaurantDetailPage dengan argument restaurantId
          return RestaurantDetailPage(restaurantId: restaurantId ?? '');
        },
      },
    );
  }
}
