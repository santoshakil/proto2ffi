import 'package:dart_ffi_lib/dart_ffi_lib.dart';

void main() {
  final calc = CalculatorImpl();

  try {
    print('FFI Calculator Test');
    print('===================');

    var result = calc.add(10, 5);
    print('add(10, 5) = $result');

    result = calc.subtract(10, 5);
    print('subtract(10, 5) = $result');

    result = calc.multiply(10, 5);
    print('multiply(10, 5) = $result');

    final divResult = calc.divide(10, 5);
    print('divide(10, 5) = $divResult');

    final divByZero = calc.divide(10, 0);
    print('divide(10, 0) = $divByZero');

    print('\n✓ All tests passed!');
  } finally {
    calc.dispose();
  }
}
