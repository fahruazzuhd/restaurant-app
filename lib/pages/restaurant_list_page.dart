import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/pages/restaurant_detail_page.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

import '../data/model/restaurant.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                restaurantProvider.searchRestaurants(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                filled: true, // Menambahkan latar belakang berwarna
                fillColor: Colors.grey[100], // Warna latar belakang
                border: OutlineInputBorder( // Membuat border dengan sudut bulat
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  // Kasus saat masih dalam proses memuat data
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.state == ResultState.error) {
                  // Kasus saat terjadi kesalahan
                  return Center(
                    child: Material(
                      child: Text(state.message),
                    ),
                  );
                } else if (state.state == ResultState.noData) {
                  // Kasus saat data tidak ada
                  return Center(
                    child: Material(
                      child: Text(state.message),
                    ),
                  );
                } else if (state.state == ResultState.hasData) {
                  final searchResults = state.searchResults;
                  if (searchResults.isNotEmpty) {
                    return ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var restaurant = searchResults[index];
                        return _buildRestaurantItem(context, restaurant);
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No restaurants found'),
                    );
                  }
                } else {
                  return const Center(
                    child: Material(
                      child: Text(''),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ),
      leading: Hero(
        tag: restaurant.pictureId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(restaurant.name),
      subtitle: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_pin, size: 13),
                const SizedBox(width: 4,),
                Text(restaurant.city)
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(Icons.star_half, size: 13),
                const SizedBox(width: 4,),
                Text(restaurant.rating.toString())
              ],
            ),
          ]
      ),
      onTap: () {
        final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
        restaurantProvider.fetchDetailRestaurant(restaurant.id); // Memanggil method untuk mengambil detail
        Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: restaurant.id);
      },
    );
  }
}
