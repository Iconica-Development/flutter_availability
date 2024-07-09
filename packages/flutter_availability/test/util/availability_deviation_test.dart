import "package:flutter_availability/src/util/availability_deviation.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("isTemplateDeviated", () {
    group("day templates", () {
      test("returns false when availability matches the day template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0),
          endDate: DateTime(2023, 7, 9, 17, 0),
          breaks: [],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Day Template",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime(2023, 7, 9, 9, 0),
            endTime: DateTime(2023, 7, 9, 17, 0),
            breaks: [],
          ),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isFalse);
      });

      test("returns true when availability does not match the day template",
          () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 10, 0),
          endDate: DateTime(2023, 7, 9, 18, 0),
          breaks: [],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Day Template",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime(2023, 7, 9, 9, 0),
            endTime: DateTime(2023, 7, 9, 17, 0),
            breaks: [],
          ),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isTrue);
      });
    });

    group("week templates", () {
      test("returns false when availability matches the week template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0),
          endDate: DateTime(2023, 7, 9, 17, 0),
          breaks: [],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Week Template",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData.forDays(
            sunday: DayTemplateData(
              startTime: DateTime(2023, 7, 9, 9, 0),
              endTime: DateTime(2023, 7, 9, 17, 0),
              breaks: [],
            ),
          ),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isFalse);
      });

      test("returns true when availability does not match the week template",
          () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 10, 0), // sunday
          endDate: DateTime(2023, 7, 9, 18, 0), // sunday
          breaks: [],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Week Template",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData.forDays(
            sunday: DayTemplateData(
              startTime: DateTime(2023, 7, 9, 9, 0),
              endTime: DateTime(2023, 7, 9, 17, 0),
              breaks: [],
            ),
          ),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isTrue);
      });

      test(
          "returns true when the template is missing the "
          "day of the availability", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 10, 10, 0), // monday
          endDate: DateTime(2023, 7, 10, 18, 0), // monday
          breaks: [],
        );
        var template = const AvailabilityTemplateModel(
          userId: "user1",
          name: "Week Template",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData(data: {}),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isTrue);
      });

      test("returns true when the template is fully null", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 10, 10, 0),
          endDate: DateTime(2023, 7, 10, 18, 0),
          breaks: [],
        );
        var template = const AvailabilityTemplateModel(
          userId: "user1",
          name: "Week Template",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData(data: {}),
        );
        var result = isTemplateDeviated(availability, template);
        expect(result, isTrue);
      });
    });
  });
}
