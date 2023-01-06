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
        return ListTile(
          title: Text(decks[index].name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => Provider.of<Decks>(context, listen: false).removeDeck(decks[index]),
          ),
        );
      },
    );
  }
}
