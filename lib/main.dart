import 'package:flutter/material.dart';
import 'logica/baraja.dart';
import 'logica/tabla.dart';
import 'logica/motor_juego.dart';
import 'modelos/carta.dart';

void main() => runApp(const LoteriaApp());

class LoteriaApp extends StatelessWidget {
  const LoteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loteria Dolorena',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const JuegoScreen(),
    );
  }
}

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  late Tabla _tabla;
  String _ultimaCarta = 'Toca Cantar para empezar';
  Carta? _cartaCantada;

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    final baraja = Baraja.crearBarajaCompleta()..mezclar();
    _tabla = Tabla.generar(Baraja.crearBarajaCompleta().cartasRestantes);
    _motor = MotorJuego(baraja: baraja, tabla: _tabla);
    _ultimaCarta = 'Toca Cantar para empezar';
    _cartaCantada = null;
    setState(() {});
  }

  void _cantar() {
    final carta = _motor.cantarYMarcar();
    setState(() {
      _cartaCantada = carta;
      _ultimaCarta = carta?.nombre ?? 'Ya no quedan cartas';
    });
    if (_motor.haGanado) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Loteria!'),
          content: const Text('Completaste una linea, columna o diagonal.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _reiniciar();
              },
              child: const Text('Jugar de nuevo'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loteria Dolorena')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_cartaCantada != null) ...[
                      SizedBox(
                        width: 96,
                        height: 128,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _ImagenCarta(carta: _cartaCantada!),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Flexible(
                      child: Text(
                        _ultimaCarta,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, i) {
                    final f = i ~/ 4;
                    final col = i % 4;
                    final carta = _tabla.filas[f][col];
                    final marcada = _tabla.marcadas[f][col];
                    return Container(
                      margin: const EdgeInsets.all(4),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color:
                            marcada ? Colors.deepOrange : Colors.orange.shade50,
                        border: Border.all(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                _ImagenCarta(carta: carta),
                                if (marcada)
                                  Container(
                                    color: Colors.deepOrange.withAlpha(150),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              carta.nombre,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: marcada ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: _cantar,
                  icon: const Icon(Icons.campaign),
                  label: const Text('Cantar siguiente carta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagenCarta extends StatelessWidget {
  final Carta carta;
  const _ImagenCarta({required this.carta});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      carta.rutaImagen,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            carta.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}
