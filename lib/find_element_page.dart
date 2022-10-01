import 'package:flutter/material.dart';

import 'package:tabla_periodica/tablaperiodica.dart';
import 'package:tabla_periodica/widgets.dart';

const findType = [
  'Todos',
  'Número',
  'Simbolo',
  'Elemento',
  'Grupo',
  'Periodo',
  'Peso'
];

class FindElementPage extends StatefulWidget {
  const FindElementPage({Key? key}) : super(key: key);

  @override
  State<FindElementPage> createState() => _FindElementPage();
}

class _FindElementPage extends State<FindElementPage> {
  final title = "Buscar elemento";
  final List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  final List<Widget> _results = [];

  String _currentFindType = findType[0];
  String _lastFind = "";
  bool _isFind = false;

  @override
  void initState() {
    for (var type in findType) {
      _dropDownMenuItems.add(
        DropdownMenuItem(
          value: type,
          child: Text(type),
        ),
      );
    }

    super.initState();
  }

  Future<void> newFind(String text) async {
    Iterable data;
    _lastFind = text = text.trim();

    if (text.isNotEmpty) {
      setState(() {
        _results.clear();
        _isFind = true;
      });

      if (_currentFindType == findType[0]) {
        data = TablaPeriodica.buscarPorValor2(text);
      } else {
        data = TablaPeriodica.buscarPorValorEspecifico2(_currentFindType, text);
      }

      for (final result in data) {
        _results.add(elementWidget(result));
      }

      setState(() {
        _isFind = false;
      });
    } else {
      setState(() {
        _results.clear();
      });
    }
  }

  void newType(String? currentSelect) async {
    setState(() {
      _currentFindType = currentSelect!;
    });

    await newFind(_lastFind);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              // Widgets for find:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Buscar',
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  onChanged: (text) async => await newFind(text),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Tipo de busqueda:",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                  DropdownButton(
                    value: _currentFindType,
                    items: _dropDownMenuItems,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: newType,
                  ),
                ],
              ),
              // Main divider
              const Divider(height: 5),
              // Find indicator:
              if (_isFind) const CircularProgressIndicator(),
              // Widget for results:
              Expanded(
                child: ListView.separated(
                  itemCount: (_results.isNotEmpty) ? _results.length + 2 : 0,
                  itemBuilder: (context, index) {
                    if ((index == _results.length + 1) || (index == 0)) {
                      return Container();
                    } else {
                      return _results[index - 1];
                    }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
