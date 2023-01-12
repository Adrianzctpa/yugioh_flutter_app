import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/base_screen.dart';
import 'package:yugioh_flutter_app/components/show_cards.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    final ctx = Provider.of<Cards>(context, listen: true);
    final String? prev = ctx.prev;
    final String? next = ctx.next;
    final bool isFetching = ctx.isFetching;

    final deck = ModalRoute.of(context)!.settings.arguments as Deck?;
    return BaseScreen(
      title: 'Cards',
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: prev == null || isFetching ? null : () async {
                    ctx.setFetching(true);
                    await ctx.loadCards(url: prev);
                    ctx.setFetching(false);
                  }, 
                  icon: Icon(
                    Icons.arrow_back,
                    color: prev == null || isFetching ? Colors.grey : Colors.blue,
                  )          
                ),
                ElevatedButton(onPressed: () => ctx.loadCards(), child: const Text('Load cards')),
                IconButton(
                  onPressed: next == null || isFetching ? null : () async {
                    ctx.setFetching(true);
                    await ctx.loadCards(url: next);
                    ctx.setFetching(false);
                  }, 
                  icon: Icon(
                    Icons.arrow_forward,
                    color: next == null || isFetching ? Colors.grey : Colors.blue,
                  )          
                ),
              ],
            ),
            isFetching 
            ? const CircularProgressIndicator() 
            :  Expanded(
                child: ShowCards(cards: ctx.cards, deck: deck)
              )
          ],
        ),
      ),
    );
  }
}