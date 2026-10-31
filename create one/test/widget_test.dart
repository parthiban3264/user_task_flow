import 'package:calculator_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator performs a simple calculation', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Calculator'), findsOneWidget);

    await tester.tap(find.text('7'));
    await tester.tap(find.text('×'));
    await tester.tap(find.text('6'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('clear button resets the display', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('9'));
    await tester.pump();
    expect(find.text('9'), findsOneWidget);

    await tester.tap(find.text('C'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('division by zero shows an error message', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('5'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('0'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('Cannot divide by zero'), findsOneWidget);
  });
}
