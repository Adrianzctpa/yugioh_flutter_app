import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/show_cards.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends State<CardsScreen> {

  void providerFunc() {
    Provider.of<Cards>(context, listen: false).loadCards();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YuGiOh Demo Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: providerFunc, child: const Text('Hello World')),
            const Expanded(child: ShowCards()),
          ],
        ),
      ),
    );
  }
}