// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/extensions/date_time_extension.dart';

abstract final class PackageDateUtils {
  static DateTime monthDateOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static DateTime dayMonthYearOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int firstDayOffset(
    int year,
    int month,
    int firstDayOfWeekIndex,
  ) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    final int newFirstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - newFirstDayOfWeekIndex) % 7;
  }

  static int firstWeekDayOffset(
    int year,
    int month,
    int day,
    int firstDayOfWeekIndex,
  ) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month, day).weekday - 1;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    final int newFirstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first day of the week.
    return (weekdayFromMonday - newFirstDayOfWeekIndex) % 7;
  }

  static int weekDelta(
    DateTime firstDate,
    DateTime secondDate,
    int firstDayIndex,
  ) {
    DateTime laterDate = firstDate;
    DateTime earlierDate = secondDate;
    if (firstDate.isBefore(secondDate)) {
      laterDate = secondDate;
      earlierDate = firstDate;
    }

    final int laterDateWeekNumber = laterDate.weekNumber(firstDayIndex);
    final int earlierDateWeekNumber = earlierDate.weekNumber(firstDayIndex);
    final int yearDifference = laterDate.year - earlierDate.year;

    if (yearDifference == 0) {
      return laterDateWeekNumber - earlierDateWeekNumber;
    } else {
      return laterDateWeekNumber +
          (53 - earlierDateWeekNumber) +
          (yearDifference - 1) * 53;
    }
  }

  static bool isSameWeek(
    DateTime a,
    DateTime b,
    int firstDayOfWeekIndex,
  ) {
    if (firstDayOfWeekIndex < 0 || firstDayOfWeekIndex > 6) {
      throw ArgumentError(
        'firstDayOfWeekIndex must be between 0 and 6 '
        'where 0 represents Sunday and 6 Saturday',
      );
    }

    // DateTime weekday is [1..7] for [Monday..Sunday]
    final int normalizedIndex =
        firstDayOfWeekIndex == 0 ? 7 : firstDayOfWeekIndex;

    final DateTime startOfWeekA = startOfWeek(a, normalizedIndex);
    final DateTime startOfWeekB = startOfWeek(b, normalizedIndex);

    // Compare the start of the weeks
    return startOfWeekA.year == startOfWeekB.year &&
        startOfWeekA.month == startOfWeekB.month &&
        startOfWeekA.day == startOfWeekB.day;
  }

  // Normalize dates to the start of their respective weeks
  static DateTime startOfWeek(DateTime date, int firstDay) {
    // Calculate days to subtract to reach the first day of the week
    int daysToSubtract = (date.weekday - firstDay) % 7;
    if (daysToSubtract < 0) daysToSubtract += 7; // Handle negative modulo
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }
}
