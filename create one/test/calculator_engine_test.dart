import 'package:calculator_app/logic/calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CalculatorEngine();

  group('CalculatorEngine.evaluate', () {
    test('evaluates basic arithmetic', () {
      expect(engine.evaluate('2+3'), 5);
      expect(engine.evaluate('10-4'), 6);
      expect(engine.evaluate('6*7'), 42);
      expect(engine.evaluate('9/2'), 4.5);
    });

    test('respects operator precedence', () {
      expect(engine.evaluate('2+3*4'), 14);
      expect(engine.evaluate('(2+3)*4'), 20);
    });

    test('handles unary minus', () {
      expect(engine.evaluate('-5+3'), -2);
      expect(engine.evaluate('3*-2'), -6);
    });

    test('evaluates powers right to left', () {
      expect(engine.evaluate('2^3^2'), 512);
      expect(engine.evaluate('2^10'), 1024);
    });

    test('supports percent as postfix operator', () {
      expect(engine.evaluate('50%'), 0.5);
      expect(engine.evaluate('200+10%'), 220);
      expect(engine.evaluate('200-10%'), 180);
    });

    test('supports functions and constants', () {
      expect(engine.evaluate('sqrt(16)'), 4);
      expect(engine.evaluate('abs(-7)'), 7);
      expect(engine.evaluate('round(2.6)'), 3);
      expect(engine.evaluate('floor(2.9)'), 2);
      expect(engine.evaluate('ceil(2.1)'), 3);
      expect(engine.evaluate('mod(10,3)'), 1);
      expect(engine.evaluate('ln(e)'), closeTo(1, 1e-9));
      expect(engine.evaluate('log(100)'), closeTo(2, 1e-9));
      expect(engine.evaluate('sin(30)'), closeTo(0.5, 1e-9));
      expect(engine.evaluate('cos(60)'), closeTo(0.5, 1e-9));
      expect(engine.evaluate('pi'), closeTo(3.14159265, 1e-6));
    });

    test('normalizes display symbols', () {
      expect(engine.evaluate('6×7'), 42);
      expect(engine.evaluate('8÷2'), 4);
      expect(engine.evaluate('√9'), 3);
    });

    test('throws on invalid expressions', () {
      expect(() => engine.evaluate(''), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('2+'), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('(2+3'), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('2/0'), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('foo(2)'), throwsA(isA<CalculatorException>()));
      expect(
        () => engine.evaluate('sqrt(-1)'),
        throwsA(isA<CalculatorException>()),
      );
    });
  });

  group('CalculatorEngine.formatNumber', () {
    test('formats integers without decimals', () {
      expect(CalculatorEngine.formatNumber(5), '5');
      expect(CalculatorEngine.formatNumber(5.0), '5');
    });

    test('removes trailing zeros', () {
      expect(CalculatorEngine.formatNumber(2.50), '2.5');
    });

    test('groups thousands when requested', () {
      expect(CalculatorEngine.formatNumber(1234567, grouping: true), '1,234,567');
      expect(CalculatorEngine.formatNumber(-1234567, grouping: true), '-1,234,567');
    });

    test('handles zero and invalid values', () {
      expect(CalculatorEngine.formatNumber(0), '0');
      expect(CalculatorEngine.formatNumber(double.nan), 'Error');
      expect(CalculatorEngine.formatNumber(double.infinity), '∞');
    });
  });
}
