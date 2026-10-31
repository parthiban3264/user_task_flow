import 'package:flutter/foundation.dart';

import 'calculator_engine.dart';

/// A single entry of the calculation history.
@immutable
class HistoryEntry {
  const HistoryEntry({required this.expression, required this.result});

  final String expression;
  final String result;
}

/// Holds the calculator state and exposes the actions the UI can trigger.
class CalculatorController extends ChangeNotifier {
  CalculatorController({this.engine = const CalculatorEngine()});

  /// Engine used to evaluate expressions.
  final CalculatorEngine engine;

  /// The expression currently being typed.
  String _expression = '';

  /// The result of the last successful calculation.
  String _result = '0';

  /// The expression that produced [_result].
  String _lastExpression = '';

  /// Error message shown under the display, empty when there is no error.
  String _errorMessage = '';

  /// History of previous calculations, newest first.
  final List<HistoryEntry> _history = [];

  String get expression => _expression;
  String get result => _result;
  String get lastExpression => _lastExpression;
  String get errorMessage => _errorMessage;
  List<HistoryEntry> get history => List.unmodifiable(_history);
  bool get hasHistory => _history.isNotEmpty;

  /// Appends [value] to the expression.
  void input(String value) {
    _errorMessage = '';
    _expression += value;
    notifyListeners();
  }

  /// Removes the last character of the expression.
  void backspace() {
    if (_expression.isEmpty) {
      return;
    }
    _errorMessage = '';
    _expression = _expression.substring(0, _expression.length - 1);
    notifyListeners();
  }

  /// Clears the expression and the result.
  void clear() {
    _expression = '';
    _result = '0';
    _lastExpression = '';
    _errorMessage = '';
    notifyListeners();
  }

  /// Clears the expression but keeps the previous result.
  void clearEntry() {
    _expression = '';
    _errorMessage = '';
    notifyListeners();
  }

  /// Evaluates the current expression.
  void calculate() {
    if (_expression.trim().isEmpty) {
      _errorMessage = 'Nothing to calculate';
      notifyListeners();
      return;
    }

    try {
      final value = engine.evaluate(_expression);
      final formatted = CalculatorEngine.formatNumber(value, grouping: true);

      _result = formatted;
      _lastExpression = _expression;
      _expression = '';
      _errorMessage = '';

      _history.insert(0, HistoryEntry(expression: _lastExpression, result: formatted));
      if (_history.length > 50) {
        _history.removeLast();
      }
    } on CalculatorException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Invalid expression';
    }

    notifyListeners();
  }

  /// Re-uses a history entry as the current expression.
  void useHistoryEntry(HistoryEntry entry) {
    _expression = entry.expression;
    _errorMessage = '';
    notifyListeners();
  }

  /// Removes every history entry.
  void clearHistory() {
    if (_history.isEmpty) {
      return;
    }
    _history.clear();
    notifyListeners();
  }
}
