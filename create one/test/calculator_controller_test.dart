import 'package:calculator_app/logic/calculator_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorController', () {
    test('starts with an empty expression and a zero result', () {
      final controller = CalculatorController();

      expect(controller.expression, isEmpty);
      expect(controller.result, '0');
      expect(controller.hasHistory, isFalse);
    });

    test('input appends values to the expression', () {
      final controller = CalculatorController();

      controller.input('1');
      controller.input('2');

      expect(controller.expression, '12');
    });

    test('backspace removes the last character', () {
      final controller = CalculatorController();

      controller.input('12');
      controller.backspace();

      expect(controller.expression, '1');
    });

    test('calculate evaluates the expression and stores history', () {
      final controller = CalculatorController();

      controller.input('2');
      controller.input('+');
      controller.input('3');
      controller.calculate();

      expect(controller.result, '5');
      expect(controller.expression, isEmpty);
      expect(controller.lastExpression, '2+3');
      expect(controller.history.length, 1);
      expect(controller.history.first.result, '5');
    });

    test('calculate reports errors without changing the result', () {
      final controller = CalculatorController();

      controller.input('2');
      controller.input('/');
      controller.input('0');
      controller.calculate();

      expect(controller.errorMessage, 'Cannot divide by zero');
      expect(controller.result, '0');
      expect(controller.hasHistory, isFalse);
    });

    test('clear resets expression, result and error', () {
      final controller = CalculatorController();

      controller.input('5');
      controller.calculate();
      controller.clear();

      expect(controller.expression, isEmpty);
      expect(controller.result, '0');
      expect(controller.lastExpression, isEmpty);
      expect(controller.errorMessage, isEmpty);
    });

    test('clearHistory removes every entry', () {
      final controller = CalculatorController();

      controller.input('1+1');
      controller.calculate();
      controller.input('2+2');
      controller.calculate();
      expect(controller.history.length, 2);

      controller.clearHistory();

      expect(controller.hasHistory, isFalse);
    });

    test('useHistoryEntry restores the expression', () {
      final controller = CalculatorController();

      controller.input('3*3');
      controller.calculate();
      controller.useHistoryEntry(controller.history.first);

      expect(controller.expression, '3*3');
    });
  });
}
