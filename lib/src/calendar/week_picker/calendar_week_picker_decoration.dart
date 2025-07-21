// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

/// A decoration class for the calendar's week picker.
class CalendarWeekPickerDecoration {
  /// Creates a calendar's week picker decoration class with default values
  /// for non-provided parameters.
  factory CalendarWeekPickerDecoration({
    CalendarPickerDefaultDayStyle? defaultDayStyle,
    CalendarPickerCurrentDayStyle? currentDayStyle,
    CalendarPickerSelectedDayStyle? selectedDayStyle,
    CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarWeekPickerDecoration._(
      defaultDayStyle: defaultDayStyle,
      currentDayStyle: currentDayStyle,
      selectedDayStyle: selectedDayStyle,
      selectedCurrentDayStyle: selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle,
    );
  }

  const CalendarWeekPickerDecoration._({
    this.defaultDayStyle,
    this.currentDayStyle,
    this.selectedDayStyle,
    this.selectedCurrentDayStyle,
    this.disabledDayStyle,
  });

  /// Creates a calendar's week picker decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarWeekPickerDecoration.withDynamicColor(
      BuildContext context, {
        Color? mainColor,
        CalendarPickerDefaultDayStyle? defaultDayStyle,
        CalendarPickerCurrentDayStyle? currentDayStyle,
        CalendarPickerSelectedDayStyle? selectedDayStyle,
        CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
        CalendarPickerDisabledDayStyle? disabledDayStyle,
      }) {
    return CalendarWeekPickerDecoration(
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
  /// calendar's week picker default day.
  final CalendarPickerDefaultDayStyle? defaultDayStyle;

  /// The [CalendarPickerCurrentDayStyle] of the
  /// calendar's week picker current day.
  final CalendarPickerCurrentDayStyle? currentDayStyle;

  /// The [CalendarPickerSelectedDayStyle] of the
  /// calendar's week picker selected day.
  final CalendarPickerSelectedDayStyle? selectedDayStyle;

  /// The [CalendarPickerSelectedCurrentDayStyle] of the
  /// calendar's week picker selected current day.
  final CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle;

  /// The [CalendarPickerDisabledDayStyle] of the
  /// calendar's week picker disabled day.
  final CalendarPickerDisabledDayStyle? disabledDayStyle;

  /// Creates a copy of the class with the provided parameters.
  CalendarWeekPickerDecoration copyWith({
    CalendarPickerDefaultDayStyle? defaultDayStyle,
    CalendarPickerCurrentDayStyle? currentDayStyle,
    CalendarPickerSelectedDayStyle? selectedDayStyle,
    CalendarPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarWeekPickerDecoration(
      defaultDayStyle: defaultDayStyle ?? defaultDayStyle,
      currentDayStyle: currentDayStyle ?? currentDayStyle,
      selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
      selectedCurrentDayStyle:
      selectedCurrentDayStyle ?? selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    );
  }
}
