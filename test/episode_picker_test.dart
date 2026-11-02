import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/features/player/episode_picker.dart';

void main() {
  testWidgets('episode picker starts near current episode and returns chosen index', (tester) async {
    int? chosen;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                chosen = await showEpisodePicker(context, numbers: List.generate(100, (i) => i + 1), selected: 75);
              },
              child: const Text('Episodes'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Episodes'));
    await tester.pumpAndSettle();
    expect(find.text('76'), findsOneWidget);
    await tester.tap(find.text('77'));
    await tester.pumpAndSettle();
    expect(chosen, 76);
    expect(tester.takeException(), isNull);
  });
}
