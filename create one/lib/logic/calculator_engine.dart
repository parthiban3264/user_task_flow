import 'dart:math' as math;

/// Error raised when an expression cannot be evaluated.
class CalculatorException implements Exception {
  const CalculatorException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Pure expression engine used by the calculator.
///
/// Supports:
///  * Basic arithmetic: `+`, `-`, `*`, `/`
///  * Power: `^` (right associative)
///  * Percent as a postfix operator (`10%` -> `0.1`)
///  * Parentheses and unary minus
///  * Functions: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `log`, `ln`,
///    `sqrt`, `abs`, `round`, `floor`, `ceil`, `mod`
///  * Constants: `pi`, `e`
///
/// Trigonometric functions work in degrees.
class CalculatorEngine {
  const CalculatorEngine();

  static const Set<String> _functions = {
    'sin',
    'cos',
    'tan',
    'asin',
    'acos',
    'atan',
    'log',
    'ln',
    'sqrt',
    'abs',
    'round',
    'floor',
    'ceil',
    'mod',
  };

  static const Set<String> _constants = {'pi', 'e'};

  /// Evaluates [expression] and returns the result.
  ///
  /// Throws a [CalculatorException] when the expression is invalid.
  double evaluate(String expression) {
    final normalized = _normalize(expression);

    if (normalized.isEmpty) {
      throw const CalculatorException('Nothing to calculate');
    }

    final tokens = _tokenize(normalized);
    return _Parser(tokens).parse();
  }

  /// Formats [value] for display.
  ///
  /// When [grouping] is true the integer part is separated with `,`.
  static String formatNumber(double value, {bool grouping = false}) {
    if (value.isNaN) {
      return 'Error';
    }
    if (value.isInfinite) {
      return value.isNegative ? '-∞' : '∞';
    }
    if (value == 0) {
      return '0';
    }

    final absolute = value.abs();
    if (absolute >= 1e12 || absolute < 1e-9) {
      var exponential = value.toStringAsExponential(6);
      exponential = exponential.replaceFirst(
        RegExp(r'0+e'),
        'e',
      );
      return exponential;
    }

    var text = value.toStringAsFixed(10);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      text = text.replaceFirst(RegExp(r'\.$'), '');
    }

    if (!grouping) {
      return text;
    }

    final isNegative = text.startsWith('-');
    final unsigned = isNegative ? text.substring(1) : text;
    final parts = unsigned.split('.');
    final integer = parts.first;
    final decimals = parts.length > 1 ? '.${parts[1]}' : '';

    final buffer = StringBuffer();
    for (var i = 0; i < integer.length; i++) {
      if (i > 0 && (integer.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integer[i]);
    }

    return '${isNegative ? '-' : ''}$buffer$decimals';
  }

  String _normalize(String input) {
    return input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        .replaceAll(' ', '');
  }

  List<_Token> _tokenize(String input) {
    final tokens = <_Token>[];

    var index = 0;
    while (index < input.length) {
      final character = input[index];

      if (_isDigit(character) || character == '.') {
        final start = index;
        while (index < input.length &&
            (_isDigit(input[index]) || input[index] == '.')) {
          index++;
        }
        final text = input.substring(start, index);
        final value = double.tryParse(text);
        if (value == null) {
          throw CalculatorException('Invalid number "$text"');
        }
        tokens.add(_Token.number(text, value));
        continue;
      }

      if (_isLetter(character)) {
        final start = index;
        while (index < input.length && _isLetter(input[index])) {
          index++;
        }
        tokens.add(_Token.identifier(input.substring(start, index).toLowerCase()));
        continue;
      }

      switch (character) {
        case '(':
          tokens.add(const _Token(_TokenType.leftParenthesis, '('));
          index++;
          continue;
        case ')':
          tokens.add(const _Token(_TokenType.rightParenthesis, ')'));
          index++;
          continue;
        case ',':
          tokens.add(const _Token(_TokenType.comma, ','));
          index++;
          continue;
      }

      if ('+-*/%^'.contains(character)) {
        tokens.add(_Token.op(character));
        index++;
        continue;
      }

      throw CalculatorException('Unexpected character "$character"');
    }

    return tokens;
  }

  static bool _isDigit(String character) {
    final code = character.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  static bool _isLetter(String character) {
    final code = character.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  static double _applyFunction(String name, double argument) {
    switch (name) {
      case 'sin':
        return math.sin(_toRadians(argument));
      case 'cos':
        return math.cos(_toRadians(argument));
      case 'tan':
        return math.tan(_toRadians(argument));
      case 'asin':
        return math.asin(argument) * 180 / math.pi;
      case 'acos':
        return math.acos(argument) * 180 / math.pi;
      case 'atan':
        return math.atan(argument) * 180 / math.pi;
      case 'log':
        return math.log(argument) / math.ln10;
      case 'ln':
        return math.log(argument);
      case 'sqrt':
        if (argument < 0) {
          throw const CalculatorException(
            'Cannot take the square root of a negative number',
          );
        }
        return math.sqrt(argument);
      case 'abs':
        return argument.abs();
      case 'round':
        return argument.roundToDouble();
      case 'floor':
        return argument.floorToDouble();
      case 'ceil':
        return argument.ceilToDouble();
      default:
        throw CalculatorException('Unknown function "$name"');
    }
  }

  static double _applyBinaryFunction(String name, double first, double second) {
    if (name == 'mod') {
      if (second == 0) {
        throw const CalculatorException('Cannot divide by zero');
      }
      return first % second;
    }
    throw CalculatorException('Unknown function "$name"');
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;

  static double _constant(String name) {
    switch (name) {
      case 'pi':
        return math.pi;
      case 'e':
        return math.e;
      default:
        throw CalculatorException('Unknown constant "$name"');
    }
  }
}

enum _TokenType {
  number,
  op,
  leftParenthesis,
  rightParenthesis,
  identifier,
  comma,
}

class _Token {
  const _Token(this.type, this.text, [this.value]);

  factory _Token.number(String text, double value) =>
      _Token(_TokenType.number, text, value);

  factory _Token.op(String text) => _Token(_TokenType.op, text);

  factory _Token.identifier(String text) =>
      _Token(_TokenType.identifier, text);

  final _TokenType type;
  final String text;
  final double? value;
}

/// Result of a parsed term, used to implement the `a + b%` behaviour.
class _TermValue {
  const _TermValue(this.value, {this.isPurePercent = false});

  final double value;
  final bool isPurePercent;
}

class _Parser {
  _Parser(this._tokens);

  final List<_Token> _tokens;
  int _index = 0;

  double parse() {
    if (_tokens.isEmpty) {
      throw const CalculatorException('Nothing to calculate');
    }

    final value = _parseExpression();

    if (_index < _tokens.length) {
      throw CalculatorException('Unexpected token "${_tokens[_index].text}"');
    }

    return value;
  }

  double _parseExpression() {
    var left = _parseTerm();

    while (_peekOperator(['+', '-'])) {
      final operator = _advance().text;
      final right = _parseTerm();

      if (operator == '+') {
        if (right.isPurePercent) {
          left = _TermValue(left.value + (left.value * right.value));
        } else {
          left = _TermValue(left.value + right.value);
        }
      } else {
        if (right.isPurePercent) {
          left = _TermValue(left.value - (left.value * right.value));
        } else {
          left = _TermValue(left.value - right.value);
        }
      }
    }

    return left.value;
  }

  _TermValue _parseTerm() {
    var result = _parseFactor();

    while (_peekOperator(['*', '/'])) {
      final operator = _advance().text;
      final right = _parseFactor();

      if (operator == '*') {
        result = _TermValue(result.value * right.value);
      } else {
        if (right.value == 0) {
          throw const CalculatorException('Cannot divide by zero');
        }
        result = _TermValue(result.value / right.value);
      }
    }

    return result;
  }

  _TermValue _parseFactor() {
    var left = _parseUnary();

    if (_peekOperator(['^'])) {
      _advance();
      final right = _parseFactor();
      left = _TermValue(_power(left.value, right.value));
    }

    return left;
  }

  _TermValue _parseUnary() {
    if (_peekOperator(['-'])) {
      _advance();
      final value = _parseUnary();
      return _TermValue(-value.value);
    }

    if (_peekOperator(['+'])) {
      _advance();
      return _parseUnary();
    }

    return _parsePrimary();
  }

  _TermValue _parsePrimary() {
    final token = _peek();

    if (token == null) {
      throw const CalculatorException('Unexpected end of expression');
    }

    if (token.type == _TokenType.number) {
      _advance();
      var value = token.value!;
      var isPurePercent = false;

      if (_peekOperator(['%'])) {
        _advance();
        value = value / 100;
        isPurePercent = true;
      }

      return _TermValue(value, isPurePercent: isPurePercent);
    }

    if (token.type == _TokenType.leftParenthesis) {
      _advance();
      final value = _parseExpression();
      _expect(_TokenType.rightParenthesis, 'Expected ")"');
      return _TermValue(value);
    }

    if (token.type == _TokenType.identifier) {
      _advance();
      final name = token.text;

      if (CalculatorEngine._constants.contains(name)) {
        return _TermValue(CalculatorEngine._constant(name));
      }

      if (CalculatorEngine._functions.contains(name)) {
        _expect(_TokenType.leftParenthesis, 'Expected "(" after "$name"');
        final first = _parseExpression();

        if (_peekType(_TokenType.comma)) {
          _advance();
          final second = _parseExpression();
          _expect(_TokenType.rightParenthesis, 'Expected ")"');
          return _TermValue(
            CalculatorEngine._applyBinaryFunction(name, first, second),
          );
        }

        _expect(_TokenType.rightParenthesis, 'Expected ")"');
        return _TermValue(CalculatorEngine._applyFunction(name, first));
      }

      throw CalculatorException('Unknown name "$name"');
    }

    throw CalculatorException('Unexpected token "${token.text}"');
  }

  double _power(double base, double exponent) {
    if (base < 0 && exponent != exponent.roundToDouble()) {
      throw const CalculatorException('Negative base with a fractional exponent');
    }
    return math.pow(base, exponent).toDouble();
  }

  _Token? _peek() {
    if (_index < _tokens.length) {
      return _tokens[_index];
    }
    return null;
  }

  _Token _advance() {
    final token = _peek();
    if (token == null) {
      throw const CalculatorException('Unexpected end of expression');
    }
    _index++;
    return token;
  }

  bool _peekOperator(List<String> candidates) {
    final token = _peek();
    if (token == null || token.type != _TokenType.op) {
      return false;
    }
    return candidates.contains(token.text);
  }

  bool _peekType(_TokenType type) {
    final token = _peek();
    return token != null && token.type == type;
  }

  void _expect(_TokenType type, String message) {
    if (!_peekType(type)) {
      throw CalculatorException(message);
    }
    _advance();
  }
}
