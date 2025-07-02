// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

abstract final class PackageDateUtils {
  static DateTime monthDateOnly(DateTime date) {
    return DateTime(date.year, date.month);
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
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - newFirstDayOfWeekIndex) % 7;
  }

  static int weekDelta(
    DateTime firstDate,
    DateTime secondDate,
  ) {
    DateTime laterDate = firstDate;
    DateTime earlierDate = secondDate;
    if (firstDate.isBefore(secondDate)) {
      laterDate = secondDate;
      earlierDate = firstDate;
    }

    // Number of weeks between 2 dates;
    final int differenceInDays = laterDate.difference(earlierDate).inDays;
    final int fullWeeksDifference = differenceInDays ~/ 7;
    if (fullWeeksDifference == 0) {
      return 0;
    }

    final int remainder = differenceInDays - (fullWeeksDifference * 7);
    final bool addWeek = remainder % 7 != 0;
    return fullWeeksDifference + (addWeek ? 1 : 0);
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    if (a.year == b.year && a.month == b.month && a.day == b.day) {
      return true;
    }

    final DateTime earlierDate = b.isAfter(a) ? a : b;
    final DateTime laterDate = b.isAfter(a) ? b : a;

    final int differenceInDays = laterDate.difference(earlierDate).inDays;
    if (differenceInDays >= 7) {
      return false;
    }

    final int weekDayDifference = laterDate.weekday - earlierDate.weekday;
    if (weekDayDifference <= 0) {
      return false;
    }

    return true;
  }
}
