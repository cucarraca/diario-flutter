import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const DiarioApp());
}

// Enum para los temas disponibles
enum AppTheme {
  light,
  dark,
  dracula,
  neonDark,
  cyberpunk,
  midnightBlue,
  forest,
  vampire,
  matrix,
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

  static ThemeData getNeonDarkTheme() {
    const neonBackground = Color(0xFF0A0A0A);
    const neonSurface = Color(0xFF1A1A1A);
    const neonForeground = Color(0xFFE0E0E0);
    const neonCyan = Color(0xFF00FFFF);
    const neonPink = Color(0xFFFF00FF);
    const neonGreen = Color(0xFF00FF00);
    const neonBlue = Color(0xFF0080FF);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: neonCyan,
      scaffoldBackgroundColor: neonBackground,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPink,
        surface: neonSurface,
        background: neonBackground,
        onPrimary: neonBackground,
        onSecondary: neonBackground,
        onSurface: neonForeground,
        onBackground: neonForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: neonSurface,
        foregroundColor: neonCyan,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: neonSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: neonCyan.withOpacity(0.3), width: 1),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonCyan,
        foregroundColor: neonBackground,
        elevation: 6,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: neonForeground),
        bodyMedium: TextStyle(color: neonForeground),
        titleLarge: TextStyle(color: neonCyan, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: neonCyan),
      ),
      iconTheme: const IconThemeData(color: neonCyan),
    );
  }

  static ThemeData getCyberpunkTheme() {
    const cyberpunkBackground = Color(0xFF0D1117);
    const cyberpunkSurface = Color(0xFF161B22);
    const cyberpunkForeground = Color(0xFFF0F6FC);
    const cyberpunkYellow = Color(0xFFFFD700);
    const cyberpunkRed = Color(0xFFFF073A);
    const cyberpunkPurple = Color(0xFF9A4DFF);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: cyberpunkYellow,
      scaffoldBackgroundColor: cyberpunkBackground,
      colorScheme: const ColorScheme.dark(
        primary: cyberpunkYellow,
        secondary: cyberpunkRed,
        surface: cyberpunkSurface,
        background: cyberpunkBackground,
        onPrimary: cyberpunkBackground,
        onSecondary: cyberpunkForeground,
        onSurface: cyberpunkForeground,
        onBackground: cyberpunkForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: cyberpunkSurface,
        foregroundColor: cyberpunkYellow,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: cyberpunkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cyberpunkYellow,
        foregroundColor: cyberpunkBackground,
        elevation: 6,
      ),
    );
  }

  static ThemeData getMidnightBlueTheme() {
    const midnightBackground = Color(0xFF0F1419);
    const midnightSurface = Color(0xFF1E2328);
    const midnightForeground = Color(0xFFE6EDF3);
    const midnightBlue = Color(0xFF4A9EFF);
    const midnightCyan = Color(0xFF39C5CF);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: midnightBlue,
      scaffoldBackgroundColor: midnightBackground,
      colorScheme: const ColorScheme.dark(
        primary: midnightBlue,
        secondary: midnightCyan,
        surface: midnightSurface,
        background: midnightBackground,
        onPrimary: midnightBackground,
        onSecondary: midnightBackground,
        onSurface: midnightForeground,
        onBackground: midnightForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: midnightSurface,
        foregroundColor: midnightBlue,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: midnightSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: midnightBlue,
        foregroundColor: midnightBackground,
        elevation: 6,
      ),
    );
  }

  static ThemeData getForestTheme() {
    const forestBackground = Color(0xFF0B1426);
    const forestSurface = Color(0xFF1A2332);
    const forestForeground = Color(0xFFE8F4FD);
    const forestGreen = Color(0xFF2DD4BF);
    const forestDark = Color(0xFF064E3B);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: forestGreen,
      scaffoldBackgroundColor: forestBackground,
      colorScheme: const ColorScheme.dark(
        primary: forestGreen,
        secondary: forestDark,
        surface: forestSurface,
        background: forestBackground,
        onPrimary: forestBackground,
        onSecondary: forestForeground,
        onSurface: forestForeground,
        onBackground: forestForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: forestSurface,
        foregroundColor: forestGreen,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: forestSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: forestGreen,
        foregroundColor: forestBackground,
        elevation: 6,
      ),
    );
  }

  static ThemeData getVampireTheme() {
    const vampireBackground = Color(0xFF1A0D1A);
    const vampireSurface = Color(0xFF2D1B2D);
    const vampireForeground = Color(0xFFF5F0F5);
    const vampireRed = Color(0xFFDC143C);
    const vampirePurple = Color(0xFF8B008B);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: vampireRed,
      scaffoldBackgroundColor: vampireBackground,
      colorScheme: const ColorScheme.dark(
        primary: vampireRed,
        secondary: vampirePurple,
        surface: vampireSurface,
        background: vampireBackground,
        onPrimary: vampireForeground,
        onSecondary: vampireForeground,
        onSurface: vampireForeground,
        onBackground: vampireForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: vampireSurface,
        foregroundColor: vampireRed,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: vampireSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: vampireRed,
        foregroundColor: vampireBackground,
        elevation: 6,
      ),
    );
  }

  static ThemeData getMatrixTheme() {
    const matrixBackground = Color(0xFF000000);
    const matrixSurface = Color(0xFF001100);
    const matrixForeground = Color(0xFF00FF00);
    const matrixGreen = Color(0xFF00FF41);
    const matrixDarkGreen = Color(0xFF008F11);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: matrixGreen,
      scaffoldBackgroundColor: matrixBackground,
      colorScheme: const ColorScheme.dark(
        primary: matrixGreen,
        secondary: matrixDarkGreen,
        surface: matrixSurface,
        background: matrixBackground,
        onPrimary: matrixBackground,
        onSecondary: matrixForeground,
        onSurface: matrixForeground,
        onBackground: matrixForeground,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: matrixSurface,
        foregroundColor: matrixGreen,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: const CardThemeData(
        color: matrixSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: matrixGreen,
        foregroundColor: matrixBackground,
        elevation: 6,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: matrixForeground, fontFamily: 'Courier'),
        bodyMedium: TextStyle(color: matrixForeground, fontFamily: 'Courier'),
        titleLarge: TextStyle(color: matrixGreen, fontFamily: 'Courier', fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: matrixGreen, fontFamily: 'Courier'),
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
      case AppTheme.neonDark:
        return 'Neón Oscuro';
      case AppTheme.cyberpunk:
        return 'Cyberpunk';
      case AppTheme.midnightBlue:
        return 'Azul Medianoche';
      case AppTheme.forest:
        return 'Bosque';
      case AppTheme.vampire:
        return 'Vampiro';
      case AppTheme.matrix:
        return 'Matrix';
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
      case AppTheme.neonDark:
        themeData = ThemeService.getNeonDarkTheme();
        break;
      case AppTheme.cyberpunk:
        themeData = ThemeService.getCyberpunkTheme();
        break;
      case AppTheme.midnightBlue:
        themeData = ThemeService.getMidnightBlueTheme();
        break;
      case AppTheme.forest:
        themeData = ThemeService.getForestTheme();
        break;
      case AppTheme.vampire:
        themeData = ThemeService.getVampireTheme();
        break;
      case AppTheme.matrix:
        themeData = ThemeService.getMatrixTheme();
        break;
    }

    return MaterialApp(
      title: 'Diario',
      theme: themeData,
      home: AuthPage(onThemeChanged: changeTheme, currentTheme: _currentTheme),
    );
  }
}

class EntradaDiario {
  String id;
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

class EncryptionService {
  static const String _secretKey = 'DiarioPersonalSecureKey2024';
  
  static String encryptData(String data) {
    try {
      // Convertir datos a bytes
      final dataBytes = utf8.encode(data);
      final keyBytes = utf8.encode(_secretKey);
      
      // Crear hash del key para tamaño consistente
      final keyHash = sha256.convert(keyBytes).bytes;
      
      // Encriptación simple XOR con el hash de la clave
      final encryptedBytes = <int>[];
      for (int i = 0; i < dataBytes.length; i++) {
        encryptedBytes.add(dataBytes[i] ^ keyHash[i % keyHash.length]);
      }
      
      // Convertir a base64 para almacenamiento seguro
      final encryptedBase64 = base64Encode(encryptedBytes);
      
      // Agregar header para identificar archivos encriptados
      return 'DIARIO_ENCRYPTED_V1:$encryptedBase64';
    } catch (e) {
      throw Exception('Error al encriptar datos: ${e.toString()}');
    }
  }
  
  static String decryptData(String encryptedData) {
    try {
      // Verificar header
      if (!encryptedData.startsWith('DIARIO_ENCRYPTED_V1:')) {
        throw Exception('Archivo no válido o no encriptado');
      }
      
      // Extraer datos encriptados sin el header
      final base64Data = encryptedData.substring('DIARIO_ENCRYPTED_V1:'.length);
      final encryptedBytes = base64Decode(base64Data);
      final keyBytes = utf8.encode(_secretKey);
      final keyHash = sha256.convert(keyBytes).bytes;
      
      // Desencriptación XOR
      final decryptedBytes = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyHash[i % keyHash.length]);
      }
      
      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw Exception('Error al desencriptar: Archivo corrupto o contraseña incorrecta');
    }
  }
  
  static bool isEncryptedFile(String content) {
    return content.startsWith('DIARIO_ENCRYPTED_V1:');
  }
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

  void _verEntrada(EntradaDiario entrada) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerEntradaPage(
          entrada: entrada,
          onDelete: () => _borrarEntrada(entrada),
          onEdit: (entradaEditada) => _editarEntrada(entrada, entradaEditada),
        ),
      ),
    );
    
    // Si se editó la entrada, actualizar la lista
    if (resultado != null && resultado is EntradaDiario) {
      _editarEntrada(entrada, resultado);
    }
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
            content: Text('Entrada eliminada exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Refrescar la vista actualizando el estado
        setState(() {});
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

  Future<void> _exportarEntradas() async {
    try {
      // Solicitar TODOS los permisos necesarios para Android moderno
      Map<Permission, PermissionStatus> permisos = await [
        Permission.storage,
        Permission.manageExternalStorage,
        Permission.accessMediaLocation,
      ].request();
      
      // Verificar si tenemos al menos algunos permisos básicos
      bool tienePermisos = permisos[Permission.storage]?.isGranted == true ||
                           permisos[Permission.manageExternalStorage]?.isGranted == true;
      
      if (!tienePermisos) {
        // Mostrar diálogo explicativo si no hay permisos
        final bool? abrirConfiguracion = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text('Permisos Necesarios'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Para exportar archivos necesitas conceder permisos de almacenamiento.\n'),
                Text('📁 La aplicación necesita acceso para:'),
                Text('• Guardar archivos de backup'),
                Text('• Crear carpetas personalizadas'),
                Text('• Acceso completo al almacenamiento\n'),
                Text('¿Quieres abrir la configuración para conceder permisos?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Abrir Configuración'),
              ),
            ],
          ),
        );
        
        if (abrirConfiguracion == true) {
          await openAppSettings();
          return;
        } else {
          return;
        }
      }

      // Preparar datos para exportación
      final datosExportacion = {
        'version': '1.0',
        'aplicacion': 'Diario - Diario Personal',
        'fecha_exportacion': DateTime.now().toIso8601String(),
        'total_entradas': _entradas.length,
        'entradas': _entradas.map((entrada) => {
          'id': entrada.id,
          'titulo': entrada.titulo,
          'contenido': entrada.contenido,
          'fecha': entrada.fecha.toIso8601String(),
        }).toList(),
      };

      // Convertir a JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(datosExportacion);
      
      // Encriptar los datos
      final encryptedData = EncryptionService.encryptData(jsonString);

      // Crear nombre de archivo con fecha legible
      final now = DateTime.now();
      final fechaFormateada = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
      final fileName = 'Diario_Backup_$fechaFormateada.dbe'; // .dbe = Diario Backup Encrypted

      // Mostrar diálogo de selección de ubicación
      final confirmarExport = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.security, color: Colors.green),
                SizedBox(width: 8),
                Text('Exportar Backup Seguro'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📊 ${_entradas.length} entradas listas para exportar\n'),
                Text('📄 Archivo: $fileName\n'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔐 Características del backup:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Datos encriptados para privacidad\n'
                        '• Archivo protegido (.dbe)\n'
                        '• Solo legible por esta app\n'
                        '• Selección libre de carpeta\n'
                        '• Permisos completos garantizados',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.folder_open),
                label: const Text('Seleccionar Carpeta'),
              ),
            ],
          );
        },
      );

      if (confirmarExport == true) {
        // Usar FilePicker para seleccionar directorio
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
          dialogTitle: 'Selecciona dónde guardar el backup',
          lockParentWindow: true,
        );
        
        if (selectedDirectory != null) {
          try {
            final file = File('$selectedDirectory/$fileName');
            
            // Verificar que podemos escribir en el directorio
            final testFile = File('$selectedDirectory/.test_write_diario');
            await testFile.writeAsString('test');
            await testFile.delete();
            
            // Escribir archivo encriptado
            await file.writeAsString(encryptedData);
            
            if (mounted) {
              // Mostrar diálogo de éxito con detalles
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('¡Backup Creado!'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('✅ ${_entradas.length} entradas exportadas\n'),
                        Text('📄 Archivo: $fileName\n'),
                        Text('📁 Ubicación: $selectedDirectory\n'),
                        Text('📦 Tamaño: ${(encryptedData.length / 1024).toStringAsFixed(1)} KB\n'),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🔐 Archivo encriptado y seguro',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '✅ Permisos verificados\n'
                                '✅ Archivo guardado correctamente\n'
                                '✅ Solo esta app puede leerlo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('¡Perfecto!'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (e) {
            throw Exception('No se puede escribir en la carpeta seleccionada: ${e.toString()}');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Exportación cancelada - No se seleccionó carpeta'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Error al Exportar'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('❌ No se pudo crear el backup:\n'),
                  Text('Error: ${e.toString()}\n'),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Posibles soluciones:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Conceder todos los permisos de almacenamiento\n'
                          '• Verificar espacio disponible\n'
                          '• Seleccionar carpeta con permisos de escritura\n'
                          '• Reiniciar la aplicación tras conceder permisos',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: const Text('Abrir Configuración'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _exportarEntradas(); // Reintentar
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _importarEntradas() async {
    try {
      // Mostrar diálogo de información antes de seleccionar archivo
      final confirmarImport = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.download, color: Colors.blue),
                SizedBox(width: 8),
                Text('Importar Backup'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecciona el archivo de backup a importar:\n'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📁 Formatos soportados:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• .dbe (Archivos encriptados - Recomendado)\n'
                        '• .json (Archivos antiguos sin encriptar)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.file_open),
                label: const Text('Seleccionar Archivo'),
              ),
            ],
          );
        },
      );

      if (confirmarImport != true) return;

      // 🔧 SOLICITAR PERMISOS ANTES DE SELECCIONAR ARCHIVO
      Map<Permission, PermissionStatus> permisos = await [
        Permission.storage,
        Permission.manageExternalStorage,
        Permission.accessMediaLocation,
      ].request();

      // Seleccionar archivo con configuración mejorada para Android moderno
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // 🔧 CAMBIO CRÍTICO: Permitir todos los archivos
        allowMultiple: false,
        dialogTitle: 'Seleccionar archivo de backup (.dbe o .json)',
        withData: true, // Leer contenido directamente
        allowCompression: false,
      );

      if (result != null && result.files.single.path != null) {
        final fileName = result.files.single.name;
        
        // 🔧 VERIFICAR QUE EL ARCHIVO TENGA EXTENSIÓN VÁLIDA
        if (!fileName.toLowerCase().endsWith('.dbe') && !fileName.toLowerCase().endsWith('.json')) {
          throw Exception('Archivo no válido. Solo se permiten archivos .dbe o .json\n\nArchivo seleccionado: $fileName');
        }

        // Leer archivo con múltiples métodos para máxima compatibilidad
        String fileContent;
        try {
          if (result.files.single.bytes != null) {
            // Leer desde bytes (más confiable en Android)
            fileContent = utf8.decode(result.files.single.bytes!);
          } else {
            // Leer desde path como fallback
            final file = File(result.files.single.path!);
            fileContent = await file.readAsString();
          }
        } catch (e) {
          throw Exception('No se puede leer el archivo seleccionado:\n${e.toString()}\n\nIntenta seleccionar el archivo desde otra ubicación.');
        }
        
        String jsonString;
        bool isEncrypted = false;

        // Verificar si el archivo está encriptado
        if (EncryptionService.isEncryptedFile(fileContent)) {
          // Archivo encriptado - desencriptar
          try {
            jsonString = EncryptionService.decryptData(fileContent);
            isEncrypted = true;
          } catch (e) {
            throw Exception('No se pudo desencriptar el archivo. Puede estar corrupto o ser de otra aplicación.');
          }
        } else {
          // Archivo no encriptado (JSON normal)
          jsonString = fileContent;
        }

        final datosImportacion = jsonDecode(jsonString);

        // Validar estructura del archivo
        if (datosImportacion['entradas'] != null) {
          final entradasImportadas = <EntradaDiario>[];
          
          for (final entradaData in datosImportacion['entradas']) {
            final entrada = EntradaDiario(
              id: entradaData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              titulo: entradaData['titulo'] ?? 'Sin título',
              contenido: entradaData['contenido'] ?? '',
              fecha: DateTime.tryParse(entradaData['fecha']) ?? DateTime.now(),
            );
            entradasImportadas.add(entrada);
          }

          // Mostrar diálogo de confirmación con información del archivo
          final accionImportar = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmar Importación'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📄 Archivo: $fileName'),
                    Text('🔐 ${isEncrypted ? "Encriptado ✅" : "Sin encriptar ⚠️"}'),
                    Text('📊 Entradas encontradas: ${entradasImportadas.length}'),
                    Text('📅 Fecha: ${datosImportacion['fecha_exportacion'] ?? 'Desconocida'}\n'),
                    const Text('¿Qué deseas hacer?'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '⚠️ REEMPLAZAR borrará todas tus entradas actuales\n'
                        '✅ AGREGAR mantendrá las existentes y añadirá las nuevas',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('cancelar'),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('reemplazar'),
                    style: TextButton.styleFrom(foregroundColor: Colors.orange),
                    child: const Text('REEMPLAZAR TODO'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('agregar'),
                    child: const Text('AGREGAR'),
                  ),
                ],
              );
            },
          );

          if (accionImportar != null && accionImportar != 'cancelar') {
            setState(() {
              if (accionImportar == 'reemplazar') {
                // Reemplazar todas las entradas
                _entradas = entradasImportadas;
              } else if (accionImportar == 'agregar') {
                // Agregar nuevas entradas (verificar IDs únicos)
                for (final nuevaEntrada in entradasImportadas) {
                  // Si ya existe una entrada con el mismo ID, generar uno nuevo
                  if (_entradas.any((e) => e.id == nuevaEntrada.id)) {
                    nuevaEntrada.id = DateTime.now().millisecondsSinceEpoch.toString() + 
                                    '_${_entradas.length}';
                  }
                  _entradas.add(nuevaEntrada);
                }
              }
              
              // Ordenar entradas por fecha
              _entradas.sort((a, b) => b.fecha.compareTo(a.fecha));
            });

            await _guardarEntradas();
            
            if (mounted) {
              // Mostrar diálogo de éxito
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('¡Importación Exitosa!'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accionImportar == 'reemplazar'
                            ? '🔄 Entradas reemplazadas: ${entradasImportadas.length}'
                            : '➕ Entradas agregadas: ${entradasImportadas.length}'
                        ),
                        Text('\n📊 Total actual: ${_entradas.length} entradas'),
                        Text('🔐 Archivo ${isEncrypted ? "encriptado" : "no encriptado"} procesado correctamente'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('¡Perfecto!'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        } else {
          throw Exception('Archivo inválido: no se encontró la estructura de entradas');
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Sin archivo seleccionado'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No se seleccionó ningún archivo para importar.\n'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 Para importar un backup:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1. Asegúrate de tener el archivo .dbe en tu dispositivo\n'
                            '2. Navega hasta la carpeta donde lo guardaste\n'
                            '3. Selecciona el archivo y confirma\n'
                            '4. Si no aparece, intenta desde "Descargas" o "Documentos"',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _importarEntradas(); // Reintentar
                    },
                    child: const Text('Intentar de Nuevo'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Error al Importar'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('❌ No se pudo importar el archivo:\n'),
                  Text('Error: ${e.toString()}\n'),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Verificaciones:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• ¿Es un archivo de backup válido?\n'
                          '• ¿Está corrupto o incompleto?\n'
                          '• ¿Es de otra aplicación?',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _importarEntradas(); // Reintentar
                  },
                  child: const Text('Intentar Otro Archivo'),
                ),
              ],
            );
          },
        );
      }
    }
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.upload, color: Colors.green),
                title: const Text('Exportar Entradas'),
                subtitle: Text('Crear backup (${_entradas.length} entradas)'),
                onTap: () {
                  Navigator.pop(context);
                  _exportarEntradas();
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.blue),
                title: const Text('Importar Entradas'),
                subtitle: const Text('Restaurar desde archivo JSON'),
                onTap: () {
                  Navigator.pop(context);
                  _importarEntradas();
                },
              ),
              const Divider(),
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
  final EntradaDiario? entradaParaEditar;
  
  const NuevaEntradaPage({super.key, this.entradaParaEditar});

  @override
  State<NuevaEntradaPage> createState() => _NuevaEntradaPageState();
}

class _NuevaEntradaPageState extends State<NuevaEntradaPage> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;
  double _textScaleFactor = 1.0;
  bool _isZoomMode = false;
  
  // 🎯 VARIABLES PARA CONTROLAR DICTADO TOTALMENTE MANUAL - DEFINITIVO
  String _lastRecognizedText = '';
  String _currentPartialText = '';
  bool _isManualStop = false;
  bool _isProcessingResult = false;
  int _lastResultIndex = 0;
  DateTime? _lastSpeechTime;
  bool _continuousMode = false; // INICIA EN FALSE - Control 100% manual
  String _accumulatedText = ''; // Texto acumulado sin procesar
  Timer? _speechTimer; // Timer personalizado para control de sesión

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    
    // Si estamos editando, llenar los campos
    if (widget.entradaParaEditar != null) {
      _tituloController.text = widget.entradaParaEditar!.titulo;
      _contenidoController.text = widget.entradaParaEditar!.contenido;
    }
  }

  Future<void> _initSpeech() async {
    try {
      // Solicitar permisos de audio primero
      await Permission.microphone.request();
      
      _speechEnabled = await _speech.initialize(
        onError: (errorNotification) {
          print('🔴 Error de dictado: ${errorNotification.errorMsg}');
          if (mounted) {
            // NO REINICIAR AUTOMÁTICAMENTE EN CASO DE ERROR
            setState(() {
              _isListening = false;
              _continuousMode = false;
              _isManualStop = true;
            });
            
            String mensaje = 'Error en el micrófono';
            switch(errorNotification.errorMsg) {
              case 'error_no_match':
                mensaje = 'No se detectó voz. Mantén el micrófono cerca y habla claramente.';
                break;
              case 'error_audio':
                mensaje = 'Error de audio. Verifica que el micrófono funcione correctamente.';
                break;
              case 'error_permission_denied':
                mensaje = 'Permisos de micrófono denegados. Activa los permisos en configuración.';
                break;
              case 'error_speech_timeout':
                mensaje = 'Tiempo de espera agotado. Presiona el micrófono para reanudar.';
                break;
              default:
                mensaje = 'Error: ${errorNotification.errorMsg}';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(mensaje),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'Reintentar',
                  onPressed: () => _startListening(),
                ),
              ),
            );
          }
        },
        onStatus: (status) {
          print('🔵 Estado del dictado: $status');
          
          if (mounted) {
            if (status == 'listening') {
              setState(() {
                _isListening = true;
              });
              _lastSpeechTime = DateTime.now();
              
              // INICIAR TIMER PERSONALIZADO DE 2 MINUTOS (MÁXIMO)
              _speechTimer?.cancel();
              _speechTimer = Timer(const Duration(minutes: 2), () {
                if (_isListening && !_isManualStop) {
                  print('⏰ Límite de 2 minutos alcanzado - deteniendo por seguridad');
                  _stopListening();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🕐 Dictado detenido tras 2 minutos. Presiona micrófono para continuar.'),
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              });
              
            } else if (status == 'notListening' || status == 'done') {
              print('🟡 Reconocimiento finalizado - estado: $status');
              
              // SOLO REINICIAR SI ESTÁ EN MODO CONTINUO Y NO FUE PARADA MANUAL
              if (_continuousMode && !_isManualStop && _speechEnabled && _isListening) {
                print('🔄 Reiniciando automáticamente (modo continuo activo)...');
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (_continuousMode && !_isManualStop && mounted && _speechEnabled) {
                    try {
                      _startListening();
                    } catch (error) {
                      print('🔴 Error al reiniciar: $error');
                      setState(() {
                        _isListening = false;
                        _continuousMode = false;
                      });
                    }
                  }
                });
              } else {
                // Parar definitivamente
                setState(() {
                  _isListening = false;
                });
                _speechTimer?.cancel();
              }
            }
          }
        },
      );
      
      setState(() {});
      print('🟢 Speech recognition inicializado correctamente');
    } catch (e) {
      print('🔴 Error inicializando dictado: $e');
      setState(() {
        _speechEnabled = false;
      });
    }
  }

  void _startListening() async {
    if (!_speechEnabled || _isListening) return;
    
    try {
      print('🟢 ACTIVANDO MICRÓFONO - Control 100% Manual');
      
      // Limpiar estado previo
      _speechTimer?.cancel();
      
      setState(() {
        _isListening = true;
        _isManualStop = false; // Resetear flag de parada manual
        _continuousMode = true; // ACTIVAR MODO CONTINUO SOLO AL PRESIONAR BOTÓN
        _lastRecognizedText = '';
        _currentPartialText = '';
        _accumulatedText = '';
        _isProcessingResult = false;
        _lastResultIndex = 0;
      });

      // 🎯 CONFIGURACIÓN ÓPTIMA PARA ESCUCHA CONTINUA MANUAL
      await _speech.listen(
        onResult: (result) {
          if (mounted && !_isManualStop && _continuousMode) {
            _lastSpeechTime = DateTime.now();
            
            final newText = result.recognizedWords.trim();
            
            print('🎤 RESULTADO: "${newText}" | Final: ${result.finalResult} | Confianza: ${result.confidence}');
            
            // PROCESAR SOLO RESULTADOS FINALES ÚNICOS
            if (result.finalResult && newText.isNotEmpty) {
              // Verificar que no sea duplicado
              if (newText != _lastRecognizedText) {
                final processedText = _processRecognizedTextAdvanced(newText);
                
                if (processedText.isNotEmpty) {
                  _insertTextAtCursorAdvanced(processedText);
                  _lastRecognizedText = newText;
                  
                  print('✅ TEXTO PROCESADO E INSERTADO: "$processedText"');
                } else {
                  print('⚠️ Texto procesado está vacío, ignorando...');
                }
              } else {
                print('⚠️ Resultado duplicado ignorado: "$newText"');
              }
            } else if (!result.finalResult) {
              // Solo actualizar el texto parcial para mostrar progreso
              _currentPartialText = newText;
              print('📝 Resultado parcial: "$newText"');
            }
          }
        },
        // 🎯 CONFIGURACIÓN CRÍTICA PARA CONTROL MANUAL
        listenFor: const Duration(minutes: 5), // Máximo 5 minutos por sesión
        pauseFor: const Duration(seconds: 60), // Permitir pausas largas sin cortar
        partialResults: true, // Mantener para feedback visual
        cancelOnError: false, // No cancelar por errores menores
        listenMode: stt.ListenMode.confirmation, // Modo confirmación
        localeId: 'es_ES', // Español de España para mejor reconocimiento
        onSoundLevelChange: (level) {
          // Feedback visual del nivel de sonido
          if (level > 0.1) {
            _lastSpeechTime = DateTime.now(); // Actualizar tiempo de actividad
          }
        },
      );
      
      // Mostrar confirmación visual
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mic, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('🎙️ Micrófono ACTIVADO - Control Manual'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
    } catch (e) {
      print('🔴 Error al activar micrófono: $e');
      setState(() {
        _isListening = false;
        _continuousMode = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al activar micrófono: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Reintentar',
              onPressed: () => _startListening(),
            ),
          ),
        );
      }
    }
  }

  // 🎯 FUNCIÓN MEJORADA PARA PROCESAR TEXTO CON ORTOGRAFÍA Y PUNTUACIÓN CORRECTAS
  String _processRecognizedTextAdvanced(String text) {
    if (text.isEmpty) return '';
    
    String processedText = text.trim();
    
    // 1. CAPITALIZAR PRIMERA LETRA SI ES NECESARIO
    processedText = _capitalizeTextAdvanced(processedText);
    
    // 2. CORREGIR ERRORES COMUNES DE DICTADO
    processedText = _fixCommonSpeechErrors(processedText);
    
    // 3. ASEGURAR ESPACIADO CORRECTO
    processedText = _ensureProperSpacingAdvanced(processedText);
    
    // 4. AÑADIR PUNTUACIÓN INTELIGENTE SI ES NECESARIO
    processedText = _addIntelligentPunctuation(processedText);
    
    return processedText;
  }
  
  // 🎯 FUNCIÓN PARA CORREGIR ERRORES COMUNES DEL DICTADO
  String _fixCommonSpeechErrors(String text) {
    // Diccionario de correcciones comunes en español
    final corrections = {
      // Palabras mal interpretadas por el reconocimiento de voz
      'ola': 'hola',
      'chola': 'hola', 
      'komo': 'como',
      'cómo está': 'cómo está',
      'ke': 'que',
      'q': 'que',
      'aver': 'a ver',
      'echo': 'hecho',
      'asta': 'hasta',
      'valla': 'vaya',
      'ay': 'ahí',
      'hai': 'ahí',
      'ahi': 'ahí',
      // Números en palabras
      'uno': '1',
      'dos': '2', 
      'tres': '3',
      'cuatro': '4',
      'cinco': '5',
    };
    
    String correctedText = text;
    corrections.forEach((error, correction) {
      final regex = RegExp('\\b$error\\b', caseSensitive: false);
      correctedText = correctedText.replaceAll(regex, correction);
    });
    
    return correctedText;
  }
  
  // 🎯 FUNCIÓN MEJORADA PARA CAPITALIZACIÓN INTELIGENTE
  String _capitalizeTextAdvanced(String text) {
    if (text.isEmpty) return text;
    
    final controller = _contenidoController;
    final beforeCursor = controller.text.substring(0, controller.selection.start);
    
    bool needsCapitalization = _shouldCapitalizeAdvanced(beforeCursor);
    
    if (needsCapitalization && text.isNotEmpty) {
      // Capitalizar solo la primera letra de la primera palabra
      String firstChar = text[0].toUpperCase();
      String restOfText = text.length > 1 ? text.substring(1) : '';
      
      // Mantener espacios iniciales si los había
      final leadingSpacesMatch = RegExp(r'^\s*').firstMatch(text);
      final leadingSpaces = leadingSpacesMatch?.group(0) ?? '';
      final textContent = text.substring(leadingSpaces.length);
      
      if (textContent.isNotEmpty) {
        firstChar = textContent[0].toUpperCase();
        restOfText = textContent.length > 1 ? textContent.substring(1) : '';
        return leadingSpaces + firstChar + restOfText;
      }
    }
    
    return text;
  }
    
    return text;
  }
  
  // 🎯 FUNCIÓN PARA DETERMINAR CAPITALIZACIÓN AVANZADA
  bool _shouldCapitalizeAdvanced(String textBefore) {
    if (textBefore.isEmpty) return true; // Inicio de documento
    
    final trimmed = textBefore.trim();
    if (trimmed.isEmpty) return true; // Solo espacios antes
    
    final lastChar = trimmed[trimmed.length - 1];
    
    // Capitalizar después de signos de puntuación de fin de oración
    final sentenceEnders = ['.', '!', '?', ':', ';'];
    if (sentenceEnders.contains(lastChar)) return true;
    
    // Capitalizar después de salto de línea
    if (textBefore.endsWith('\n')) return true;
    
    // Capitalizar después de patrones específicos
    final patterns = [
      RegExp(r'[.!?:;]\s*$'), // Puntuación seguida de espacios
      RegExp(r'\n\s*$'), // Nueva línea seguida de espacios
    ];
    
    for (final pattern in patterns) {
      if (pattern.hasMatch(textBefore)) return true;
    }
    
    return false;
  }
  
  // 🎯 FUNCIÓN PARA ESPACIADO INTELIGENTE MEJORADO
  String _ensureProperSpacingAdvanced(String text) {
    if (text.isEmpty) return text;
    
    final controller = _contenidoController;
    final cursorPos = controller.selection.start;
    final textBefore = controller.text.substring(0, cursorPos);
    final textAfter = controller.text.substring(cursorPos);
    
    String finalText = text.trim();
    
    // ESPACIADO ANTES: Añadir espacio si es necesario
    bool needsSpaceBefore = _needsSpaceBeforeAdvanced(textBefore, finalText);
    if (needsSpaceBefore) {
      finalText = ' ' + finalText;
    }
    
    // ESPACIADO DESPUÉS: Añadir espacio si es necesario 
    bool needsSpaceAfter = _needsSpaceAfterAdvanced(finalText, textAfter);
    if (needsSpaceAfter) {
      finalText = finalText + ' ';
    }
    
    return finalText;
  }
  
  // 🎯 FUNCIÓN PARA DETERMINAR SI NECESITA ESPACIO ANTES
  bool _needsSpaceBeforeAdvanced(String textBefore, String newText) {
    if (textBefore.isEmpty) return false; // Inicio de documento
    if (textBefore.endsWith(' ') || textBefore.endsWith('\n')) return false; // Ya hay espacio
    
    final lastChar = textBefore[textBefore.length - 1];
    final symbolsNoSpace = [',', '.', '!', '?', ';', ':', '"', "'", ')', ']', '}', '-'];
    
    // NO poner espacio después de estos símbolos
    if (symbolsNoSpace.contains(lastChar)) return false;
    
    // NO poner espacio si el nuevo texto empieza con puntuación
    final punctuationStart = RegExp(r'^[.,;:!?\'")}\]]');
    if (punctuationStart.hasMatch(newText)) return false;
    
    // En todos los demás casos, SÍ poner espacio
    return true;
  }
  
  // 🎯 FUNCIÓN PARA DETERMINAR SI NECESITA ESPACIO DESPUÉS
  bool _needsSpaceAfterAdvanced(String newText, String textAfter) {
    if (textAfter.isEmpty) return true; // Final del documento
    if (textAfter.startsWith(' ') || textAfter.startsWith('\n')) return false; // Ya hay espacio
    
    // Si el texto después empieza con puntuación, no poner espacio
    final punctuationAfter = RegExp(r'^[.,;:!?\'")}\]]');
    if (punctuationAfter.hasMatch(textAfter)) return false;
    
    // Si el nuevo texto termina con puntuación de apertura, no poner espacio
    final openingPunctuation = RegExp(r'[\'\"({[]$');
    if (openingPunctuation.hasMatch(newText)) return false;
    
    return true;
  }
  
  // 🎯 FUNCIÓN PARA AÑADIR PUNTUACIÓN INTELIGENTE
  String _addIntelligentPunctuation(String text) {
    // Por ahora retornamos el texto sin cambios
    // En el futuro se puede implementar detección de pausas para añadir comas
    return text;
  }
  
  // 🎯 FUNCIÓN MEJORADA PARA INSERTAR TEXTO EN EL CURSOR
  void _insertTextAtCursorAdvanced(String text) {
    if (text.isEmpty) return;
    
    final controller = _contenidoController;
    final selection = controller.selection;
    final currentText = controller.text;
    
    // Insertar el texto en la posición del cursor
    final beforeSelection = currentText.substring(0, selection.start);
    final afterSelection = currentText.substring(selection.end);
    
    final newText = beforeSelection + text + afterSelection;
    controller.text = newText;
    
    // Posicionar cursor al final del texto insertado
    final newCursorPos = selection.start + text.length;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPos),
    );
    
    print('📝 TEXTO INSERTADO: "$text" | Nueva posición cursor: $newCursorPos');
  }

  void _guardarEntrada() {
    if (_formKey.currentState!.validate()) {
      bool isEditing = widget.entradaParaEditar != null;
      
      final nuevaEntrada = EntradaDiario(
        id: isEditing ? widget.entradaParaEditar!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text,
        contenido: _contenidoController.text,
        fecha: isEditing ? widget.entradaParaEditar!.fecha : DateTime.now(),
      );
      Navigator.pop(context, nuevaEntrada);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.entradaParaEditar != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Entrada' : 'Nueva Entrada'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isZoomMode ? Icons.zoom_out : Icons.zoom_in),
            onPressed: () {
              setState(() {
                _isZoomMode = !_isZoomMode;
                if (!_isZoomMode) _textScaleFactor = 1.0;
              });
            },
            tooltip: _isZoomMode ? 'Salir del modo zoom' : 'Activar modo zoom',
          ),
          if (_isZoomMode) ...[
            IconButton(
              icon: const Icon(Icons.text_increase),
              onPressed: () {
                setState(() {
                  _textScaleFactor = (_textScaleFactor + 0.1).clamp(0.7, 2.5);
                });
              },
              tooltip: 'Aumentar texto',
            ),
            IconButton(
              icon: const Icon(Icons.text_decrease),
              onPressed: () {
                setState(() {
                  _textScaleFactor = (_textScaleFactor - 0.1).clamp(0.7, 2.5);
                });
              },
              tooltip: 'Disminuir texto',
            ),
          ],
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
              // Indicador de zoom si está activo
              if (_isZoomMode)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.zoom_in, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Modo Zoom Activo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${(_textScaleFactor * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 16 * _textScaleFactor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: Stack(
                  children: [
                    _isZoomMode
                        ? InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            minScale: 0.7,
                            maxScale: 3.0,
                            onInteractionUpdate: (ScaleUpdateDetails details) {
                              setState(() {
                                _textScaleFactor = details.scale.clamp(0.7, 2.5);
                              });
                            },
                            child: SingleChildScrollView(
                              child: TextFormField(
                                controller: _contenidoController,
                                decoration: InputDecoration(
                                  labelText: 'Escribe tus pensamientos...',
                                  border: const OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                  suffixIcon: _speechEnabled
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: !_isListening ? _startListening : null,
                                                icon: Icon(
                                                  Icons.mic,
                                                  color: !_isListening ? Colors.green : Colors.grey,
                                                  size: 20,
                                                ),
                                                tooltip: 'Iniciar dictado',
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minHeight: 24,
                                                  minWidth: 24,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: _isListening ? _stopListening : null,
                                                icon: Icon(
                                                  Icons.stop,
                                                  color: _isListening ? Colors.red : Colors.grey,
                                                  size: 20,
                                                ),
                                                tooltip: 'Detener dictado',
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minHeight: 24,
                                                  minWidth: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : null,
                                ),
                                maxLines: null,
                                minLines: 10,
                                textAlignVertical: TextAlignVertical.top,
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16 * _textScaleFactor,
                                  height: 1.4,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor escribe algo en tu entrada';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )
                        : TextFormField(
                            controller: _contenidoController,
                            decoration: InputDecoration(
                              labelText: 'Escribe tus pensamientos...',
                              border: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                              suffixIcon: _speechEnabled
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: !_isListening ? _startListening : null,
                                            icon: Icon(
                                              Icons.mic,
                                              color: !_isListening ? Colors.green : Colors.grey,
                                              size: 20,
                                            ),
                                            tooltip: 'Iniciar dictado',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minHeight: 24,
                                              minWidth: 24,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: _isListening ? _stopListening : null,
                                            icon: Icon(
                                              Icons.stop,
                                              color: _isListening ? Colors.red : Colors.grey,
                                              size: 20,
                                            ),
                                            tooltip: 'Detener dictado',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minHeight: 24,
                                              minWidth: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : null,
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: 16 * _textScaleFactor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor escribe algo en tu entrada';
                              }
                              return null;
                            },
                          ),
                    
                    if (_isListening)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mic, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Escuchando...',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Controles de zoom y acciones
              Row(
                children: [
                  if (_isZoomMode) ...[
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _textScaleFactor = (_textScaleFactor - 0.2).clamp(0.7, 2.5);
                                });
                              },
                              icon: const Icon(Icons.remove, size: 16),
                              label: const Text('A-', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _textScaleFactor = 1.0;
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('100%', style: TextStyle(fontSize: 10)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _textScaleFactor = (_textScaleFactor + 0.2).clamp(0.7, 2.5);
                                });
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('A+', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  if (_speechEnabled) ...[
                    // Botón para INICIAR el micrófono
                    FloatingActionButton(
                      onPressed: !_isListening ? _startListening : null,
                      backgroundColor: !_isListening ? Colors.green : Colors.grey,
                      heroTag: "voice_start",
                      mini: true,
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                      tooltip: 'Activar dictado',
                    ),
                    const SizedBox(width: 8),
                    
                    // Botón para DETENER el micrófono
                    FloatingActionButton(
                      onPressed: _isListening ? _stopListening : null,
                      backgroundColor: _isListening ? Colors.red : Colors.grey,
                      heroTag: "voice_stop",
                      mini: true,
                      child: Icon(
                        Icons.stop,
                        color: Colors.white,
                      ),
                      tooltip: 'Detener dictado',
                    ),
                    const SizedBox(width: 16),
                  ],
                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _guardarEntrada,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? 'Guardar Cambios' : 'Guardar Entrada'),
                    ),
                  ),
                ],
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
    _speechTimer?.cancel(); // Cancelar timer al salir
    super.dispose();
  }
}

class VerEntradaPage extends StatefulWidget {
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
  State<VerEntradaPage> createState() => _VerEntradaPageState();
}

class _VerEntradaPageState extends State<VerEntradaPage> {
  double _scaleFactor = 1.0;
  double _baseFontSize = 16.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entrada.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                _scaleFactor = (_scaleFactor * 1.2).clamp(0.5, 3.0);
              });
            },
            tooltip: 'Aumentar zoom',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              setState(() {
                _scaleFactor = (_scaleFactor / 1.2).clamp(0.5, 3.0);
              });
            },
            tooltip: 'Disminuir zoom',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _scaleFactor = 1.0;
              });
            },
            tooltip: 'Restablecer zoom',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editarEntrada(context),
            tooltip: 'Editar entrada',
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'edit') {
                _editarEntrada(context);
              } else if (value == 'delete') {
                _confirmarEliminar(context);
              } else if (value == 'zoom_in') {
                setState(() {
                  _scaleFactor = (_scaleFactor * 1.5).clamp(0.5, 3.0);
                });
              } else if (value == 'zoom_out') {
                setState(() {
                  _scaleFactor = (_scaleFactor / 1.5).clamp(0.5, 3.0);
                });
              } else if (value == 'reset_zoom') {
                setState(() {
                  _scaleFactor = 1.0;
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'zoom_in',
                child: Row(
                  children: [
                    const Icon(Icons.zoom_in),
                    const SizedBox(width: 8),
                    Text('Zoom + (${(_scaleFactor * 100).toInt()}%)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'zoom_out',
                child: Row(
                  children: [
                    const Icon(Icons.zoom_out),
                    const SizedBox(width: 8),
                    Text('Zoom - (${(_scaleFactor * 100).toInt()}%)'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'reset_zoom',
                child: Row(
                  children: [
                    const Icon(Icons.refresh),
                    const SizedBox(width: 8),
                    Text('Restablecer zoom (${(_scaleFactor * 100).toInt()}%)'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
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
            // Información de fecha y zoom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.entrada.fecha.day}/${widget.entrada.fecha.month}/${widget.entrada.fecha.year} - ${widget.entrada.fecha.hour.toString().padLeft(2, '0')}:${widget.entrada.fecha.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 12 * _scaleFactor,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.zoom_in, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(_scaleFactor * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Contenido con zoom interactivo
            Expanded(
              child: InteractiveViewer(
                panEnabled: true, // Permite mover el contenido
                scaleEnabled: true, // Permite hacer zoom con pellizco
                minScale: 0.5, // Zoom mínimo
                maxScale: 5.0, // Zoom máximo
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    _scaleFactor = details.scale.clamp(0.5, 3.0);
                  });
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: SelectableText(
                      widget.entrada.contenido,
                      style: TextStyle(
                        fontSize: _baseFontSize * _scaleFactor,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
            
            // Controles de zoom inferiores
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildZoomButton(
                    icon: Icons.remove,
                    label: 'Zoom -',
                    onPressed: () {
                      setState(() {
                        _scaleFactor = (_scaleFactor - 0.1).clamp(0.5, 3.0);
                      });
                    },
                  ),
                  _buildZoomButton(
                    icon: Icons.refresh,
                    label: 'Normal',
                    onPressed: () {
                      setState(() {
                        _scaleFactor = 1.0;
                      });
                    },
                  ),
                  _buildZoomButton(
                    icon: Icons.add,
                    label: 'Zoom +',
                    onPressed: () {
                      setState(() {
                        _scaleFactor = (_scaleFactor + 0.1).clamp(0.5, 3.0);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editarEntrada(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            minimumSize: const Size(0, 36),
          ),
        ),
      ),
    );
  }

  void _editarEntrada(BuildContext context) async {
    final entradaEditada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaEntradaPage(entradaParaEditar: widget.entrada),
      ),
    );
    
    if (entradaEditada != null) {
      widget.onEdit(entradaEditada);
      Navigator.pop(context, entradaEditada); // Regresar a la lista con la entrada editada
    }
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar "${widget.entrada.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Cerrar diálogo
                
                // Navegar de vuelta antes de eliminar
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Volver a la lista principal
                }
                
                // Pequeño delay para asegurar que la navegación se complete
                await Future.delayed(const Duration(milliseconds: 100));
                
                // Ahora eliminar la entrada
                widget.onDelete();
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
