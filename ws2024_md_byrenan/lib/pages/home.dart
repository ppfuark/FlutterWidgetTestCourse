import 'dart:convert';

import 'package:d1/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List hotels = [];
  TextEditingController busca = TextEditingController();

  startApp() async {
    String json = await rootBundle.loadString("assets/data/hotels.json");
    hotels = jsonDecode(json);
    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Text("The Alps' Hotel"),
            Image.asset("assets/image/france_national_flag.png", height: 30),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/minhas'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: hotels.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    TextFormField(
                      controller: busca,
                      keyboardType: TextInputType.webSearch,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: "Search a hotel name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 8,
                          children: [
                            for (var hotel in hotels)
                              if (busca.text.isEmpty ||
                                  hotel['hotel_name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(busca.text.toLowerCase()))
                                Card(
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/image/${hotel['hotel_cover_image']}",
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      hotel['hotel_name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              hotel['hotel_rating'].toString(),
                                            ),
                                            Container(width: 8),
                                            for (
                                              int i = 0;
                                              i < hotel['hotel_rating'] / 2;
                                              i++
                                            )
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                          ],
                                        ),
                                        Text(
                                          "${hotel['hotel_to_ski_distance']}km from Alps’ ski lift",
                                        ),
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                      key: Key(hotel['hotel_name']),
                                      onPressed: () async {
                                        if (hotel['hotel_id'] == 1000 ||
                                            hotel['hotel_id'] == 1008) {
                                          String
                                          json = await rootBundle.loadString(
                                            'assets/data/hotels_details.${hotel['hotel_id']}.json',
                                          );

                                          App.hotel = jsonDecode(json);

                                          Navigator.pushNamed(
                                            context,
                                            '/detalhes',
                                          );
                                        }
                                      },
                                      child: Text("Book It"),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 1),
                  ],
                ),
              ),
            ),
    );
  }
}
