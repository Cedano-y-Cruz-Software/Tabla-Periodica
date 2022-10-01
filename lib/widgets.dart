import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

TextButton createTextButton(String title, String text,
    {VoidCallback? onPressed, String? image}) {
  return TextButton(
    onPressed: onPressed,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          SvgPicture.asset(
            image,
            width: 64,
            height: 64,
          ),
        const Padding(
          padding: EdgeInsets.only(right: 10),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Row elementWidget(Map<String, String> data) {
  return Row(
    children: [
      SizedBox(
        width: 120,
        child: Text(
          data['simbolo'] as String,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 70, color: Colors.black),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Número: ${data['numero'] as String}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Text(
            "Elemento: ${data['elemento'] as String}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Text(
            "Grupo: ${data['grupo'] as String}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Text(
            "Periodo: ${data['periodo'] as String}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Text(
            "Peso: ${data['peso'] as String}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      )
    ],
  );
}

Container elementAndValue(String element, String value,
    {Color? backgroundColor, TextStyle? style}) {
  backgroundColor ??= Colors.white;

  style ??= const TextStyle(
    fontSize: 15,
  );

  return Container(
    width: double.infinity,
    color: backgroundColor,
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              element,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
          const VerticalDivider(color: Colors.black),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ],
      ),
    ),
  );
}

void showAppInformation(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationIcon: SvgPicture.asset(
      'assets/images/find-element.svg',
      width: 64,
      height: 64,
    ),
    applicationName: 'Tabla Periódica',
    applicationVersion: '1.0.0',
    applicationLegalese: '©2022 Cedano & Cruz Software',
    children: [
      TextButton(
        child: const Text("Cerrar"),
        onPressed: () => Navigator.pop(context, true),
      )
    ],
  );
}

class AppInformation extends StatefulWidget {
  const AppInformation({Key? key}) : super(key: key);

  @override
  State<AppInformation> createState() => _AppInformation();
}

class _AppInformation extends State<AppInformation> {
  final title = 'Información';
  final version = '1.0.0';
  final copyright =
      '©Copyright @ 2022 Cedano & Cruz Software.\nTodos los derechos reservados.';
  final Uri appSource =
      Uri.parse('https://github.com/Cedano-y-Cruz-Software/Tabla-Periodica');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/images/find-element.svg',
                width: 64,
                height: 64,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tabla Periódica',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(version),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Text(copyright),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextButton(
                  child: const Text('Ver código'),
                  onPressed: () async => await launchUrl(
                    appSource,
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
