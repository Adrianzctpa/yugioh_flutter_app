import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/constants/card_constants.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';
import 'package:yugioh_flutter_app/utils/api_util.dart';

class FilterForm extends StatefulWidget {
  const FilterForm({required this.url, Key? key}) : super(key: key);

  final String url;

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final TextEditingController _nameDescController = TextEditingController();
  final TextEditingController _archetypeController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _attributeController = TextEditingController();
  final TextEditingController _atkController = TextEditingController();
  final TextEditingController _defController = TextEditingController();
  final TextEditingController _scaleController = TextEditingController();
  final TextEditingController _linkValController = TextEditingController();
  final TextEditingController _linkMarkerController = TextEditingController();

  final splitArr = ['', '', '', '', '', '',];

  String _ignoreCommaOnSplit(List<String> list) {
    String str = "";
    if (list.length == 1) {
      return '"${list[0]}"';
    }

    for (int i = 0; i < list.length; i++) {
      if (list[i] != '') {
        String item = '"${list[i]}"';
          for (int j = (i + 1); j < list.length; j++) {
            if (i + 1 == list.length) {
              break;
            }

            if (list[j] != '') {
              item = '"${list[i]}",';
              break;
            }
          }
        str += item;
      }
    }

    return str;
  }

  TextFormField createTextFormField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller
    );
  }

  DropdownButtonFormField createDropdown(List list, String label, TextEditingController controller, [int? index]) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      items: list.map((val) => DropdownMenuItem(
        value: val,
        child: Text(val.toString())
      )).toList(),
      onChanged: (value) {
        if (index == null) {
          controller.text = value.toString();
          return;
        }

        if (controller.text.isEmpty) {
          setState(() {
            splitArr[index - 1] = value.toString();
          });
          controller.text = _ignoreCommaOnSplit(splitArr);
          return;
        }

        if (value != 'None') {
          setState(() {
            splitArr[index - 1] = value.toString();
          });
          controller.text = _ignoreCommaOnSplit(splitArr);
          return;
        }

        setState(() {
          splitArr[index - 1] = '';
        });

        controller.text = _ignoreCommaOnSplit(splitArr);
        return;
      } 
    );
  }

  TextField createNumField(String label, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<Cards>(context, listen: true);
    final filterMap = {
      "card_name": _nameDescController,
      "card_level": _levelController,
      "card_type": _typeController,
      "archetype": _archetypeController,
      "attribute": _attributeController,
      "race": _raceController,
      "atk": _atkController,
      "def": _defController,
      "card_scale": _scaleController,
      "linkmarkers": _linkMarkerController,
      "linkval": _linkValController,
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createTextFormField('Card Name / Description', _nameDescController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createDropdown(Constants.levelList, 'Card Level', _levelController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createDropdown(Constants.typeList, 'Card Type', _typeController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createTextFormField('Archetype', _archetypeController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createDropdown(Constants.attrList, 'Attribute', _attributeController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), 
            child: createDropdown(Constants.raceList, 'Races', _raceController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createNumField('ATK', _atkController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createNumField('DEF', _defController),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: createDropdown(Constants.scaleList, 'Scale', _scaleController),
          ),
          for (var i = 1; i < Constants.linkvalList.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: createDropdown(Constants.linkMarkerList, 'Link Marker $i', _linkMarkerController, i),
            ),
          ElevatedButton(
            onPressed: () async {
              final filteredUrl = APIUtil().generateFilterString(filterMap);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
              Navigator.of(context).pushReplacementNamed(widget.url);
              cards.setFetching(true);
              await cards.loadCards(url: filteredUrl);
              cards.setFetching(false);
            }, 
            child: const Text(
              'Submit'
            )
          )
        ]
      ),
    );
  }

}