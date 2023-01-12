import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/components/deck_form.dart';

class DeckCreateScreen extends StatefulWidget {
  const DeckCreateScreen({Key? key}) : super(key: key);

  @override
  State<DeckCreateScreen> createState() => _DeckCreateScreenState();
}

class _DeckCreateScreenState extends State<DeckCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: Column(
        children: [
         const DeckForm(text: 'Create Deck'),
         Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [
                    Text("Adding cards:"),
                    Text("Go to the cards screen"),
                    Text("Click the card you want to add"),
                    Text("Tap 'Add to Deck' button and select the deck")
                  ],
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}