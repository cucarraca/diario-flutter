// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diario_flutter/main.dart';

void main() {
  testWidgets('Diario app authentication smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiarioApp());

    // Verify that our app starts with authentication screen.
    expect(find.text('¡Bienvenido!'), findsOneWidget);
    
    // Verify that there are password fields for first time setup.
    expect(find.text('Nueva Contraseña'), findsOneWidget);
    expect(find.text('Confirmar Contraseña'), findsOneWidget);
    
    // Verify that there's a configuration button.
    expect(find.text('Configurar Diario'), findsOneWidget);
  });
}
