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
  @override
  Widget build(BuildContext context) {
    final ctx = Provider.of<Cards>(context, listen: true);
    final bool isButtonDisabled = ctx.shouldBeDisabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YuGiOh Demo Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: isButtonDisabled ? null : () => ctx.loadCards(url: ctx.nextAndPrev['prev']), 
                  icon: Icon(
                    Icons.arrow_back,
                    color: isButtonDisabled ? Colors.grey : Colors.blue,
                  )          
                ),
                ElevatedButton(onPressed: () => ctx.loadCards(), child: const Text('Load cards')),
                IconButton(
                  onPressed: isButtonDisabled ? null : () => ctx.loadCards(url: ctx.nextAndPrev['next']), 
                  icon: Icon(
                    Icons.arrow_forward,
                    color: isButtonDisabled ? Colors.grey : Colors.blue,
                  )          
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: const [
                  Expanded(child: ShowCards()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}