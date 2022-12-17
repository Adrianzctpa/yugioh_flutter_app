import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';
import 'package:yugioh_flutter_app/screens/cards_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cards(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CardsScreen(),
      ),
    );
  }
}
  