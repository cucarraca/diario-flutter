import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';

void main() {
  runApp(const DiarioApp());
}

// Enum para los temas disponibles
enum AppTheme {
  light,
  dark,
  dracula,
}

// Clase para gestionar temas
class ThemeService {
  static const String _themeKey = 'app_theme';

  static Future<AppTheme> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    return AppTheme.values[themeIndex];
  }

  static Future<void> setTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.purple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
      ),
    );
  }

  static ThemeData getDraculaTheme() {
    const draculaBackground = Color(0xFF282A36);
    const draculaCurrentLine = Color(0xFF44475A);
    const draculaForeground = Color(0xFFF8F8F2);
    const draculaComment = Color(0xFF6272A4);
    const draculaCyan = Color(0xFF8BE9FD);
    const draculaGreen = Color(0xFF50FA7B);
    const draculaOrange = Color(0xFFFFB86C);
    const draculaPink = Color(0xFFFF79C6);
    const draculaPurple = Color(0xFFBD93F9);
    const draculaRed = Color(0xFFFF5555);
    const draculaYellow = Color(0xFFF1FA8C);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: draculaPurple,
      scaffoldBackgroundColor: draculaBackground,
      colorScheme: const ColorScheme.dark(
        primary: draculaPurple,
        secondary: draculaPink,
        surface: draculaCurrentLine,
        background: draculaBackground,
        onPrimary: draculaBackground,
        onSecondary: draculaBackground,
        onSurface: draculaForeground,
        onBackground: draculaForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: draculaCurrentLine,
        foregroundColor: draculaForeground,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: draculaCurrentLine,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: draculaPurple,
        foregroundColor: draculaBackground,
        elevation: 6,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: draculaForeground),
        bodyMedium: TextStyle(color: draculaForeground),
        titleLarge: TextStyle(color: draculaForeground),
        titleMedium: TextStyle(color: draculaForeground),
      ),
      iconTheme: const IconThemeData(color: draculaForeground),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: draculaCurrentLine,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: draculaComment),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: draculaComment),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: draculaPurple, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: draculaPurple,
          foregroundColor: draculaBackground,
        ),
      ),
    );
  }

  static String getThemeName(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return 'Tema Claro';
      case AppTheme.dark:
        return 'Tema Oscuro';
      case AppTheme.dracula:
        return 'Dracula';
    }
  }
}

class DiarioApp extends StatefulWidget {
  const DiarioApp({super.key});

  @override
  State<DiarioApp> createState() => _DiarioAppState();
}

class _DiarioAppState extends State<DiarioApp> {
  AppTheme _currentTheme = AppTheme.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await ThemeService.getTheme();
    setState(() {
      _currentTheme = theme;
    });
  }

  Future<void> changeTheme(AppTheme newTheme) async {
    await ThemeService.setTheme(newTheme);
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    switch (_currentTheme) {
      case AppTheme.light:
        themeData = ThemeService.getLightTheme();
        break;
      case AppTheme.dark:
        themeData = ThemeService.getDarkTheme();
        break;
      case AppTheme.dracula:
        themeData = ThemeService.getDraculaTheme();
        break;
    }

    return MaterialApp(
      title: 'Mi Diario Personal',
      theme: themeData,
      home: AuthPage(onThemeChanged: changeTheme, currentTheme: _currentTheme),
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
  final Function(AppTheme) onThemeChanged;
  final AppTheme currentTheme;
  
  const AuthPage({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

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
      MaterialPageRoute(
        builder: (context) => HomePage(
          onThemeChanged: widget.onThemeChanged,
          currentTheme: widget.currentTheme,
        ),
      ),
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
        actions: [
          PopupMenuButton<AppTheme>(
            icon: const Icon(Icons.palette),
            tooltip: 'Cambiar tema',
            onSelected: (AppTheme theme) {
              widget.onThemeChanged(theme);
            },
            itemBuilder: (BuildContext context) => AppTheme.values.map((AppTheme theme) {
              return PopupMenuItem<AppTheme>(
                value: theme,
                child: Row(
                  children: [
                    Icon(
                      theme == widget.currentTheme ? Icons.check : Icons.circle,
                      color: theme == widget.currentTheme 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                    ),
                    const SizedBox(width: 8),
                    Text(ThemeService.getThemeName(theme)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
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
  final Function(AppTheme) onThemeChanged;
  final AppTheme currentTheme;
  
  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

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
        builder: (context) => VerEntradaPage(
          entrada: entrada,
          onDelete: () => _borrarEntrada(entrada),
          onEdit: (entradaEditada) => _editarEntrada(entrada, entradaEditada),
        ),
      ),
    );
  }

  Future<void> _borrarEntrada(EntradaDiario entrada) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar la entrada "${entrada.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        _entradas.removeWhere((e) => e.id == entrada.id);
      });
      await _guardarEntradas();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrada eliminada'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Volver a la lista si estamos viendo la entrada
      }
    }
  }

  void _editarEntrada(EntradaDiario entradaOriginal, EntradaDiario entradaEditada) {
    setState(() {
      final index = _entradas.indexWhere((e) => e.id == entradaOriginal.id);
      if (index != -1) {
        _entradas[index] = entradaEditada;
        _entradas.sort((a, b) => b.fecha.compareTo(a.fecha));
      }
    });
    _guardarEntradas();
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
                leading: const Icon(Icons.palette),
                title: const Text('Cambiar Tema'),
                subtitle: Text(ThemeService.getThemeName(widget.currentTheme)),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarSelectorTemas();
                },
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
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Eliminar Todas las Entradas', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarConfirmacionBorrarTodas();
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

  void _mostrarSelectorTemas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppTheme.values.map((AppTheme theme) {
              return RadioListTile<AppTheme>(
                title: Text(ThemeService.getThemeName(theme)),
                value: theme,
                groupValue: widget.currentTheme,
                onChanged: (AppTheme? value) {
                  if (value != null) {
                    widget.onThemeChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarConfirmacionBorrarTodas() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⚠️ Eliminar Todo'),
          content: const Text(
            'Esta acción eliminará TODAS las entradas del diario de forma permanente.\n\n¿Estás completamente seguro?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('SÍ, ELIMINAR TODO'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        _entradas.clear();
      });
      await _guardarEntradas();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las entradas han sido eliminadas'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _mostrarCambiarPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CambiarPasswordPage()),
    );
  }

  void _cerrarSesion() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => AuthPage(
          onThemeChanged: widget.onThemeChanged,
          currentTheme: widget.currentTheme,
        ),
      ),
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
                return Dismissible(
                  key: Key(entrada.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: Text('¿Eliminar "${entrada.titulo}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      _entradas.removeAt(index);
                    });
                    _guardarEntradas();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${entrada.titulo} eliminada'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Card(
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
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'delete') {
                            _borrarEntrada(entrada);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _verEntrada(entrada),
                    ),
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
  final VoidCallback onDelete;
  final Function(EntradaDiario) onEdit;

  const VerEntradaPage({
    super.key,
    required this.entrada,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entrada.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'delete') {
                _confirmarEliminar(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${entrada.fecha.day}/${entrada.fecha.month}/${entrada.fecha.year} - ${entrada.fecha.hour.toString().padLeft(2, '0')}:${entrada.fecha.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _confirmarEliminar(context),
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar "${entrada.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
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
