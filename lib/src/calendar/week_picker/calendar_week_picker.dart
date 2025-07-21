// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

// /// Displays the days of a given week and allows choosing a day.
// ///
// /// The days are arranged in a horizontal list with one item for each day of
// /// the week.
class CalendarWeekPicker extends StatefulWidget {
  /// Creates a day picker.
  CalendarWeekPicker({
    required this.weekPageController,
    required this.onWeekPageChanged,
    required DateTime currentDate,
    required DateTime minimumDate,
    required DateTime maximumDate,
    required DateTime selectedDate,
    required this.onChanged,
    required this.decoration,
    required this.mainColor,
    required this.firstDayOfWeekIndex,
    required this.selectableDayPredicate,
    super.key,
  })  : minimumDate = DateUtils.dateOnly(minimumDate),
        maximumDate = DateUtils.dateOnly(maximumDate),
        currentDate = DateUtils.dateOnly(currentDate),
        selectedDate = DateUtils.dateOnly(selectedDate);

  final PageController weekPageController;
  final ValueChanged<int> onWeekPageChanged;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// A predicate that determines whether a day is selectable.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maximumDate].
  final DateTime minimumDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minimumDate].
  final DateTime maximumDate;

  /// The decoration class for each day type.
  final CalendarWeekPickerDecoration decoration;

  /// The main color of the week picker.
  final Color mainColor;

  /// The index of the first day of the week, where 0 represents Sunday.
  ///
  /// The default value is based on the locale.
  final int? firstDayOfWeekIndex;

  @override
  State<CalendarWeekPicker> createState() => CalendarWeekPickerState();
}

class CalendarWeekPickerState extends State<CalendarWeekPicker> {
  int _dayOffset(
    BuildContext context, {
    required DateTime weekDate,
  }) {
    final int year = weekDate.year;
    final int month = weekDate.month;
    final int day = weekDate.day;
    final int dayOffset = PackageDateUtils.firstWeekDayOffset(
      year,
      month,
      day,
      widget.firstDayOfWeekIndex ??
          context.materialLocalization.firstDayOfWeekIndex,
    );

    return dayOffset;
  }

  Iterable<Widget> _days(
    BuildContext context, {
    required int index,
    required double backgroundCircleSize,
  }) sync* {
    DateTime weekDate = DateUtils.addDaysToDate(
      widget.minimumDate,
      index * 7,
    );

    final int weekStartDayOffset = _dayOffset(context, weekDate: weekDate);

    if (weekStartDayOffset > 0) {
      weekDate = weekDate.subtract(Duration(days: weekStartDayOffset));
    }

    for (int weekDay = 0; weekDay < 7; weekDay++) {
      late CalendarPickerDayStyle style;

      final DateTime date = DateUtils.addDaysToDate(
        DateTime(weekDate.year, weekDate.month, weekDate.day),
        weekDay,
      );
      final bool isCurrentDay = DateUtils.isSameDay(widget.currentDate, date);
      final bool isSelectedDay = DateUtils.isSameDay(
        widget.selectedDate,
        date,
      );
      final bool isDisabledDay = date.isAfter(widget.maximumDate) ||
          date.isBefore(widget.minimumDate) ||
          widget.selectableDayPredicate?.call(date) == false;

      final CalendarWeekPickerDecoration decoration = widget.decoration;

      if (isDisabledDay) {
        style = decoration.disabledDayStyle ??
            CalendarPickerDisabledDayStyle.withDynamicColor(context);
      } else if (isCurrentDay) {
        style = decoration.currentDayStyle ??
            CalendarPickerCurrentDayStyle.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            );

        if (isSelectedDay) {
          style = decoration.selectedCurrentDayStyle ??
              CalendarPickerSelectedCurrentDayStyle.withDynamicColor(
                context,
                mainColor: widget.mainColor,
              );
        }
      } else if (isSelectedDay) {
        style = decoration.selectedDayStyle ??
            CalendarPickerSelectedDayStyle.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            );
      } else {
        style = decoration.defaultDayStyle ??
            CalendarPickerDefaultDayStyle.withDynamicColor(context);
      }

      final Widget dayWidget = CalendarPickerDay(
        dayDate: date,
        onDaySelected: isDisabledDay ? null : widget.onChanged,
        style: style,
        backgroundCircleSize: backgroundCircleSize,
      );
      yield dayWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// [+ 1] to include the last week
    final int itemCount = PackageDateUtils.weekDelta(
          widget.minimumDate,
          widget.maximumDate,
          widget.firstDayOfWeekIndex ??
              context.materialLocalization.firstDayOfWeekIndex,
        ) +
        1;

    return Expanded(
      child: PageView.builder(
        controller: widget.weekPageController,
        itemBuilder: (BuildContext context, int index) {
          const double rowSize = calendarWeekPickerRowSize;
          final Iterable<Widget> days = _days(
            context,
            index: index,
            backgroundCircleSize: rowSize > calendarWeekPickerDayMaxSize
                ? calendarWeekPickerDayMaxSize
                : rowSize,
          );

          return LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              const int columnCount = DateTime.daysPerWeek;
              final double tileWidth = (constraints.maxWidth -
                      2 * calendarWeekPickerHorizontalPadding) /
                  columnCount;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: calendarWeekPickerHorizontalPadding,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: tileWidth,
                itemCount: days.length,
                scrollDirection: Axis.horizontal,
                addRepaintBoundaries: false,
                itemBuilder: (_, int index) => days.elementAt(index),
              );
            },
          );
        },
        itemCount: itemCount,
        onPageChanged: widget.onWeekPageChanged,
      ),
    );
  }
}
