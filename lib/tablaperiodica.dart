class ValueException implements Exception {
  final String message;

  ValueException(this.message);

  @override
  String toString() => "Exception: $message";
}

extension _StringExtension on String {
  static List<List<String>> replaces = [
    ['á', 'a'],
    ['é', 'e'],
    ['í', 'i'],
    ['ó', 'o'],
    ['ú', 'u'],
  ];

  String normalize() {
    String salida = this;

    for (final c in replaces) {
      salida = salida.replaceAll(c[0], c[1]);
      salida = salida.replaceAll(c[0].toUpperCase(), c[1].toUpperCase());
    }
    return salida;
  }
}

class TablaPeriodica {
  static List<Map<String, String>> obtenerDatos() {
    // Retorna una lista de los elementos.

    return _elementos;
  }

  static Map<String, String> buscarPorValor(String buscar) {
    // Comprueba si el valor está contenido en alguna clave del elemento.

    buscar = buscar.toLowerCase().normalize();

    for (final elemento in _elementos) {
      for (final dato in elemento.values) {
        if (dato.toLowerCase().normalize() != buscar) {
          continue;
        } else {
          return elemento;
        }
      }
    }

    return {};
  }

  static Map<String, String> buscarPorValorEspecifico(
      String clave, String buscar) {
    // Comprueba si el valor está contenido en un clave específica del elemento.

    clave = clave.toLowerCase().normalize();
    buscar = buscar.toLowerCase().normalize();

    for (final elemento in _elementos) {
      if (elemento[clave]!.toLowerCase().normalize() == buscar) {
        return elemento;
      }
    }

    return {};
  }

  static Iterable<Map<String, String>> buscarPorValor2(String buscar) sync* {
    /* Lo mismo que buscarPorValor, pero retorna elementos hasta que no hayan
    coincidencias */

    String temp;
    buscar = buscar.toLowerCase().normalize();

    for (final elemento in _elementos) {
      for (final dato in elemento.values) {
        temp = dato.replaceAll('(', '').replaceAll(')', '');
        if (temp.toLowerCase().normalize().startsWith(buscar)) {
          yield elemento;
          break;
        }
      }
    }
  }

  static Iterable<Map<String, String>> buscarPorValorEspecifico2(
      String clave, String buscar) sync* {
    /* Lo mismo que buscarPorValorEspecifico, pero retorna elementos hasta que
    no hayan coincidencias */

    String temp;
    clave = clave.toLowerCase().normalize();
    buscar = buscar.toLowerCase().normalize();

    for (final elemento in _elementos) {
      temp = elemento[clave]!.replaceAll('(', '').replaceAll(')', '');
      if (temp.toLowerCase().normalize().startsWith(buscar)) {
        yield elemento;
      }
    }
  }

  static Map<String, int> identificarElementos(String compuesto) {
    /* Desglosa la composición elemental de un compuesto. Muestra los elementos
    habientes y la cantidad de atomos poseidos */

    compuesto = compuesto.replaceAll(' ', '');
    Map<String?, int> elementos = {};
    Map<String, String> temp;
    List<int> temp2;
    int compuestoTamanio = compuesto.length, cantidad;
    int i, j, multiplicador = 1;
    String simbolo;

    for (i = 0; i < compuestoTamanio; i++) {
      temp = {};
      simbolo = compuesto[i];

      if (simbolo == "*") {
        temp2 = _obtenerNumeros(i, compuesto);
        i = temp2[0] + 1;
        multiplicador = temp2[1];
        simbolo = compuesto[i];
      }

      if (simbolo.toUpperCase() != simbolo) {
        throw ValueException('"$simbolo" no es un elemento válido.');
      } else if ((i + 1 < compuestoTamanio) &&
          (int.tryParse(compuesto[i + 1]) == null) &&
          (compuesto[i + 1].toLowerCase() == compuesto[i + 1]) &&
          (compuesto[i + 1] != "*")) {
        simbolo = simbolo + compuesto[i + 1];
        i++;
      }

      for (final elemento in _elementos) {
        if (elemento['simbolo'] == simbolo) temp = elemento;
      }
      if (temp.isEmpty) {
        throw ValueException('"$simbolo" no es un elemento válido.');
      }

      for (j = i + 1; j < compuestoTamanio; j++) {
        if (int.tryParse(compuesto[j]) == null) {
          break;
        } else if ((j - 1 == i) && (compuesto[j] == "0")) {
          throw ValueException('"${simbolo}0" no es un valor válido.');
        }
      }

      temp2 = _obtenerNumeros(i, compuesto);
      i = temp2[0];
      cantidad = temp2[1] * multiplicador;

      if (elementos.containsKey(temp['elemento'])) {
        elementos[temp['elemento']] = elementos[temp['elemento']]! + cantidad;
      } else {
        elementos[temp['elemento']] = cantidad;
      }
    }

    return elementos.cast();
  }
}

List<int> _obtenerNumeros(int indice, String cadena) {
  int j = indice + 1;

  for (j; j < cadena.length; j++) {
    if (int.tryParse(cadena[j]) == null) {
      break;
    } else if ((j - 1 == indice) && (cadena[j] == "0")) {
      throw ValueException('"0" no es un valor válido para un elemento.');
    }
  }

  if (indice + 1 == j) {
    return [indice, 1];
  } else {
    return [j - 1, int.parse(cadena.substring(indice + 1, j))];
  }
}

const _elementos = [
  {
    'numero': '1',
    'simbolo': 'H',
    'elemento': 'Hidrógeno',
    'grupo': 'I A',
    'periodo': '1',
    'peso': '1.008'
  },
  {
    'numero': '2',
    'simbolo': 'He',
    'elemento': 'Helio',
    'grupo': 'VIII A',
    'periodo': '1',
    'peso': '4.002'
  },
  {
    'numero': '3',
    'simbolo': 'Li',
    'elemento': 'Litio',
    'grupo': 'I A',
    'periodo': '2',
    'peso': '6.939'
  },
  {
    'numero': '4',
    'simbolo': 'Be',
    'elemento': 'Berilio',
    'grupo': 'II A',
    'periodo': '2',
    'peso': '9.012'
  },
  {
    'numero': '5',
    'simbolo': 'B',
    'elemento': 'Boro',
    'grupo': 'III A',
    'periodo': '2',
    'peso': '10.81'
  },
  {
    'numero': '6',
    'simbolo': 'C',
    'elemento': 'Carbono',
    'grupo': 'IV A',
    'periodo': '2',
    'peso': '12.01'
  },
  {
    'numero': '7',
    'simbolo': 'N',
    'elemento': 'Nitrógeno',
    'grupo': 'V A',
    'periodo': '2',
    'peso': '14.00'
  },
  {
    'numero': '8',
    'simbolo': 'O',
    'elemento': 'Oxígeno',
    'grupo': 'VI A',
    'periodo': '2',
    'peso': '15.99'
  },
  {
    'numero': '9',
    'simbolo': 'F',
    'elemento': 'Flúor',
    'grupo': 'VII A',
    'periodo': '2',
    'peso': '18.99'
  },
  {
    'numero': '10',
    'simbolo': 'Ne',
    'elemento': 'Neón',
    'grupo': 'VIII A',
    'periodo': '2',
    'peso': '20.18'
  },
  {
    'numero': '11',
    'simbolo': 'Na',
    'elemento': 'Sodio',
    'grupo': 'I A',
    'periodo': '3',
    'peso': '22.98'
  },
  {
    'numero': '12',
    'simbolo': 'Mg',
    'elemento': 'Magnesio',
    'grupo': 'II A',
    'periodo': '3',
    'peso': '24.31'
  },
  {
    'numero': '13',
    'simbolo': 'Al',
    'elemento': 'Aluminio',
    'grupo': 'III A',
    'periodo': '3',
    'peso': '26.98'
  },
  {
    'numero': '14',
    'simbolo': 'Si',
    'elemento': 'Silicio',
    'grupo': 'IV A',
    'periodo': '3',
    'peso': '28.08'
  },
  {
    'numero': '15',
    'simbolo': 'P',
    'elemento': 'Fósforo',
    'grupo': 'V A',
    'periodo': '3',
    'peso': '30.97'
  },
  {
    'numero': '16',
    'simbolo': 'S',
    'elemento': 'Azufre',
    'grupo': 'VI A',
    'periodo': '3',
    'peso': '32.06'
  },
  {
    'numero': '17',
    'simbolo': 'Cl',
    'elemento': 'Cloro',
    'grupo': 'VII A',
    'periodo': '3',
    'peso': '35.45'
  },
  {
    'numero': '18',
    'simbolo': 'Ar',
    'elemento': 'Argón',
    'grupo': 'VIII A',
    'periodo': '3',
    'peso': '39.94'
  },
  {
    'numero': '19',
    'simbolo': 'K',
    'elemento': 'Potasio',
    'grupo': 'I A',
    'periodo': '4',
    'peso': '39.10'
  },
  {
    'numero': '20',
    'simbolo': 'Ca',
    'elemento': 'Calcio',
    'grupo': 'II A',
    'periodo': '4',
    'peso': '40.08'
  },
  {
    'numero': '21',
    'simbolo': 'Sc',
    'elemento': 'Escandio',
    'grupo': 'III B',
    'periodo': '4',
    'peso': '44.95'
  },
  {
    'numero': '22',
    'simbolo': 'Ti',
    'elemento': 'Titanio',
    'grupo': 'IV B',
    'periodo': '4',
    'peso': '47.90'
  },
  {
    'numero': '23',
    'simbolo': 'V',
    'elemento': 'Vanadio',
    'grupo': 'V B',
    'periodo': '4',
    'peso': '50.94'
  },
  {
    'numero': '24',
    'simbolo': 'Cr',
    'elemento': 'Cromo',
    'grupo': 'VI B',
    'periodo': '4',
    'peso': '51.99'
  },
  {
    'numero': '25',
    'simbolo': 'Mn',
    'elemento': 'Manganeso',
    'grupo': 'VII B',
    'periodo': '4',
    'peso': '54.98'
  },
  {
    'numero': '26',
    'simbolo': 'Fe',
    'elemento': 'Hierro',
    'grupo': 'VIII B',
    'periodo': '4',
    'peso': '55.84'
  },
  {
    'numero': '27',
    'simbolo': 'Co',
    'elemento': 'Cobalto',
    'grupo': 'VIII B',
    'periodo': '4',
    'peso': '58.93'
  },
  {
    'numero': '28',
    'simbolo': 'Ni',
    'elemento': 'Níquel',
    'grupo': 'VIII B',
    'periodo': '4',
    'peso': '58.7'
  },
  {
    'numero': '29',
    'simbolo': 'Cu',
    'elemento': 'Cobre',
    'grupo': 'I B',
    'periodo': '4',
    'peso': '63.54'
  },
  {
    'numero': '30',
    'simbolo': 'Zn',
    'elemento': 'Zinc',
    'grupo': 'II B',
    'periodo': '4',
    'peso': '65.37'
  },
  {
    'numero': '31',
    'simbolo': 'Ga',
    'elemento': 'Galio',
    'grupo': 'III A',
    'periodo': '4',
    'peso': '69.72'
  },
  {
    'numero': '32',
    'simbolo': 'Ge',
    'elemento': 'Germanio',
    'grupo': 'IV A',
    'periodo': '4',
    'peso': '72.59'
  },
  {
    'numero': '33',
    'simbolo': 'As',
    'elemento': 'Arsénico',
    'grupo': 'V A',
    'periodo': '4',
    'peso': '74.92'
  },
  {
    'numero': '34',
    'simbolo': 'Se',
    'elemento': 'Selenio',
    'grupo': 'VI A',
    'periodo': '4',
    'peso': '78.96'
  },
  {
    'numero': '35',
    'simbolo': 'Br',
    'elemento': 'Bromo',
    'grupo': 'VII A',
    'periodo': '4',
    'peso': '79.90'
  },
  {
    'numero': '36',
    'simbolo': 'Kr',
    'elemento': 'Kriptón',
    'grupo': 'VIII A',
    'periodo': '4',
    'peso': '83.80'
  },
  {
    'numero': '37',
    'simbolo': 'Rb',
    'elemento': 'Rubidio',
    'grupo': 'I A',
    'periodo': '5',
    'peso': '85.47'
  },
  {
    'numero': '38',
    'simbolo': 'Sr',
    'elemento': 'Estroncio',
    'grupo': 'II A',
    'periodo': '5',
    'peso': '87.62'
  },
  {
    'numero': '39',
    'simbolo': 'Y',
    'elemento': 'Itrio',
    'grupo': 'III B',
    'periodo': '5',
    'peso': '88.90'
  },
  {
    'numero': '40',
    'simbolo': 'Zr',
    'elemento': 'Circonio',
    'grupo': 'IV B',
    'periodo': '5',
    'peso': '91.22'
  },
  {
    'numero': '41',
    'simbolo': 'Nb',
    'elemento': 'Niobio',
    'grupo': 'V B',
    'periodo': '5',
    'peso': '92.90'
  },
  {
    'numero': '42',
    'simbolo': 'Mo',
    'elemento': 'Molibdeno',
    'grupo': 'VI B',
    'periodo': '5',
    'peso': '95.94'
  },
  {
    'numero': '43',
    'simbolo': 'Tc',
    'elemento': 'Tecnecio',
    'grupo': 'VII B',
    'periodo': '5',
    'peso': '(98)'
  },
  {
    'numero': '44',
    'simbolo': 'Ru',
    'elemento': 'Rutenio',
    'grupo': 'VIII B',
    'periodo': '5',
    'peso': '101.1'
  },
  {
    'numero': '45',
    'simbolo': 'Rh',
    'elemento': 'Rodio',
    'grupo': 'VIII B',
    'periodo': '5',
    'peso': '102.9'
  },
  {
    'numero': '46',
    'simbolo': 'Pd',
    'elemento': 'Paladio',
    'grupo': 'VIII B',
    'periodo': '5',
    'peso': '106.4'
  },
  {
    'numero': '47',
    'simbolo': 'Ag',
    'elemento': 'Plata',
    'grupo': 'I B',
    'periodo': '5',
    'peso': '107.8'
  },
  {
    'numero': '48',
    'simbolo': 'Cd',
    'elemento': 'Cadmio',
    'grupo': 'II B',
    'periodo': '5',
    'peso': '112.4'
  },
  {
    'numero': '49',
    'simbolo': 'In',
    'elemento': 'Indio',
    'grupo': 'III A',
    'periodo': '5',
    'peso': '114.8'
  },
  {
    'numero': '50',
    'simbolo': 'Sn',
    'elemento': 'Estaño',
    'grupo': 'IV A',
    'periodo': '5',
    'peso': '118.69'
  },
  {
    'numero': '51',
    'simbolo': 'Sb',
    'elemento': 'Antimonio',
    'grupo': 'V A',
    'periodo': '5',
    'peso': '121.7'
  },
  {
    'numero': '52',
    'simbolo': 'Te',
    'elemento': 'Telurio',
    'grupo': 'VI A',
    'periodo': '5',
    'peso': '127.8'
  },
  {
    'numero': '53',
    'simbolo': 'I',
    'elemento': 'Yodo',
    'grupo': 'VII A',
    'periodo': '5',
    'peso': '126.9'
  },
  {
    'numero': '54',
    'simbolo': 'Xe',
    'elemento': 'Xenón',
    'grupo': 'VIII A',
    'periodo': '5',
    'peso': '131.3'
  },
  {
    'numero': '55',
    'simbolo': 'Cs',
    'elemento': 'Cesio',
    'grupo': 'I A',
    'periodo': '6',
    'peso': '132.9'
  },
  {
    'numero': '56',
    'simbolo': 'Ba',
    'elemento': 'Bario',
    'grupo': 'II A',
    'periodo': '6',
    'peso': '137.3'
  },
  {
    'numero': '57',
    'simbolo': 'La',
    'elemento': 'Lantano',
    'grupo': 'III B',
    'periodo': '6',
    'peso': '138.9'
  },
  {
    'numero': '58',
    'simbolo': 'Ce',
    'elemento': 'Cerio',
    'grupo': '',
    'periodo': '6',
    'peso': '140.1'
  },
  {
    'numero': '59',
    'simbolo': 'Pr',
    'elemento': 'Praseodimio',
    'grupo': '',
    'periodo': '6',
    'peso': '140.9'
  },
  {
    'numero': '60',
    'simbolo': 'Nd',
    'elemento': 'Neodimio',
    'grupo': '',
    'periodo': '6',
    'peso': '144.2'
  },
  {
    'numero': '61',
    'simbolo': 'Pm',
    'elemento': 'Prometio',
    'grupo': '',
    'periodo': '6',
    'peso': '(145)'
  },
  {
    'numero': '62',
    'simbolo': 'Sm',
    'elemento': 'Samario',
    'grupo': '',
    'periodo': '6',
    'peso': '150.4'
  },
  {
    'numero': '63',
    'simbolo': 'Eu',
    'elemento': 'Europio',
    'grupo': '',
    'periodo': '6',
    'peso': '151.9'
  },
  {
    'numero': '64',
    'simbolo': 'Gd',
    'elemento': 'Gadolinio',
    'grupo': '',
    'periodo': '6',
    'peso': '157.2'
  },
  {
    'numero': '65',
    'simbolo': 'Tb',
    'elemento': 'Terbio',
    'grupo': '',
    'periodo': '6',
    'peso': '158.9'
  },
  {
    'numero': '66',
    'simbolo': 'Dy',
    'elemento': 'Disprosio',
    'grupo': '',
    'periodo': '6',
    'peso': '162.5'
  },
  {
    'numero': '67',
    'simbolo': 'Ho',
    'elemento': 'Holmio',
    'grupo': '',
    'periodo': '6',
    'peso': '164.9'
  },
  {
    'numero': '68',
    'simbolo': 'Er',
    'elemento': 'Erbio',
    'grupo': '',
    'periodo': '6',
    'peso': '167.3'
  },
  {
    'numero': '69',
    'simbolo': 'Tm',
    'elemento': 'Tulio',
    'grupo': '',
    'periodo': '6',
    'peso': '168.9'
  },
  {
    'numero': '70',
    'simbolo': 'Yb',
    'elemento': 'Iterbio',
    'grupo': '',
    'periodo': '6',
    'peso': '173.0'
  },
  {
    'numero': '71',
    'simbolo': 'Lu',
    'elemento': 'Lutecio',
    'grupo': '',
    'periodo': '6',
    'peso': '174.9'
  },
  {
    'numero': '72',
    'simbolo': 'Hf',
    'elemento': 'Hafnio',
    'grupo': 'IV B',
    'periodo': '6',
    'peso': '178.5'
  },
  {
    'numero': '73',
    'simbolo': 'Ta',
    'elemento': 'Tantalio',
    'grupo': 'V B',
    'periodo': '6',
    'peso': '180.9'
  },
  {
    'numero': '74',
    'simbolo': 'W',
    'elemento': 'Wolframio',
    'grupo': 'VI B',
    'periodo': '6',
    'peso': '183.8'
  },
  {
    'numero': '75',
    'simbolo': 'Re',
    'elemento': 'Renio',
    'grupo': 'VII B',
    'periodo': '6',
    'peso': '186.2'
  },
  {
    'numero': '76',
    'simbolo': 'Os',
    'elemento': 'Osmio',
    'grupo': 'VIII B',
    'periodo': '6',
    'peso': '190.2'
  },
  {
    'numero': '77',
    'simbolo': 'Ir',
    'elemento': 'Iridio',
    'grupo': 'VIII B',
    'periodo': '6',
    'peso': '192.2'
  },
  {
    'numero': '78',
    'simbolo': 'Pt',
    'elemento': 'Platino',
    'grupo': 'VIII B',
    'periodo': '6',
    'peso': '195.1'
  },
  {
    'numero': '79',
    'simbolo': 'Au',
    'elemento': 'Oro',
    'grupo': 'I B',
    'periodo': '6',
    'peso': '196.9'
  },
  {
    'numero': '80',
    'simbolo': 'Hg',
    'elemento': 'Mercurio',
    'grupo': 'II B',
    'periodo': '6',
    'peso': '200.6'
  },
  {
    'numero': '81',
    'simbolo': 'Tl',
    'elemento': 'Talio',
    'grupo': 'III A',
    'periodo': '6',
    'peso': '204.4'
  },
  {
    'numero': '82',
    'simbolo': 'Pb',
    'elemento': 'Plomo',
    'grupo': 'IV A',
    'periodo': '6',
    'peso': '207.2'
  },
  {
    'numero': '83',
    'simbolo': 'Bi',
    'elemento': 'Bismuto',
    'grupo': 'V A',
    'periodo': '6',
    'peso': '208.9'
  },
  {
    'numero': '84',
    'simbolo': 'Po',
    'elemento': 'Polonio',
    'grupo': 'VI A',
    'periodo': '6',
    'peso': '(210)'
  },
  {
    'numero': '85',
    'simbolo': 'At',
    'elemento': 'Ástato',
    'grupo': 'VII A',
    'periodo': '6',
    'peso': '(210)'
  },
  {
    'numero': '86',
    'simbolo': 'Rn',
    'elemento': 'Radón',
    'grupo': 'VIII A',
    'periodo': '6',
    'peso': '(222)'
  },
  {
    'numero': '87',
    'simbolo': 'Fr',
    'elemento': 'Francio',
    'grupo': 'I A',
    'periodo': '7',
    'peso': '(223)'
  },
  {
    'numero': '88',
    'simbolo': 'Ra',
    'elemento': 'Radio',
    'grupo': 'II A',
    'periodo': '7',
    'peso': '226'
  },
  {
    'numero': '89',
    'simbolo': 'Ac',
    'elemento': 'Actinio',
    'grupo': 'III B',
    'periodo': '7',
    'peso': '227'
  },
  {
    'numero': '90',
    'simbolo': 'Th',
    'elemento': 'Torio',
    'grupo': '',
    'periodo': '7',
    'peso': '232'
  },
  {
    'numero': '91',
    'simbolo': 'Pa',
    'elemento': 'Protactinio',
    'grupo': '',
    'periodo': '7',
    'peso': '(231)'
  },
  {
    'numero': '92',
    'simbolo': 'U',
    'elemento': 'Uranio',
    'grupo': '',
    'periodo': '7',
    'peso': '238.0'
  },
  {
    'numero': '93',
    'simbolo': 'Np',
    'elemento': 'Neptunio',
    'grupo': '',
    'periodo': '7',
    'peso': '(237)'
  },
  {
    'numero': '94',
    'simbolo': 'Pu',
    'elemento': 'Plutonio',
    'grupo': '',
    'periodo': '7',
    'peso': '(244)'
  },
  {
    'numero': '95',
    'simbolo': 'Am',
    'elemento': 'Americio',
    'grupo': '',
    'periodo': '7',
    'peso': '(243)'
  },
  {
    'numero': '96',
    'simbolo': 'Cm',
    'elemento': 'Curio',
    'grupo': '',
    'periodo': '7',
    'peso': '(247)'
  },
  {
    'numero': '97',
    'simbolo': 'Bk',
    'elemento': 'Berkelio',
    'grupo': '',
    'periodo': '7',
    'peso': '(247)'
  },
  {
    'numero': '98',
    'simbolo': 'Cf',
    'elemento': 'Californio',
    'grupo': '',
    'periodo': '7',
    'peso': '(251)'
  },
  {
    'numero': '99',
    'simbolo': 'Es',
    'elemento': 'Einsteinio',
    'grupo': '',
    'periodo': '7',
    'peso': '(252)'
  },
  {
    'numero': '100',
    'simbolo': 'Fm',
    'elemento': 'Fermio',
    'grupo': '',
    'periodo': '7',
    'peso': '(257)'
  },
  {
    'numero': '101',
    'simbolo': 'Md',
    'elemento': 'Mendelevio',
    'grupo': '',
    'periodo': '7',
    'peso': '(258)'
  },
  {
    'numero': '102',
    'simbolo': 'No',
    'elemento': 'Nobelio',
    'grupo': '',
    'periodo': '7',
    'peso': '(259)'
  },
  {
    'numero': '103',
    'simbolo': 'Lr',
    'elemento': 'Lawrencio',
    'grupo': '',
    'periodo': '7',
    'peso': '(260)'
  },
  {
    'numero': '104',
    'simbolo': 'Ku',
    'elemento': 'Kurchatovio',
    'grupo': 'IV B',
    'periodo': '7',
    'peso': '(261)'
  },
  {
    'numero': '105',
    'simbolo': 'Ha',
    'elemento': 'Hahnio',
    'grupo': 'V B',
    'periodo': '7',
    'peso': '(262)'
  },
  {
    'numero': '106',
    'simbolo': 'Nt',
    'elemento': 'Antidilio',
    'grupo': 'VI B',
    'periodo': '7',
    'peso': '(263)'
  },
  {
    'numero': '107',
    'simbolo': 'Gp',
    'elemento': 'Gerphanio',
    'grupo': 'VII B',
    'periodo': '7',
    'peso': '(262)'
  },
  {
    'numero': '108',
    'simbolo': 'Hr',
    'elemento': 'Horkaichi',
    'grupo': 'VIII B',
    'periodo': '7',
    'peso': '(265)'
  },
  {
    'numero': '109',
    'simbolo': 'Wi',
    'elemento': 'Wolschakio',
    'grupo': 'VIII B',
    'periodo': '7',
    'peso': '(266)'
  },
  {
    'numero': '110',
    'simbolo': 'Mv',
    'elemento': 'Madvedev',
    'grupo': 'VIII B',
    'periodo': '7',
    'peso': '(267)'
  },
  {
    'numero': '111',
    'simbolo': 'Pl',
    'elemento': 'Plutirio',
    'grupo': 'I B',
    'periodo': '7',
    'peso': '(268)'
  },
  {
    'numero': '112',
    'simbolo': 'Da',
    'elemento': 'Darwanzio',
    'grupo': 'II B',
    'periodo': '7',
    'peso': '(269)'
  },
  {
    'numero': '113',
    'simbolo': 'Tf',
    'elemento': 'Tusfrano',
    'grupo': 'III A',
    'periodo': '7',
    'peso': '(270)'
  },
  {
    'numero': '114',
    'simbolo': 'Eo',
    'elemento': 'Erristeneo',
    'grupo': 'IV A',
    'periodo': '7',
    'peso': '(272)'
  },
  {
    'numero': '115',
    'simbolo': 'Me',
    'elemento': 'Merchel',
    'grupo': 'V A',
    'periodo': '7',
    'peso': '(276)'
  },
  {
    'numero': '116',
    'simbolo': 'Nc',
    'elemento': 'Nectarén',
    'grupo': 'VI A',
    'periodo': '7',
    'peso': '(279)'
  },
  {
    'numero': '117',
    'simbolo': 'El',
    'elemento': 'Efelio',
    'grupo': 'VII A',
    'periodo': '7',
    'peso': '(282)'
  },
  {
    'numero': '118',
    'simbolo': 'On',
    'elemento': 'Oberón',
    'grupo': 'VIII A',
    'periodo': '7',
    'peso': '(285)'
  }
];
