import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';
import 'package:yugioh_flutter_app/screens/cards_screen.dart';
import 'package:yugioh_flutter_app/screens/deck_screen.dart';
import 'package:yugioh_flutter_app/screens/details_screen.dart';
import 'package:yugioh_flutter_app/screens/filter_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Cards>(create: (context) => Cards()),
        ChangeNotifierProvider<Decks>(create: (context) => Decks()),
      ],
      child: Consumer<Decks>(
        builder: (ctx, prov, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: prov.beenLoaded
          ? const DeckScreen()
          : FutureBuilder(
            future: prov.loadDecks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const DeckScreen();
              }
            }
          ),
          routes: {
            '/details': (context) => const DetailsScreen(),
            '/filter': (context) => const FilterScreen(),
            '/cards': (context) => const CardsScreen(),
            '/decks': (context) =>  const DeckScreen()
          },
        ),
      ),
    );
  }
}
  