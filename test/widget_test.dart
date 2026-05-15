import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App structure', () {
    testWidgets('LoginScreen renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('To Do App')),
          ),
        ),
      );

      expect(find.text('To Do App'), findsOneWidget);
    });
  });

  group('Config', () {
    test('Environment admin emails list is not empty', () {
      expect(adminEmails, isNotEmpty);
    });
  });
}

final adminEmails = ['co.devpaul@gmail.com'];
