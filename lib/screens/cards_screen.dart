import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/filter_form.dart';
import 'package:yugioh_flutter_app/components/show_cards.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('YuGiOh Demo Home Page'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.filter_alt_outlined),
            );
          }
        )
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('Filter', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            FilterForm()
          ],
        )
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: prev == null ? null : () => ctx.loadCards(url: prev), 
                  icon: Icon(
                    Icons.arrow_back,
                    color: prev == null ? Colors.grey : Colors.blue,
                  )          
                ),
                ElevatedButton(onPressed: () => ctx.loadCards(), child: const Text('Load cards')),
                IconButton(
                  onPressed: next == null ? null : () => ctx.loadCards(url: next), 
                  icon: Icon(
                    Icons.arrow_forward,
                    color: next == null ? Colors.grey : Colors.blue,
                  )          
                ),
              ],
            ),
            const Expanded(
              child: ShowCards()
            )
          ],
        ),
      ),
    );
  }
}