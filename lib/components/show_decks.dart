import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class ShowDecks extends StatelessWidget {
  const ShowDecks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Decks>(context, listen: true);
    final decks = prov.decks;
    
    return ListView.builder(
      itemCount: decks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(decks[index].name)),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).pushNamed('/deck-edit', arguments: decks[index]),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => prov.removeDeck(decks[index]),
                  ),
                ]
              ),
            ),
          ),
        );
      },
    );
  }
}
