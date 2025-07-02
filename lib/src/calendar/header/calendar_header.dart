// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

typedef YearPickerCallback = void Function(bool showYearPicker);

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.mode,
    required this.currentMonth,
    required this.onYearPickerStateChanged,
    required this.onPreviousSegmentIconTapped,
    required this.onNextSegmentIconTapped,
    required this.decoration,
    super.key,
  });

  final CupertinoCalendarMode mode;
  final DateTime currentMonth;
  final VoidCallback? onPreviousSegmentIconTapped;
  final VoidCallback? onNextSegmentIconTapped;
  final YearPickerCallback onYearPickerStateChanged;
  final CalendarHeaderDecoration decoration;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _showYearPicker = false;

  CalendarHeaderDecoration get _decoration => widget.decoration;
  bool get _isBackwardDisabled => widget.onPreviousSegmentIconTapped == null;
  bool get _isForwardDisabled => widget.onNextSegmentIconTapped == null;

  void _handleYearPickerStateChange() {
    setState(() {
      _showYearPicker = !_showYearPicker;
      widget.onYearPickerStateChanged.call(_showYearPicker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.currentMonth;
    final String headerString = DateFormat.yMMMM(context.localeString).format(
      date,
    );

    return Row(
      children: <Widget>[
        const SizedBox(width: 20.0),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _handleYearPickerStateChange,
          child: Row(
            children: <Widget>[
              AnimatedDefaultTextStyle(
                duration: innerPickersFadeDuration,
                style: _showYearPicker
                    ? _decoration.monthDateStyle!.copyWith(
                        color: _decoration.monthDateArrowColor,
                      )
                    : _decoration.monthDateStyle!,
                child: Text(headerString),
              ),
              SizedBox(width: 5.0.scale(context)),
              switch (widget.mode) {
                CupertinoCalendarMode.date ||
                CupertinoCalendarMode.dateTime =>
                  AnimatedRotation(
                    duration: innerPickersFadeDuration,
                    curve: Curves.easeInOut,
                    turns: _showYearPicker ? 1.25 : 1.0,
                    child: SizedBox(
                      width: 11.0.scale(context),
                      height: 22.0.scale(context),
                      child: Icon(
                        CupertinoIcons.chevron_forward,
                        color: _decoration.monthDateArrowColor,
                        size: calendarMonthPickerIconSize.scale(context),
                      ),
                    ),
                  ),
                _ => const SizedBox(),
              },
            ],
          ),
        ),
        const Spacer(),
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onPreviousSegmentIconTapped,
                child: SizedBox(
                  height: calendarMonthSwitcherSize,
                  width: calendarMonthSwitcherSize,
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: _isBackwardDisabled
                        ? _decoration.backwardDisabledButtonColor
                        : _decoration.backwardButtonColor,
                    size: calendarMonthSwitcherIconSize.scale(context),
                  ),
                ),
              ),
              SizedBox(width: 2.0.scale(context)),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onNextSegmentIconTapped,
                child: SizedBox(
                  height: calendarMonthSwitcherSize,
                  width: calendarMonthSwitcherSize,
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    color: _isForwardDisabled
                        ? _decoration.forwardDisabledButtonColor
                        : _decoration.forwardButtonColor,
                    size: calendarMonthSwitcherIconSize.scale(context),
                  ),
                ),
              ),
            ],
          ),
          crossFadeState: _showYearPicker
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: innerPickersFadeDuration,
          layoutBuilder: (
            Widget topChild,
            Key topChildKey,
            Widget bottomChild,
            Key bottomChildKey,
          ) {
            return Stack(
              children: <Widget>[
                bottomChild,
                topChild,
              ],
            );
          },
        ),
      ],
    );
  }
}
