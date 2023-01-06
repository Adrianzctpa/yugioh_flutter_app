import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YuGiOh Demo Home Page'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_outlined),
            );
          }
        )
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('Options', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), 
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/cards'), 
                child: const Text('View Cards')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/decks'), 
                child: const Text('Deck Building')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/filter', arguments: '/cards'), 
                child: const Text('Filter')
              ),
            ),
          ],
        )
      ),
      body: child
    );
  }
}