import 'package:flutter/material.dart';

import 'package:tabla_periodica/widgets.dart';
import 'package:tabla_periodica/find_element_page.dart';
import 'package:tabla_periodica/identify_elements_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  final title = 'Tabla Periódica';
  final HomePage homePage = const HomePage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final title = "Tabla Periódica";
  final findElementPage = const FindElementPage();
  final identifyElementsPage = const IdentifyElementsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: const Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const AppInformation(),
            ),
          ),
        ],
      ),
      body: Align(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4),
            ),
            createTextButton(
              'Buscar elemento',
              'Utilidad para la busqueda rápida de elementos de la tabla '
                  'periodica ya sea por nombre, simbolo, número, grupo, '
                  'periodo o peso.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => findElementPage),
                );
              },
              image: 'assets/images/find-element.svg',
            ),
            createTextButton(
              'Identificar elementos',
              'A partir de un compuesto muestra todos los elementos que lo '
                  'componen, además de mostrar la cantidad de atomos que posee.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => identifyElementsPage),
                );
              },
              image: 'assets/images/identify-elements.svg',
            ),
          ],
        ),
      ),
    );
  }
}
