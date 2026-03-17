import 'package:flutter_test/flutter_test.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';
import 'package:geez_ai/features/route/domain/route_stop_model.dart';
import 'package:geez_ai/features/route/presentation/providers/route_detail_provider.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RouteModel _makeRoute({int durationDays = 2}) => RouteModel(
      id: 'route-1',
      userId: 'user-1',
      city: 'Istanbul',
      country: 'Turkey',
      title: 'Istanbul Explorer',
      durationDays: durationDays,
      travelStyle: 'culture',
      transportMode: 'walking',
      budgetLevel: 'medium',
    );

RouteStopModel _makeStop({
  required String id,
  required int stopOrder,
  required int dayNumber,
  required String placeName,
}) =>
    RouteStopModel(
      id: id,
      routeId: 'route-1',
      stopOrder: stopOrder,
      dayNumber: dayNumber,
      placeName: placeName,
    );

void main() {
  group('RouteDetailData — construction', () {
    test('can be constructed with a route and empty stops list', () {
      final route = _makeRoute();
      final data = RouteDetailData(route: route, stops: const []);
      expect(data.route.city, 'Istanbul');
      expect(data.stops, isEmpty);
    });

    test('exposes route and stops correctly', () {
      final route = _makeRoute(durationDays: 3);
      final stops = [
        _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'Hagia Sophia'),
        _makeStop(id: 's2', stopOrder: 2, dayNumber: 1, placeName: 'Blue Mosque'),
        _makeStop(id: 's3', stopOrder: 3, dayNumber: 2, placeName: 'Grand Bazaar'),
      ];

      final data = RouteDetailData(route: route, stops: stops);

      expect(data.route.id, 'route-1');
      expect(data.stops.length, 3);
    });
  });

  group('RouteDetailData.stopsForDay', () {
    late RouteDetailData data;

    setUp(() {
      final route = _makeRoute(durationDays: 2);
      final stops = [
        _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'Hagia Sophia'),
        _makeStop(id: 's2', stopOrder: 2, dayNumber: 1, placeName: 'Blue Mosque'),
        _makeStop(id: 's3', stopOrder: 3, dayNumber: 2, placeName: 'Grand Bazaar'),
        _makeStop(id: 's4', stopOrder: 4, dayNumber: 2, placeName: 'Spice Bazaar'),
      ];
      data = RouteDetailData(route: route, stops: stops);
    });

    test('returns only stops for the given day number', () {
      final day1 = data.stopsForDay(1);
      expect(day1.length, 2);
      expect(day1.map((s) => s.placeName), containsAll(['Hagia Sophia', 'Blue Mosque']));
    });

    test('returns empty list for a day with no stops', () {
      expect(data.stopsForDay(99), isEmpty);
    });

    test('day 2 stops are correct', () {
      final day2 = data.stopsForDay(2);
      expect(day2.length, 2);
      expect(day2.map((s) => s.placeName), containsAll(['Grand Bazaar', 'Spice Bazaar']));
    });
  });

  group('RouteDetailData.days', () {
    test('returns at least [1..durationDays] even with no stops', () {
      final route = _makeRoute(durationDays: 3);
      final data = RouteDetailData(route: route, stops: const []);

      expect(data.days, [1, 2, 3]);
    });

    test('merges stop day numbers with durationDays range', () {
      final route = _makeRoute(durationDays: 2);
      final stops = [
        _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'Place A'),
        // Day 3 exists in stops but durationDays is 2 — should still appear.
        _makeStop(id: 's2', stopOrder: 2, dayNumber: 3, placeName: 'Place B'),
      ];
      final data = RouteDetailData(route: route, stops: stops);

      expect(data.days, [1, 2, 3]);
    });

    test('days list is sorted ascending', () {
      final route = _makeRoute(durationDays: 1);
      final stops = [
        _makeStop(id: 's3', stopOrder: 3, dayNumber: 3, placeName: 'Place C'),
        _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'Place A'),
        _makeStop(id: 's2', stopOrder: 2, dayNumber: 2, placeName: 'Place B'),
      ];
      final data = RouteDetailData(route: route, stops: stops);

      final days = data.days;
      expect(days, orderedEquals([1, 2, 3]));
    });

    test('no duplicate day numbers even when stops repeat a day', () {
      final route = _makeRoute(durationDays: 1);
      final stops = [
        _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'A'),
        _makeStop(id: 's2', stopOrder: 2, dayNumber: 1, placeName: 'B'),
        _makeStop(id: 's3', stopOrder: 3, dayNumber: 1, placeName: 'C'),
      ];
      final data = RouteDetailData(route: route, stops: stops);

      expect(data.days, [1]);
    });
  });

  group('RouteModel — default field values', () {
    test('status defaults to draft', () {
      final route = _makeRoute();
      expect(route.status, 'draft');
    });

    test('startTime defaults to 09:00', () {
      final route = _makeRoute();
      expect(route.startTime, '09:00');
    });

    test('language defaults to tr', () {
      final route = _makeRoute();
      expect(route.language, 'tr');
    });

    test('optional fields are null by default', () {
      final route = _makeRoute();
      expect(route.aiModelUsed, isNull);
      expect(route.generationCostUsd, isNull);
      expect(route.completedAt, isNull);
      expect(route.createdAt, isNull);
    });
  });

  group('RouteStopModel — default field values', () {
    test('entryFeeCurrency defaults to TRY', () {
      final stop = _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'X');
      expect(stop.entryFeeCurrency, 'TRY');
    });

    test('discoveryPoints defaults to 0', () {
      final stop = _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'X');
      expect(stop.discoveryPoints, 0);
    });

    test('optional fields are null by default', () {
      final stop = _makeStop(id: 's1', stopOrder: 1, dayNumber: 1, placeName: 'X');
      expect(stop.latitude, isNull);
      expect(stop.longitude, isNull);
      expect(stop.insiderTip, isNull);
      expect(stop.funFact, isNull);
      expect(stop.googleRating, isNull);
    });
  });
}

