// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarPickerDisabledDayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarPickerDisabledDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarPickerDisabledDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarPickerDefaultDayColor =
    CupertinoColors.label;
const TextStyle calendarPickerDefaultDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarPickerDefaultDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const TextStyle calendarPickerSelectedDayStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

final TextStyle calendarPickerSelectedCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);

const TextStyle calendarPickerCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

/// A base decoration class for the calendar's month picker day.
abstract class CalendarPickerDayStyle {
  const CalendarPickerDayStyle({
    required this.textStyle,
  });

  /// The [TextStyle] of the calendar's month picker day.
  final TextStyle textStyle;
}

/// A base decoration class for the calendar's month picker background circled day.
abstract class CalendarPickerBackgroundCircledDayStyle
    extends CalendarPickerDayStyle {
  const CalendarPickerBackgroundCircledDayStyle({
    required super.textStyle,
    required this.backgroundCircleColor,
  });

  /// The background circle [Color] of the calendar's month picker day.
  final Color? backgroundCircleColor;
}

/// A decoration class for the calendar's month picker disabled day.
class CalendarPickerDisabledDayStyle extends CalendarPickerDayStyle {
  /// Creates a calendar's month picker disabled day decoration class
  /// with default values for non-provided parameters.
  factory CalendarPickerDisabledDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarPickerDisabledDayStyle._(
      textStyle: textStyle ?? calendarPickerDisabledDayStyle,
    );
  }

  const CalendarPickerDisabledDayStyle._({
    required super.textStyle,
  });

  /// Creates a calendar's month picker disabled day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarPickerDisabledDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarPickerDisabledDayStyle;
    return CalendarPickerDisabledDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? calendarPickerDisabledDayColor,
          context,
        ),
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarPickerDisabledDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarPickerDisabledDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker default day.
class CalendarPickerDefaultDayStyle extends CalendarPickerDayStyle {
  /// Creates a calendar's month picker default day decoration class
  /// with default values for non-provided parameters.
  factory CalendarPickerDefaultDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarPickerDefaultDayStyle,
    );
  }

  const CalendarPickerDefaultDayStyle._({
    required super.textStyle,
  });

  /// Creates a calendar's month picker default day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarPickerDefaultDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarPickerDefaultDayStyle;
    return CalendarPickerDefaultDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarPickerDefaultDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarPickerDefaultDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker selected day.
class CalendarPickerSelectedDayStyle
    extends CalendarPickerBackgroundCircledDayStyle {
  /// Creates a calendar's month picker selected day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarPickerSelectedDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarPickerSelectedDayStyle._(
      textStyle: textStyle ??
          calendarPickerSelectedDayStyle.copyWith(color: mainColor),
      backgroundCircleColor: backgroundCircleColor ?? mainColor?.withAlpha(30),
    );
  }

  const CalendarPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  /// Creates a calendar's month picker selected day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarPickerSelectedDayStyle(
      mainColor: mainColor,
      textStyle: textStyle ??
          calendarPickerSelectedDayStyle.copyWith(
            color: CupertinoDynamicColor.maybeResolve(mainColor, context),
          ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor?.withAlpha(30),
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarPickerSelectedDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarPickerSelectedDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker selected current day.
class CalendarPickerSelectedCurrentDayStyle
    extends CalendarPickerBackgroundCircledDayStyle {
  /// Creates a calendar's month picker selected current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarPickerSelectedCurrentDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarPickerSelectedCurrentDayStyle._(
      textStyle: textStyle ?? calendarPickerSelectedCurrentDayStyle,
      backgroundCircleColor: backgroundCircleColor ?? mainColor,
    );
  }

  const CalendarPickerSelectedCurrentDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  /// Creates a calendar's month picker selected current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarPickerSelectedCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    final TextStyle style =
        textStyle ?? calendarPickerSelectedCurrentDayStyle;
    return CalendarPickerSelectedCurrentDayStyle(
      mainColor: mainColor,
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor,
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarPickerSelectedCurrentDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarPickerSelectedCurrentDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker current day.
class CalendarPickerCurrentDayStyle extends CalendarPickerDayStyle {
  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  factory CalendarPickerCurrentDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarPickerCurrentDayStyle._(
      textStyle: textStyle ?? calendarPickerCurrentDayStyle,
    );
  }

  const CalendarPickerCurrentDayStyle._({
    required super.textStyle,
  });

  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarPickerCurrentDayStyle;
    return CalendarPickerCurrentDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(
          style.color ?? mainColor,
          context,
        ),
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarPickerCurrentDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarPickerCurrentDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
