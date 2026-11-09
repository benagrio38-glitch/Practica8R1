class Carta {
  final int id;
  final String nombre;
  const Carta({required this.id, required this.nombre});

  String get rutaImagen =>
      'assets/cartas/${nombre.toLowerCase().replaceAll(' ', '_')}.jpg';

  @override
  bool operator ==(Object other) => other is Carta && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => nombre;
}
