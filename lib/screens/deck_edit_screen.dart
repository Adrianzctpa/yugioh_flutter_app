import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/components/deck_form.dart';
import 'package:yugioh_flutter_app/models/deck.dart';

class DeckEditScreen extends StatefulWidget {
  const DeckEditScreen({Key? key}) : super(key: key);

  @override
  State<DeckEditScreen> createState() => _DeckEditScreenState();
}

class _DeckEditScreenState extends State<DeckEditScreen> {
  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)!.settings.arguments as Deck;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Edit'),
      ),
      body: DeckForm(text: 'Edit', deck: deck)
    );
  }
}