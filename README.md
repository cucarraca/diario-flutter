# 📖 Diario Personal Flutter

Una aplicación de diario personal desarrollada en Flutter que permite escribir y revisar entradas diarias de forma sencilla e intuitiva.

## 🚀 Características

- ✍️ **Crear entradas**: Escribe pensamientos y experiencias diarias con título y contenido
- 📅 **Fecha y hora automática**: Cada entrada se guarda con la fecha y hora actual
- 📋 **Lista de entradas**: Visualiza todas tus entradas ordenadas por fecha
- 👀 **Vista detallada**: Lee entradas completas en una vista limpia y fácil de leer
- 💾 **Almacenamiento local**: Tus datos se guardan de forma segura en tu dispositivo

## 📱 Capturas de pantalla

La aplicación cuenta con tres pantallas principales:
- **Pantalla principal**: Lista todas las entradas del diario
- **Nueva entrada**: Formula para escribir nueva entrada
- **Ver entrada**: Muestra el contenido completo de una entrada seleccionada

## 🔧 Instalación

### Desde releases (Recomendado)
1. Ve a la sección [Releases](https://github.com/cucarraca/diario-flutter/releases)
2. Descarga la APK más reciente
3. Instala en tu dispositivo Android

### Compilar desde código fuente
```bash
# Clonar el repositorio
git clone https://github.com/cucarraca/diario-flutter.git
cd diario-flutter

# Instalar dependencias
flutter pub get

# Compilar APK
flutter build apk --release
```

## 🛠️ Tecnologías utilizadas

- **Flutter 3.35.1**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **shared_preferences**: Para almacenamiento local de datos
- **Material Design**: Interfaz de usuario moderna y atractiva

## 🏗️ Compilación automática

Este proyecto incluye GitHub Actions que:
- ✅ Compila automáticamente la APK en cada push
- 🧪 Ejecuta tests automáticos
- 📦 Genera releases automáticos con la APK
- ⬇️ Permite descargar la APK como artefacto

## 🚀 Comenzando con Flutter

Si es tu primera vez con Flutter, aquí tienes algunos recursos útiles:

- [Lab: Escribe tu primera app Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Ejemplos útiles de Flutter](https://docs.flutter.dev/cookbook)
- [Documentación online](https://docs.flutter.dev/)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ve el archivo [LICENSE](LICENSE) para más detalles.

---

Desarrollado con ❤️ usando Flutter
