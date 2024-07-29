import "package:flutter_availability_data_interface/src/service/availability_service.dart";
import "package:mocktail/mocktail.dart";
import "package:test/test.dart";

import "../mocks.dart";

const String testUserId = "test_user";

void main() {
  group("AvailabilityService", () {
    late AvailabilityService sut;
    late DataInterfaceMock dataInterfaceMock;

    setUp(() {
      dataInterfaceMock = DataInterfaceMock();
      sut = AvailabilityService(
        userId: testUserId,
        dataInterface: dataInterfaceMock,
      );
    });

    group("getOverviewDataForMonth", () {
      test("should combine availabilities and relating templates", () {
        var dateTime = DateTime(2012, 12);
        var templateId = "1";

        var availabilityModel1 = MockAvailability();
        when(() => availabilityModel1.templateId).thenReturn(templateId);
        var availabilityModel2 = MockAvailability();
        when(() => availabilityModel2.templateId).thenReturn(templateId);

        when(
          () => dataInterfaceMock.getAvailabilityForUser(
            userId: any(named: "userId"),
            start: any(named: "start"),
            end: any(named: "end"),
          ),
        ).thenAnswer(
          (_) => Stream.value([
            availabilityModel1,
            availabilityModel2,
          ]),
        );

        var template1 = MockTemplate();
        when(() => template1.id).thenReturn(templateId);
        var template2 = MockTemplate();
        when(() => template2.id).thenReturn("other");
        when(
          () => dataInterfaceMock.getTemplatesForUser(
            userId: any(named: "userId"),
            templateIds: any(named: "templateIds"),
          ),
        ).thenAnswer(
          (_) => Stream.value([
            template1,
            template2,
          ]),
        );

        var resultingStream = sut.getOverviewDataForMonth(dateTime);

        expect(
          resultingStream,
          emits(
            isA<List<AvailabilityWithTemplate>>()
                .having((e) => e.length, "has two values", equals(2))
                .having(
                  (e) => e,
                  "Contains availability 1",
                  contains(
                    predicate<AvailabilityWithTemplate>(
                      (e) => e.availabilityModel == availabilityModel1,
                    ),
                  ),
                )
                .having(
                  (e) => e,
                  "Contains template 1",
                  contains(
                    predicate<AvailabilityWithTemplate>(
                      (e) => e.template == template1,
                    ),
                  ),
                )
                .having(
                  (e) => e,
                  "Does not contain template 2",
                  isNot(
                    contains(
                      predicate<AvailabilityWithTemplate>(
                        (e) => e.template == template2,
                      ),
                    ),
                  ),
                ),
          ),
        );
      });
    });
  });
}
