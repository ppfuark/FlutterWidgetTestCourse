import 'package:d1/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Confirmacao extends StatefulWidget {
  const Confirmacao({super.key});

  @override
  State<Confirmacao> createState() => _ConfirmacaoState();
}

class _ConfirmacaoState extends State<Confirmacao> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();
  TextEditingController adults = TextEditingController();
  TextEditingController children = TextEditingController();
  TextEditingController rooms = TextEditingController();
  TextEditingController price = TextEditingController();
  String? pay;
  String? business;

  DateTime? checkInDate;
  DateTime? checkOutDate;

  int dias = 1;

  var formKey = GlobalKey<FormState>();

  cadastrar() {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Are you going to book this room?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                App.reservas.add({
                  "firstName": firstName.text,
                  "lastName": lastName.text,
                  "checkIn": checkIn.text,
                  "checkOut": checkOut.text,
                  "adults": adults.text,
                  "children": children.text,
                  "rooms": rooms.text,
                  "price": price.text,
                  "hotel": App.hotel,
                  "room": App.room,
                  "business": business,
                  "pay": pay,
                });

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.pushNamed(context, '/minhas');
              },
              child: Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  validateFirstName() {
    if (firstName.text.isEmpty) {
      return "Required";
    }

    if (firstName.text.length > 15) {
      return "Max length 15";
    }

    for (int i = 0; i < firstName.text.length; i++) {
      if (!firstName.text[i].contains(RegExp(r'[a-z]')) &&
          !firstName.text[i].contains(RegExp(r'[A-Z]'))) {
        return "Only letters";
      }
    }

    return null;
  }

  validateLastName() {
    if (lastName.text.isEmpty) {
      return "Required";
    }

    if (lastName.text.length > 15) {
      return "Max length 15";
    }

    for (int i = 0; i < lastName.text.length; i++) {
      if (!lastName.text[i].contains(RegExp(r'[a-z]')) &&
          !lastName.text[i].contains(RegExp(r'[A-Z]'))) {
        return "Only letters";
      }
    }

    return null;
  }

  validateAdults() {
    if (adults.text.isEmpty) {
      return "Required";
    }

    if (int.parse(adults.text) > 5) {
      return "Max 5 Adults";
    }

    if (int.parse(adults.text) < 1) {
      return "Min 1 Adult";
    }

    return null;
  }

  validateChildren() {
    String? valid = validateAdults();

    if (children.text.isEmpty) {
      return "Required";
    }

    if (valid == null) {
      if (int.parse(children.text) > int.parse(adults.text) * 2) {
        return "Max ${int.parse(adults.text) * 2} children";
      }
    }

    return null;
  }

  calculateRooms() {
    if (adults.text.isNotEmpty && children.text.isNotEmpty) {
      int a = int.parse(adults.text);
      int c = int.parse(children.text);

      rooms.text =
          "${((a + c) / App.room['room_total_number_of_guests']).ceil()}";
    } else {
      rooms.text = "0";
    }

    calculatePrice();
  }

  validateFormatCheckIn() {
    if (checkIn.text.isNotEmpty) {
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(checkIn.text)) {
        formatarCheckIn('MM/dd/yyyy');
      } else if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(checkIn.text)) {
        formatarCheckIn('MM-dd-yyyy');
      } else if (RegExp(
        r'^[A-Z]{1}[a-z]{2} \d{2} \d{4}$',
      ).hasMatch(checkIn.text)) {
        formatarCheckIn('MMM dd yyyy');
      } else {
        checkInDate = null;
      }
    } else {
      checkInDate = null;
    }
  }

  formatarCheckIn(String format) {
    DateTime dt = DateFormat(format).parseStrict(checkIn.text);

    checkInDate = dt;

    if (checkInDate != null && checkOutDate != null) {
      dias = (checkOutDate!.difference(checkInDate!).inDays);
    } else {
      dias = 1;
    }

    checkIn.text = DateFormat("EEE, MMM dd, yyyy").format(dt);
  }

  validateFormatCheckOut() {
    if (checkOut.text.isNotEmpty) {
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(checkOut.text)) {
        formatarCheckOut('MM/dd/yyyy');
      } else if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(checkOut.text)) {
        formatarCheckOut('MM-dd-yyyy');
      } else if (RegExp(
        r'^[A-Z]{1}[a-z]{2} \d{2} \d{4}$',
      ).hasMatch(checkOut.text)) {
        formatarCheckOut('MMM dd yyyy');
      } else {
        checkOutDate = null;
      }
    } else {
      checkOutDate = null;
    }
  }

  formatarCheckOut(String format) {
    DateTime dt = DateFormat(format).parseStrict(checkOut.text);

    checkOutDate = dt;

    if (checkInDate != null && checkOutDate != null) {
      dias = (checkOutDate!.difference(checkInDate!).inDays);
    } else {
      dias = 1;
    }

    checkOut.text = DateFormat("EEE, MMM dd, yyyy").format(dt);
  }

  calculatePrice() {
    try {
      double p =
          (dias * App.room['room_price_for_one_night'] * int.parse(rooms.text))
              .toDouble();

      if (business != null && business!.contains("150")) {
        p += 150;
      }

      price.text = "€ $p";
    } catch (e) {
      price.text = "€ ${App.room['room_price_for_one_night']}";
    }
  }

  @override
  void initState() {
    price.text = "€ ${App.room['room_price_for_one_night']}";
    children.text = "0";
    adults.text = "1";
    rooms.text = "1";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Booking Confirm"),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You are going to reserve:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            App.hotel['hotel_name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Card(
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
                                          App.room['room_type'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Bed: ${App.room['room_bed_type']}",
                                        ),
                                        Text(
                                          "Total number of guests: ${App.room['room_total_number_of_guests']}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '€ ${App.room['room_price_for_one_night']}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) => validateFirstName(),
                          key: Key("firstName"),
                          controller: firstName,
                          decoration: InputDecoration(
                            labelText: "Fist Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) => validateLastName(),
                          key: Key("lastName"),
                          controller: lastName,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            validateFormatCheckIn();
                            calculatePrice();
                          },
                          controller: checkIn,
                          validator: (value) {
                            if (checkIn.text.isEmpty) {
                              return "Required";
                            }

                            if (checkInDate == null) {
                              return "Invalid format";
                            }

                            if (checkInDate != null &&
                                checkOutDate != null &&
                                checkInDate!.isAfter(checkOutDate!)) {
                              return "Check-in is after checkout";
                            }

                            return null;
                          },
                          key: Key("checkin"),
                          decoration: InputDecoration(
                            labelText: "Check-In date",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            validateFormatCheckOut();
                            calculatePrice();
                          },
                          controller: checkOut,
                          validator: (value) {
                            if (checkOut.text.isEmpty) {
                              return "Required";
                            }

                            if (checkOutDate == null) {
                              return "Invalid format";
                            }

                            if (checkInDate != null &&
                                checkOutDate != null &&
                                checkInDate!.isAfter(checkOutDate!)) {
                              return "Check-in is after checkout";
                            }

                            return null;
                          },
                          key: Key("checkout"),
                          decoration: InputDecoration(
                            labelText: "Check-Out date",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => calculateRooms(),
                          validator: (value) => validateAdults(),
                          key: Key("adults"),
                          controller: adults,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Adults",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => calculateRooms(),
                          validator: (value) => validateChildren(),
                          key: Key("children"),
                          controller: children,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Children",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: rooms,
                          decoration: InputDecoration(
                            labelText: "Rooms",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  TextFormField(
                    initialValue: "${App.room['room_type']}",
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Room Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Travel for business?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RadioListTile(
                        groupValue: business,
                        onChanged: (value) => setState(() {
                          business = value;
                          calculatePrice();
                        }),
                        value: "For sightseeing",
                        title: Text("For sightseeing"),
                      ),
                      RadioListTile(
                        groupValue: business,
                        onChanged: (value) => setState(() {
                          business = value;
                          calculatePrice();
                        }),
                        value: "+ € 150 For business with a meeting room",
                        title: Text("+ € 150 For business with a meeting room"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wich way to pay?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RadioListTile(
                        groupValue: pay,
                        onChanged: (value) => setState(() {
                          pay = value;
                        }),
                        value: "Cash",
                        title: Text("Cash"),
                      ),
                      RadioListTile(
                        groupValue: pay,
                        onChanged: (value) => setState(() {
                          pay = value;
                        }),
                        value: "Credit Card",
                        title: Text("Credit Card"),
                      ),
                      RadioListTile(
                        groupValue: pay,
                        onChanged: (value) => setState(() {
                          pay = value;
                        }),
                        value: "E-Pay",
                        title: Text("E-Pay"),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: price,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => cadastrar(),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Book Now"),
                  ),
                  Container(height: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
