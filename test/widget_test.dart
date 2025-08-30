// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dream_diary/main.dart';

void main() {
  testWidgets('Dream Diary app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DreamDiaryApp());

    // Verify that our app title is displayed
    expect(find.text('Dream Diary'), findsOneWidget);
    
    // Verify that the main navigation is present
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Rêves'), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);
    expect(find.text('Analyses'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
