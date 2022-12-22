import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {  
  @override
  Widget build(BuildContext context) {
    final card = ModalRoute.of(context)!.settings.arguments as YgoCard;

    return Scaffold(
      appBar: AppBar(
        title: Text(card.cardName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 400,
                  child: Image.file(File(card.imageUrl[0]))
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Text(card.cardName),
                    Text(card.cardType),
                    Text(card.description)
                  ]
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}