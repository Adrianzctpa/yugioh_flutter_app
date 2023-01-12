import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/base_screen.dart';
import 'package:yugioh_flutter_app/components/show_decks.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class DeckScreen extends StatefulWidget {
  const DeckScreen({Key? key}) : super(key: key);

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Decks>(context, listen: true);
    final decks = prov.decks;

    return BaseScreen(
      title: 'Decks',
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/deck-create'), 
                    child: const Text('Add Deck')
                  ),
                )
              ],
            ),
            Expanded(
              child: decks.isEmpty 
              ? const Center(
                child: Text('No decks yet'),
              )
              : const ShowDecks(),
            )
          ],
        ),
    );
  }
}
