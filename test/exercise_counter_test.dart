import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repetition Counter', () {
    int pushups = 0;

    setUp(() {
      pushups = 0; // reset before each test
    });

    test('starts at 0', () {
      expect(pushups, 0);
    });

    test('increments', () {
      pushups++;
      expect(pushups, 1);
    });

    test('decrements', () {
      pushups--;
      expect(pushups, -1);
    });
  });
}