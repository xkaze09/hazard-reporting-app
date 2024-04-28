import "package:hazard_reporting_app/data_types/utils.dart";
import 'package:test/test.dart';

void main() {
  //Category.fromString tests
  group('Category tests', () {
    // Check for correct input
    for (int i = 0; i < categoryList.length; i++) {
      test(
          'Category.fromString should return the appropriate category',
          () {
        final category = Category.fromString(categoryList[i].name);
        expect(category.name, categoryList[i].name);
      });
    }

    // Check proper error correction
    test(
        'Category.fromString should return Misc category when encountering unknown values',
        () {
      final category = Category.fromString('Cat');
      expect(category.name, 'Misc');
    });

    test('Category toString should return the correct string', () {
      for (int i = 0; i < categoryList.length; i++) {
        test(
            'Category toString should return the appropriate category',
            () {
          final category = categoryList[i];
          expect(category.toString(), categoryList[i].name);
        });
      }
    });
  });

  //Email tests
  group('Email tests', () {
    test('Test correct email is processed properly', () {
      const email = 'test@gmail.com';
      Email mail = Email.fromString(email);
      expect(mail, ['test', 'gmail.com']);
    });

    test('Test wrong email raises exception', () {
      const email = 'testgmail.com';
      expect(Email.fromString(email), throwsRangeError);
    });

    test('Test toString() properly returns an email', () {
      expect(
          const Email(name: 'test', provider: 'gmail.com').toString(),
          'test@gmail.com');
    });
  });
}
