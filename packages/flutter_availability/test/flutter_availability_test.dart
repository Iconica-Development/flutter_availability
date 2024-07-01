import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("adds one to input values", () {
    var calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
}
