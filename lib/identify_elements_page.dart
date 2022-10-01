import 'package:flutter/material.dart';

import 'package:tabla_periodica/tablaperiodica.dart';
import 'package:tabla_periodica/widgets.dart';

class IdentifyElementsPage extends StatefulWidget {
  const IdentifyElementsPage({Key? key}) : super(key: key);

  @override
  State<IdentifyElementsPage> createState() => _IdentifyElementsPage();
}

class _IdentifyElementsPage extends State<IdentifyElementsPage> {
  final title = "Identificar elementos";
  final List<Widget> _elements = [];

  final colorGainsboro = const Color.fromARGB(255, 242, 242, 242);
  final colorGrayCloud = const Color.fromARGB(255, 226, 226, 226);

  bool _isGetting = false;
  String _compound = "";
  String _invalidElementMessage = "";

  Future<void> _identifyElements() async {
    Map<String, int> elements;
    int counter = 0;

    try {
      elements = TablaPeriodica.identificarElementos(_compound);
    } on ValueException catch (e) {
      setState(() {
        _invalidElementMessage = e.toString().replaceFirst("Exception:", "");
        _elements.clear();
      });
      return;
    }

    setState(() {
      _invalidElementMessage = "";
      _isGetting = true;
      _elements.clear();
    });

    setState(() {
      elements.forEach((key, value) {
        _elements.add(
          elementAndValue(
            key,
            value.toString(),
            backgroundColor:
                (counter % 2 == 0) ? colorGainsboro : colorGrayCloud,
          ),
        );
        counter++;
      });
    });

    setState(() {
      _isGetting = false;
    });
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
                // Main padding
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    // Input compound
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'Compuesto',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (text) => _compound = text,
                        onSubmitted: (_) async => await _identifyElements(),
                        onEditingComplete: () {},
                      ),
                    ),
                    // Button for find
                    SizedBox(
                      height: 50.0, // <-- match_parent
                      child: TextButton(
                        onPressed: () async => await _identifyElements(),
                        child: const Text(
                          "Identificar",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 5),
              const Padding(padding: EdgeInsets.symmetric(vertical: 3.5)),
              // Find indicator:
              if (_isGetting) const CircularProgressIndicator(),
              // Columns labels
              elementAndValue(
                "Elementos:",
                "Cantidad de atomos:",
                backgroundColor: const Color.fromARGB(255, 187, 187, 187),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Show invalid element
              if (_invalidElementMessage != "")
                Text(
                  _invalidElementMessage,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              // Widget for results:
              Expanded(
                child: ListView.builder(
                  itemCount: _elements.length,
                  itemBuilder: (context, index) => _elements[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
