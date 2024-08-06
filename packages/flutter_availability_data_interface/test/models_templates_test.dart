import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:test/test.dart";

void main() {
  group("AvailabilityTemplate", () {
    group("Apply", () {
      test("applying a week template should generate correct availability", () {
        DateTime asTime(int hours, [int minutes = 0]) =>
            DateTime(1, 1, 1, hours, minutes);

        AvailabilityBreakModel createBreak(int startHour) =>
            AvailabilityBreakModel(
              startTime: asTime(startHour),
              endTime: asTime(startHour + 1),
              submittedDuration: const Duration(minutes: 30),
            );

        DayTemplateData createTemplate(int startHour) => DayTemplateData(
              startTime: asTime(startHour),
              endTime: asTime(startHour + 7),
              breaks: [createBreak(startHour + 3)],
            );

        var monday = createTemplate(1);
        var tuesday = createTemplate(2);
        var wednesday = createTemplate(3);
        var thursday = createTemplate(4);
        var friday = createTemplate(5);
        var saturday = createTemplate(6);
        var sunday = createTemplate(7);

        var sut = AvailabilityTemplateModel(
          id: "",
          userId: "",
          name: "",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData.forDays(
            monday: monday,
            tuesday: tuesday,
            wednesday: wednesday,
            thursday: thursday,
            friday: friday,
            saturday: saturday,
            sunday: sunday,
          ),
        );

        var startOfRangeToApply = DateTime(1999, 1, 1);
        var endOfRangeToApply = DateTime(2024, 12, 31);

        var availabilities = sut.apply(startOfRangeToApply, endOfRangeToApply);

        AvailabilityModel findAvailabilityByDate(DateTime date) =>
            availabilities
                .where((value) => value.startDate.date == date.date)
                .first;

        var firstDay = startOfRangeToApply;
        expect(findAvailabilityByDate(firstDay), isA<AvailabilityModel>());

        var lastDay = endOfRangeToApply;
        expect(findAvailabilityByDate(lastDay), isA<AvailabilityModel>());

        var leapDayMillenial = DateTime(2000, 2, 29);
        expect(
          findAvailabilityByDate(leapDayMillenial).matchesTemplate(tuesday),
          isTrue,
        );

        var savingsTimeSwitch = DateTime(2020, 10, 25);
        expect(
          findAvailabilityByDate(savingsTimeSwitch).matchesTemplate(sunday),
          isTrue,
        );

        var dayAfterSavingsTime = DateTime(2020, 10, 26);
        expect(
          findAvailabilityByDate(dayAfterSavingsTime).matchesTemplate(monday),
          isTrue,
        );

        var aMondayInJuly = DateTime(2024, 7, 8);
        expect(
          findAvailabilityByDate(aMondayInJuly).matchesTemplate(monday),
          isTrue,
        );

        var aTuesdayInJuly = DateTime(2024, 7, 9);
        expect(
          findAvailabilityByDate(aTuesdayInJuly).matchesTemplate(tuesday),
          isTrue,
        );

        var aWednesdayInJuly = DateTime(2024, 7, 10);
        expect(
          findAvailabilityByDate(aWednesdayInJuly).matchesTemplate(wednesday),
          isTrue,
        );

        var aThursdayInJuly = DateTime(2024, 7, 11);
        expect(
          findAvailabilityByDate(aThursdayInJuly).matchesTemplate(thursday),
          isTrue,
        );

        var aFridayInJuly = DateTime(2024, 7, 12);
        expect(
          findAvailabilityByDate(aFridayInJuly).matchesTemplate(friday),
          isTrue,
        );

        var aSaturdayInJuly = DateTime(2024, 7, 13);
        expect(
          findAvailabilityByDate(aSaturdayInJuly).matchesTemplate(saturday),
          isTrue,
        );

        var aSundayInJuly = DateTime(2024, 7, 14);
        expect(
          findAvailabilityByDate(aSundayInJuly).matchesTemplate(sunday),
          isTrue,
        );
      });
    });

    group("Serialization", () {
      test("week template should serialize and deserialize correctly", () {
        var baseDate = DateTime(1994, 10, 18, 10, 0);

        DayTemplateData createDayTemplateForDay(WeekDay day) {
          var baseDayDate = baseDate.add(Duration(days: day.index));
          return DayTemplateData(
            startTime: baseDayDate,
            endTime: baseDayDate.add(const Duration(hours: 7)),
            breaks: [
              AvailabilityBreakModel(
                startTime: baseDayDate.add(const Duration(hours: 3)),
                endTime: baseDate.add(const Duration(hours: 4)),
              ),
            ],
          );
        }

        var weektemplate = AvailabilityTemplateModel(
          id: "id",
          userId: "1",
          name: "test",
          color: 0xFFAABBCC,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData(
            data: {
              for (var day in WeekDay.values) ...{
                day: createDayTemplateForDay(day),
              },
            },
          ),
        );

        var serialized = weektemplate.rawTemplateData;

        var deserialized = AvailabilityTemplateModel.fromType(
          userId: weektemplate.userId,
          name: weektemplate.name,
          color: weektemplate.color,
          templateType: weektemplate.templateType,
          data: serialized,
        );

        expect(deserialized.templateData, isA<WeekTemplateData>());
        var parsedData = deserialized.templateData as WeekTemplateData;

        expect(parsedData.data.length, equals(7));
        expect(parsedData.data.entries.first.value, isA<DayTemplateData>());
        var dayTemplateData = parsedData.data.entries.first.value;

        expect(dayTemplateData.startTime, equals(baseDate));
        expect(dayTemplateData.breaks.length, equals(1));
        expect(
          dayTemplateData.breaks.first.startTime,
          equals(baseDate.add(const Duration(hours: 3))),
        );
      });
    });

    group("availabilityTimeDeviates", () {
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
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
          var result = template.availabilityTimeDeviatesFromTemplate(
            availability,
            availability.startDate,
            availability.endDate,
          );
          expect(result, isTrue);
        });
      });
    });
  });

  group("availabilityBreaksDeviates", () {
    group("day templates", () {
      test("returns false when availability matches the day template breaks",
          () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0),
          endDate: DateTime(2023, 7, 9, 17, 0),
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 13, 0),
            ),
          ],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Day Template",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime(2023, 7, 9, 9, 0),
            endTime: DateTime(2023, 7, 9, 17, 0),
            breaks: [
              AvailabilityBreakModel(
                startTime: DateTime(2023, 7, 9, 12, 0),
                endTime: DateTime(2023, 7, 9, 13, 0),
              ),
            ],
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isFalse);
      });

      test(
          "returns true when availability breaks do not match the day template",
          () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0),
          endDate: DateTime(2023, 7, 9, 17, 0),
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 13, 0),
            ),
          ],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Day Template",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime(2023, 7, 9, 9, 0),
            endTime: DateTime(2023, 7, 9, 17, 0),
            breaks: [
              AvailabilityBreakModel(
                startTime: DateTime(2023, 7, 9, 12, 30),
                endTime: DateTime(2023, 7, 9, 13, 30),
              ),
            ],
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });

      test(
          "returns true when availability has more breaks than "
          "the day template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0),
          endDate: DateTime(2023, 7, 9, 17, 0),
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 12, 30),
            ),
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 15, 0),
              endTime: DateTime(2023, 7, 9, 15, 30),
            ),
          ],
        );
        var template = AvailabilityTemplateModel(
          userId: "user1",
          name: "Day Template",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime(2023, 7, 9, 9, 0),
            endTime: DateTime(2023, 7, 9, 17, 0),
            breaks: [
              AvailabilityBreakModel(
                startTime: DateTime(2023, 7, 9, 12, 0),
                endTime: DateTime(2023, 7, 9, 12, 30),
              ),
            ],
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });

      test(
          "returns true when availability has fewer breaks than "
          "the day template", () {
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
            breaks: [
              AvailabilityBreakModel(
                startTime: DateTime(2023, 7, 9, 12, 0),
                endTime: DateTime(2023, 7, 9, 12, 30),
              ),
            ],
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });
    });

    group("week templates", () {
      test("returns false when availability matches the week template breaks",
          () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0), // Sunday
          endDate: DateTime(2023, 7, 9, 17, 0), // Sunday
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 13, 0),
            ),
          ],
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
              breaks: [
                AvailabilityBreakModel(
                  startTime: DateTime(2023, 7, 9, 12, 0),
                  endTime: DateTime(2023, 7, 9, 13, 0),
                ),
              ],
            ),
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isFalse);
      });

      test(
          "returns true when availability breaks do not match the "
          "week template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0), // Sunday
          endDate: DateTime(2023, 7, 9, 17, 0), // Sunday
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 13, 0),
            ),
          ],
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
              breaks: [
                AvailabilityBreakModel(
                  startTime: DateTime(2023, 7, 9, 12, 30),
                  endTime: DateTime(2023, 7, 9, 13, 30),
                ),
              ],
            ),
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });

      test(
          "returns true when availability has more breaks than the "
          "week template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0), // Sunday
          endDate: DateTime(2023, 7, 9, 17, 0), // Sunday
          breaks: [
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 12, 0),
              endTime: DateTime(2023, 7, 9, 12, 30),
            ),
            AvailabilityBreakModel(
              startTime: DateTime(2023, 7, 9, 15, 0),
              endTime: DateTime(2023, 7, 9, 15, 30),
            ),
          ],
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
              breaks: [
                AvailabilityBreakModel(
                  startTime: DateTime(2023, 7, 9, 12, 0),
                  endTime: DateTime(2023, 7, 9, 12, 30),
                ),
              ],
            ),
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });

      test(
          "returns true when availability has fewer breaks than "
          "the week template", () {
        var availability = AvailabilityModel(
          userId: "user1",
          startDate: DateTime(2023, 7, 9, 9, 0), // Sunday
          endDate: DateTime(2023, 7, 9, 17, 0), // Sunday
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
              breaks: [
                AvailabilityBreakModel(
                  startTime: DateTime(2023, 7, 9, 12, 0),
                  endTime: DateTime(2023, 7, 9, 12, 30),
                ),
              ],
            ),
          ),
        );
        var result =
            template.availabilityBreaksDeviatesFromTemplate(availability);
        expect(result, isTrue);
      });
    });
  });
}

extension on AvailabilityModel {
  bool matchesTemplate(DayTemplateData template) {
    var startDateMatches = template.startTime.timeMatches(startDate);
    var endDateMatches = template.endTime.timeMatches(endDate);
    var breaksMatch = template.breaks.matches(breaks);

    return startDateMatches && endDateMatches && breaksMatch;
  }
}

extension on List<AvailabilityBreakModel> {
  bool matches(List<AvailabilityBreakModel> other) {
    if (other.length != length) {
      return false;
    }

    for (var otherBreak in other) {
      if (!any((e) => e.matches(otherBreak))) {
        return false;
      }
    }

    return true;
  }
}

extension on AvailabilityBreakModel {
  bool matches(AvailabilityBreakModel other) {
    var startTimeMatches = other.startTime.timeMatches(startTime);
    var endTimeMatches = other.endTime.timeMatches(endTime);
    var durationMatches = other.duration == duration;

    return startTimeMatches && endTimeMatches && durationMatches;
  }
}

extension on DateTime {
  DateTime get date => DateTime(year, month, day);

  bool timeMatches(DateTime other) =>
      other.hour == hour && other.minute == minute;
}
