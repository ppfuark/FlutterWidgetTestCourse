import 'package:d1/controllers/app.dart';
import 'package:flutter/material.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("Booking")),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                App.hotel['hotel_name'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: TabBar(
                controller: controller,
                tabs: [
                  Tab(text: "Guest reviews"),
                  Tab(text: "Room selection"),
                ],
              ),
            ),
            Container(height: 16),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ratings",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(height: 16),
                                  Column(
                                    spacing: 8,
                                    children: [
                                      for (Map item
                                          in App
                                              .hotel['guest_reviews']['ratings_categories'])
                                        Column(
                                          spacing: 4,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  item.keys.first.toString(),
                                                ),
                                                Text(
                                                  item.values.first.toString(),
                                                ),
                                              ],
                                            ),
                                            LinearProgressIndicator(
                                              value: item.values.first / 10,
                                              minHeight: 8,
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reviews",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 16,
                                      children: [
                                        for (Map item
                                            in App
                                                .hotel['guest_reviews']['reviews_objects'])
                                          Container(
                                            width: width * .55,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(item['username']),
                                                  subtitle: Text(
                                                    item['country'],
                                                  ),
                                                  leading: CircleAvatar(
                                                    child: Center(
                                                      child: Text(
                                                        item['username'][0],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Text(
                                                    item['review_text']
                                                        .toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rooms",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          for (var room in App.hotel['rooms'])
                            GestureDetector(
                              onTap: () {
                                App.room = room;
                                Navigator.pushNamed(context, '/confirmar');
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          spacing: 8,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              room['room_type'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Bed: ${room['room_bed_type']}",
                                            ),
                                            Text(
                                              "Total number of guests: ${room['room_total_number_of_guests']}",
                                            ),
                                            Text(
                                              room['room_features'].join(', '),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '€ ${room['room_price_for_one_night']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Container(height: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
