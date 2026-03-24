import 'package:d1/controllers/app.dart';
import 'package:flutter/material.dart';

class MinhasReservas extends StatefulWidget {
  const MinhasReservas({super.key});

  @override
  State<MinhasReservas> createState() => _MinhasReservasState();
}

class _MinhasReservasState extends State<MinhasReservas> {
  // App.reservas.add({
  //                   "firstName": firstName.text,
  //                   "lastName": lastName.text,
  //                   "checkIn": checkIn.text,
  //                   "checkOut": checkOut.text,
  //                   "adults": adults.text,
  //                   "children": children.text,
  //                   "rooms": rooms.text,
  //                   "price": price.text,
  //                   "hotel": App.hotel,
  //                   "room": App.room,
  //                   "business": business,
  //                   "pay": pay,
  //                 });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('My bookings'),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "List of my bookings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 8,
                    children: [
                      for (var reserva in App.reservas)
                        Card(
                          child: Container(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text("${App.reservas.indexOf(reserva) + 1}"),
                                  Text(
                                    "${reserva['firstName']} ${reserva['lastName']}",
                                  ),
                                  Text(
                                    "${reserva['checkIn']} -> ${reserva['checkOut']}",
                                  ),
                                  Text(
                                    "Adults: ${reserva['adults']} | Children: ${reserva['children']} | Rooms: ${reserva['rooms']}",
                                  ),
                                  Text(
                                    "Type: ${reserva['business'] ?? "Type not selected"}",
                                  ),
                                  Text("Payment method: ${reserva['pay']}"),
                                  Text("${reserva['price']}"),
                                ],
                              ),
                            ),
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
    );
  }
}
