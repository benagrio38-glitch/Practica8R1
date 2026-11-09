import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/logica/baraja.dart';
import 'package:loteria_dolorena/modelos/carta.dart';

void main() {
  test('rutaImagen se calcula a partir del nombre', () {
    const carta = Carta(id: 0, nombre: 'El Cura');
    expect(carta.rutaImagen, 'assets/cartas/el_cura.jpg');
  });

  test('cada carta de la baraja tiene su imagen', () {
    final baraja = Baraja.crearBarajaCompleta();
    for (final carta in baraja.cartasRestantes) {
      expect(File(carta.rutaImagen).existsSync(), isTrue,
          reason: 'Falta la imagen de ${carta.nombre}');
    }
  });
}
