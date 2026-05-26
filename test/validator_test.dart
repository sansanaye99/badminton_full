import 'package:badminton_club/validators/form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormValidators.validateEmail', () {
    test('returns null for valid email', () =>
        expect(FormValidators.validateEmail('test@example.com'), isNull));
    test('returns error for empty', () =>
        expect(FormValidators.validateEmail(''), isNotNull));
    test('returns error for null', () =>
        expect(FormValidators.validateEmail(null), isNotNull));
    test('returns error for missing @', () =>
        expect(FormValidators.validateEmail('notanemail'), isNotNull));
  });

  group('FormValidators.validatePassword', () {
    test('returns null for valid password', () =>
        expect(FormValidators.validatePassword('password123'), isNull));
    test('returns error for short password', () =>
        expect(FormValidators.validatePassword('abc'), isNotNull));
    test('returns error for null', () =>
        expect(FormValidators.validatePassword(null), isNotNull));
  });

  group('FormValidators.validateName', () {
    test('returns null for valid name', () =>
        expect(FormValidators.validateName('Alice'), isNull));
    test('returns error for empty', () =>
        expect(FormValidators.validateName(''), isNotNull));
    test('returns error for single char', () =>
        expect(FormValidators.validateName('A'), isNotNull));
  });

  group('FormValidators.validateTimeSlot', () {
    test('returns null for valid slot', () =>
        expect(FormValidators.validateTimeSlot('09:00–10:00'), isNull));
    test('returns error for empty', () =>
        expect(FormValidators.validateTimeSlot(''), isNotNull));
  });
}
