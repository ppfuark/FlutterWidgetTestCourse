import 'package:d1/pages/confirmacao.dart';
import 'package:d1/pages/detalhes.dart';
import 'package:d1/pages/home.dart';
import 'package:d1/pages/minhas_reservas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/home': (context) => const Home(),
        '/detalhes': (context) => const Detalhes(),
        '/confirmar': (context) => const Confirmacao(),
        '/minhas': (context) => const MinhasReservas(),
      },
      initialRoute: '/home',
    );
  }
}
