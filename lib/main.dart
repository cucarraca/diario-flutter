import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Diario Personal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class EntradaDiario {
  final String id;
  final String titulo;
  final String contenido;
  final DateTime fecha;

  EntradaDiario({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'contenido': contenido,
    'fecha': fecha.toIso8601String(),
  };

  factory EntradaDiario.fromJson(Map<String, dynamic> json) => EntradaDiario(
    id: json['id'],
    titulo: json['titulo'],
    contenido: json['contenido'],
    fecha: DateTime.parse(json['fecha']),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EntradaDiario> _entradas = [];

  @override
  void initState() {
    super.initState();
    _cargarEntradas();
  }

  Future<void> _cargarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entradasJson = prefs.getString('entradas_diario');
    
    if (entradasJson != null) {
      final List<dynamic> decodedList = jsonDecode(entradasJson);
      setState(() {
        _entradas = decodedList
            .map((item) => EntradaDiario.fromJson(item))
            .toList()
          ..sort((a, b) => b.fecha.compareTo(a.fecha));
      });
    }
  }

  Future<void> _guardarEntradas() async {
    final prefs = await SharedPreferences.getInstance();
    final String entradasJson = jsonEncode(_entradas.map((e) => e.toJson()).toList());
    await prefs.setString('entradas_diario', entradasJson);
  }

  void _navegarANuevaEntrada() async {
    final nuevaEntrada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NuevaEntradaPage()),
    );
    
    if (nuevaEntrada != null) {
      setState(() {
        _entradas.insert(0, nuevaEntrada);
      });
      await _guardarEntradas();
    }
  }

  void _verEntrada(EntradaDiario entrada) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerEntradaPage(entrada: entrada),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Diario Personal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _entradas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay entradas aún',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toca el botón + para escribir tu primera entrada',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _entradas.length,
              itemBuilder: (context, index) {
                final entrada = _entradas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      entrada.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entrada.contenido,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${entrada.fecha.day}/${entrada.fecha.month}/${entrada.fecha.year} - ${entrada.fecha.hour.toString().padLeft(2, '0')}:${entrada.fecha.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    leading: const Icon(Icons.article, color: Colors.deepPurple),
                    onTap: () => _verEntrada(entrada),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarANuevaEntrada,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NuevaEntradaPage extends StatefulWidget {
  const NuevaEntradaPage({super.key});

  @override
  State<NuevaEntradaPage> createState() => _NuevaEntradaPageState();
}

class _NuevaEntradaPageState extends State<NuevaEntradaPage> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _guardarEntrada() {
    if (_formKey.currentState!.validate()) {
      final nuevaEntrada = EntradaDiario(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text,
        contenido: _contenidoController.text,
        fecha: DateTime.now(),
      );
      Navigator.pop(context, nuevaEntrada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Entrada'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarEntrada,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contenidoController,
                  decoration: const InputDecoration(
                    labelText: 'Escribe tus pensamientos...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor escribe algo en tu entrada';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarEntrada,
                  child: const Text('Guardar Entrada'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }
}

class VerEntradaPage extends StatelessWidget {
  final EntradaDiario entrada;

  const VerEntradaPage({super.key, required this.entrada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entrada.titulo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entrada.fecha.day}/${entrada.fecha.month}/${entrada.fecha.year} - ${entrada.fecha.hour.toString().padLeft(2, '0')}:${entrada.fecha.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  entrada.contenido,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
