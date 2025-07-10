// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';

extension PackageDateTimeExtension on DateTime {
  DateTime addDays(int days) {
    return DateTime.utc(year, month, day + days);
  }

  DateTime truncateToMinutes({int? newHour, int? newMinute}) {
    return DateTime(year, month, day, newHour ?? hour, newMinute ?? minute);
  }

  bool isSameWeekAs(DateTime other) {
    return PackageDateUtils.isSameWeek(this, other);
  }

  /// Number of days since December 31st the previous year.
  /// Jan 1st ordinal date is 1
  /// December 31st ordinal date is 365 or 366 depending on the leap year
  int get ordinalDate {
    const List<int> offsets = <int>[
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334,
    ];

    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  bool get isLeapYear => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  int weekNumber(int firstDayIndex) {
    final int adjustedWeekday = (weekday - firstDayIndex + 7) % 7 + 1;

    final int week = (ordinalDate - adjustedWeekday + 10) ~/ 7;

    if (week == 0) {
      return DateTime(year - 1, 12, 28).weekNumber(firstDayIndex);
    }

    if (week == 53 &&
        DateTime(year).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return week;
  }
}
