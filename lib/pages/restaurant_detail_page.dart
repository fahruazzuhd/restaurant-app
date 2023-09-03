
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

import '../data/api/restaurant_api_service.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return CircularProgressIndicator();
            } else if (state.state == ResultState.error) {
              return Text('Error: ${state.message}');
            } else if (state.state == ResultState.noData) {
              return Text('No data available');
            } else if (state.state == ResultState.hasData) {
              var data = state.detailResult.restaurant;
              return Text(data.name);
            } else {
              return Text('');
            }
          },
        ),
      ),
      body:
      Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
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
          } else if(state.state == ResultState.hasData){
            // Kasus saat data sudah tersedia
            var data = state.detailResult.restaurant;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    Hero(
                        tag: data.pictureId,
                        child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/large/${data.pictureId}"
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text('Rating: ${data.rating}/5'),
                          const SizedBox(height: 10),
                          Text('Lokasi: ${data.city}'),
                          const Divider(color: Colors.grey),
                          Text(
                            data.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Divider(color: Colors.grey),
                          Text(
                            "Menu Makanan",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 190
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/foods.png",
                                          width: 150,
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Text(data.menus.foods[index].name)
                                    ],
                                  ),
                                );
                              },
                              itemCount: data.menus.foods.length,
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          Text(
                            "Menu Minuman",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 180
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/drinks.png",
                                          width: 100,
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Text(data.menus.drinks[index].name)
                                    ],
                                  ),
                                );
                              },
                              itemCount: data.menus.drinks.length,
                            ),
                          ),
                          SizedBox(height: 10,),
                          const Divider(color: Colors.white12),
                          Text(
                            "Customer Review",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          ListView.builder(
                            itemCount: data.customerReviews.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                var review = data.customerReviews[index];
                                return Card(
                                  elevation: 3, // Elevation card
                                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10), // Margin card
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8), // Jarak antara nama dan komentar
                                        Text(
                                          review.review,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 8), // Jarak antara komentar dan tanggal
                                        Text(
                                          review.date,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          }
        },
      ),
    );
  }
}
