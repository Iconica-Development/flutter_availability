import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_test/flutter_test.dart";

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
              duration: const Duration(minutes: 30),
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
