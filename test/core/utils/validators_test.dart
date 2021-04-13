import 'package:devexam/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("[Validators]", () {
    group("Username", () {
      test("Invalid username", () {
        final _usename = Username.dirty(".");
        expect(_usename.invalid, true);
      });
      test("Valid username", () {
        final _usename = Username.dirty("test123");
        expect(_usename.invalid, false);
      });
    });

    group("Email", () {
      test("Invalid email", () {
        final _email = Email.dirty("test@");
        expect(_email.invalid, true);
      });
      test("Valid email", () {
        final _email = Email.dirty("test@gmail.com");
        expect(_email.invalid, false);
      });
    });

    group("Password", () {
      test("Invalid password", () {
        final _pasasword = Password.dirty("test");
        expect(_pasasword.invalid, true);
      });
      test("Valid password", () {
        final _pasasword = Password.dirty("test123");
        expect(_pasasword.invalid, false);
      });
    });

    group("ConfirmedPassword", () {
      test("Invalid confirm password", () {
        final _confirmPassword = ConfirmedPassword.dirty(
          password: 'test123',
          value: 'test',
        );
        expect(_confirmPassword.invalid, true);
      });

      test("Valid confirm password", () {
        final _confirmPassword = ConfirmedPassword.dirty(
          password: 'test123',
          value: 'test123',
        );
        expect(_confirmPassword.invalid, false);
      });
    });

    group("validateNewUsername", () {
      test("Invalid new username", () {
        final _newUsername =
            validateNewUsername(forTest: true, newUsername: "1234567810");
        expect(_newUsername, 'invalid');
      });

      test("Valid new username", () {
        final _newUsername =
            validateNewUsername(forTest: true, newUsername: "iska");
        expect(_newUsername, null);
      });
    });
  });
}
