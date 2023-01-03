import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {  

  List<String> _buildInfo(YgoCard card) {
    final info = <String>[];
    if (!card.cardType.contains('Monster')) return info;

    info.add(card.attribute.toString());

    if (card.cardType.contains('Link')) {
      info.add('Link Markers: ${card.linkmarkers.toString()}');
      info.add('ATK: ${card.atk.toString()}');
      info.add('Link Value: ${card.linkval.toString()}');

      return info;
    } 

    if (card.cardType.contains('XYZ')) {
      info.add('Rank: ${card.cardLevel.toString()}');
    } else {
      info.add('Level: ${card.cardLevel.toString()}');
    }

    info.add('ATK: ${card.atk.toString()}');
    info.add('DEF: ${card.def.toString()}');

    if (card.cardType.contains('Pendulum')) {
      info.add('Scale: ${card.cardScale.toString()}');
    }

    return info;
  }

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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(card.cardName),
                      Text(card.cardType),
                      Text(card.race),
                      for (final info in _buildInfo(card)) 
                        Text(info),
                      Text(card.description),
                    ]
                  ),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}