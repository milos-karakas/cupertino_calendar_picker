// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

/// A decoration class for the calendar's month picker.
class CalendarMonthPickerDecoration {
  /// Creates a calendar's month picker decoration class with default values
  /// for non-provided parameters.
  factory CalendarMonthPickerDecoration({
    CalendarPickerDefaultDayStyle? defaultDayStyle,
    CalendarPickerCurrentDayStyle? currentDayStyle,
    CalendarPickerSelectedDayStyle? selectedDayStyle,
    CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration._(
      defaultDayStyle: defaultDayStyle,
      currentDayStyle: currentDayStyle,
      selectedDayStyle: selectedDayStyle,
      selectedCurrentDayStyle: selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle,
    );
  }

  const CalendarMonthPickerDecoration._({
    this.defaultDayStyle,
    this.currentDayStyle,
    this.selectedDayStyle,
    this.selectedCurrentDayStyle,
    this.disabledDayStyle,
  });

  /// Creates a calendar's month picker decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerDecoration.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    CalendarPickerDefaultDayStyle? defaultDayStyle,
    CalendarPickerCurrentDayStyle? currentDayStyle,
    CalendarPickerSelectedDayStyle? selectedDayStyle,
    CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      defaultDayStyle: defaultDayStyle ??
          CalendarPickerDefaultDayStyle.withDynamicColor(context),
      currentDayStyle: currentDayStyle ??
          CalendarPickerCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      disabledDayStyle: disabledDayStyle ??
          CalendarPickerDisabledDayStyle.withDynamicColor(
            context,
          ),
      selectedDayStyle: selectedDayStyle ??
          CalendarPickerSelectedDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      selectedCurrentDayStyle: selectedCurrentDayStyle ??
          CalendarPickerSelectedCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
    );
  }

  /// The [CalendarPickerDefaultDayStyle] of the
  /// calendar's month picker default day.
  final CalendarPickerDefaultDayStyle? defaultDayStyle;

  /// The [CalendarPickerCurrentDayStyle] of the
  /// calendar's month picker current day.
  final CalendarPickerCurrentDayStyle? currentDayStyle;

  /// The [CalendarPickerSelectedDayStyle] of the
  /// calendar's month picker selected day.
  final CalendarPickerSelectedDayStyle? selectedDayStyle;

  /// The [CalendarPickerSelectedCurrentDayStyle] of the
  /// calendar's month picker selected current day.
  final CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle;

  /// The [CalendarPickerDisabledDayStyle] of the
  /// calendar's month picker disabled day.
  final CalendarPickerDisabledDayStyle? disabledDayStyle;

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerDecoration copyWith({
    CalendarPickerDefaultDayStyle? defaultDayStyle,
    CalendarPickerCurrentDayStyle? currentDayStyle,
    CalendarPickerSelectedDayStyle? selectedDayStyle,
    CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      defaultDayStyle: defaultDayStyle ?? defaultDayStyle,
      currentDayStyle: currentDayStyle ?? currentDayStyle,
      selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
      selectedCurrentDayStyle:
          selectedCurrentDayStyle ?? selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    );
  }
}
