import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../logic/calculator_controller.dart';

/// Main screen of the calculator app.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onKey(String value) {
    setState(() => _controller.input(value));
  }

  void _onEquals() {
    setState(() => _controller.calculate());
  }

  void _onClear() {
    setState(() => _controller.clear());
  }

  void _onBackspace() {
    setState(() => _controller.backspace());
  }

  void _openHistory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (_controller.hasHistory)
                          TextButton(
                            onPressed: () {
                              setState(_controller.clearHistory);
                            },
                            child: const Text('Clear'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_controller.hasHistory)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No calculations yet',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _controller.history.length,
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1, color: AppColors.divider),
                          itemBuilder: (context, index) {
                            final entry = _controller.history[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                entry.expression,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                '= ${entry.result}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () {
                                setState(
                                  () => _controller.useHistoryEntry(entry),
                                );
                                Navigator.of(sheetContext).pop();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _openHistory,
            tooltip: 'History',
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return _Display(
                    expression: _controller.expression,
                    result: _controller.result,
                    lastExpression: _controller.lastExpression,
                    errorMessage: _controller.errorMessage,
                  );
                },
              ),
            ),
            _Keypad(
              onKey: _onKey,
              onEquals: _onEquals,
              onClear: _onClear,
              onBackspace: _onBackspace,
            ),
          ],
        ),
      ),
    );
  }
}

/// The result area shown above the keypad.
class _Display extends StatelessWidget {
  const _Display({
    required this.expression,
    required this.result,
    required this.lastExpression,
    required this.errorMessage,
  });

  final String expression;
  final String result;
  final String lastExpression;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastExpression.isNotEmpty && !hasError)
            Text(
              '$lastExpression =',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            expression.isEmpty ? result : expression,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: expression.isEmpty ? 44 : 32,
              fontWeight: FontWeight.w700,
              color: hasError ? AppColors.danger : AppColors.textPrimary,
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

/// The grid of calculator buttons.
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onKey,
    required this.onEquals,
    required this.onClear,
    required this.onBackspace,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onEquals;
  final VoidCallback onClear;
  final VoidCallback onBackspace;

  static const List<List<String>> _rows = [
    ['C', '(', ')', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '%', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KeypadButton(
                  label: '⌫',
                  onPressed: onBackspace,
                  style: _KeypadButtonStyle.utility,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _KeypadButton(
                  label: 'x²',
                  onPressed: () => onKey('^2'),
                  style: _KeypadButtonStyle.utility,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _KeypadButton(
                  label: '√',
                  onPressed: () => onKey('sqrt('),
                  style: _KeypadButtonStyle.utility,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final row in _rows) ...[
            Row(
              children: [
                for (final label in row) ...[
                  Expanded(
                    child: _KeypadButton(
                      label: label,
                      onPressed: () {
                        if (label == '=') {
                          onEquals();
                        } else if (label == 'C') {
                          onClear();
                        } else {
                          onKey(label);
                        }
                      },
                      style: _styleFor(label),
                    ),
                  ),
                  if (label != row.last) const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  _KeypadButtonStyle _styleFor(String label) {
    if (label == '=') {
      return _KeypadButtonStyle.primary;
    }
    if (label == 'C' || label == '(' || label == ')' || label == '%') {
      return _KeypadButtonStyle.secondary;
    }
    if ('÷×-+'.contains(label)) {
      return _KeypadButtonStyle.operator;
    }
    return _KeypadButtonStyle.number;
  }
}

enum _KeypadButtonStyle { number, operator, secondary, primary, utility }

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onPressed,
    required this.style,
  });

  final String label;
  final VoidCallback onPressed;
  final _KeypadButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (style) {
      _KeypadButtonStyle.number => (AppColors.surfaceAlt, AppColors.textPrimary),
      _KeypadButtonStyle.operator => (
        AppColors.primary.withValues(alpha: 0.18),
        AppColors.primary,
      ),
      _KeypadButtonStyle.secondary => (
        AppColors.surfaceAlt,
        AppColors.textSecondary,
      ),
      _KeypadButtonStyle.primary => (AppColors.primary, Colors.white),
      _KeypadButtonStyle.utility => (
        AppColors.surfaceAlt,
        AppColors.accent,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 58,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
