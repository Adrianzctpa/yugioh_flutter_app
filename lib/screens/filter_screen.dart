import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/components/filter_form.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Center(
        child: FilterForm(url: url)
      ),
    );
  }
}