import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';

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
      home: const AuthPage(),
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

class AuthService {
  static const String _passwordKey = 'diario_password';
  static const String _isFirstTimeKey = 'is_first_time';

  // Encriptar contraseña usando SHA-256
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verificar si es la primera vez que se abre la app
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  // Configurar contraseña por primera vez
  static Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = _hashPassword(password);
    await prefs.setString(_passwordKey, hashedPassword);
    await prefs.setBool(_isFirstTimeKey, false);
  }

  // Verificar contraseña
  static Future<bool> verifyPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString(_passwordKey);
    if (storedHash == null) return false;
    
    final inputHash = _hashPassword(password);
    return storedHash == inputHash;
  }

  // Cambiar contraseña (requiere contraseña actual)
  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (await verifyPassword(currentPassword)) {
      await setPassword(newPassword);
      return true;
    }
    return false;
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isFirstTime = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final isFirst = await AuthService.isFirstTime();
    setState(() {
      _isFirstTime = isFirst;
    });
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFirstTime) {
        // Configurar contraseña por primera vez
        await AuthService.setPassword(_passwordController.text);
        _navigateToHome();
      } else {
        // Verificar contraseña
        final isValid = await AuthService.verifyPassword(_passwordController.text);
        if (isValid) {
          _navigateToHome();
        } else {
          _showErrorMessage('Contraseña incorrecta');
        }
      }
    } catch (e) {
      _showErrorMessage('Error: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isFirstTime ? 'Configurar Diario' : 'Mi Diario Personal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono del diario
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.book,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Título y descripción
                Text(
                  _isFirstTime ? '¡Bienvenido!' : '¡Hola de nuevo!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  _isFirstTime 
                    ? 'Configura una contraseña para proteger tu diario personal'
                    : 'Ingresa tu contraseña para acceder a tu diario',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Campo de contraseña
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: _isFirstTime ? 'Nueva Contraseña' : 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una contraseña';
                      }
                      if (_isFirstTime && value.length < 4) {
                        return 'La contraseña debe tener al menos 4 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                
                if (_isFirstTime) ...[
                  const SizedBox(height: 16),
                  
                  // Confirmar contraseña (solo en primera vez)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirma tu contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Botón de acceder/configurar
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuth,
                      child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _isFirstTime ? 'Configurar Diario' : 'Acceder al Diario',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                ),
                
                if (_isFirstTime) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tu contraseña se almacena de forma segura en tu dispositivo. Asegúrate de recordarla.',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
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

  void _mostrarMenuConfiguracion() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Configuración',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Cambiar Contraseña'),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarCambiarPassword();
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _cerrarSesion();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _mostrarCambiarPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CambiarPasswordPage()),
    );
  }

  void _cerrarSesion() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Diario Personal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _mostrarMenuConfiguracion,
            tooltip: 'Configuración',
          ),
        ],
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
                    textAlign: TextAlign.center,
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
        tooltip: 'Nueva Entrada',
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

class CambiarPasswordPage extends StatefulWidget {
  const CambiarPasswordPage({super.key});

  @override
  State<CambiarPasswordPage> createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  Future<void> _cambiarPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña cambiada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña actual es incorrecta'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Contraseña actual
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: 'Contraseña Actual',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureCurrent = !_obscureCurrent;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña actual';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Nueva contraseña
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una nueva contraseña';
                  }
                  if (value.length < 4) {
                    return 'La contraseña debe tener al menos 4 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Confirmar nueva contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirmar Nueva Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirma tu nueva contraseña';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Botón cambiar contraseña
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _cambiarPassword,
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Cambiar Contraseña',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
