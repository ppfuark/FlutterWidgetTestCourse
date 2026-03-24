import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_class/main.dart';

void main() {
  // https://www.youtube.com/watch?v=6usqzoKYXag

  testWidgets('Home page tests', (tester) async {
    print("Step No: 1, Application startup");
    await tester.pumpWidget(MyApp());

    print("Step No: 2, Check if find title");
    find.text("You have pushed the button this many times:");

    print("Step No: 3, Check if find 2 titles");
    final title = find.text("You have pushed the button this many times:");
    expect(title, findsNWidgets(2));

    print("Step No: 4, Click on increment button");
    final floatingButton = find.byType(FloatingActionButton);
    tester.tap(floatingButton);
    await tester.pump(); // use when have a setState() call

    print("Step No: 5, Check if increment button works");
    expect(find.text('1'), findsOneWidget);

    print("Step No: 6, Click on increment button, bykey");
    final floatingButtonKey = find.byKey(Key("increment_button"));
    tester.tap(floatingButtonKey);
    await tester.pump(); // use when have a setState() call

    print("Step No: 6, Check if increment button works, using key");
    expect(find.text('2'), findsOneWidget);
  });
  // testWidgets(
  //   'Test increment button, and values when increment',
  //   (tester) async {
  //     tester.pumpWidget(MyApp());
  //   },
  // );
}
