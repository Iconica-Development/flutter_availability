import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AvailabilityTemplate", () {
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
