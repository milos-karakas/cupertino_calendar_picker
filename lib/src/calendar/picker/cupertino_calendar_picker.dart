// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/calendar/week_picker/calendar_week_picker.dart';
import 'package:cupertino_calendar_picker/src/calendar/week_picker/calendar_week_picker_decoration.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarPicker extends StatefulWidget {
  const CupertinoCalendarPicker({
    required this.initialDate,
    required this.currentDateTime,
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.selectedDateTime,
    required this.selectableDayPredicate,
    required this.firstDayOfWeekIndex,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onDisplayedMonthChanged,
    required this.onYearPickerChanged,
    required this.weekdayDecoration,
    required this.monthPickerDecoration,
    required this.weekPickerDecoration,
    required this.headerDecoration,
    required this.mainColor,
    required this.mode,
    required this.type,
    required this.timeLabel,
    required this.footerDecoration,
    required this.minuteInterval,
    required this.use24hFormat,
    required this.actions,
    super.key,
  });

  final DateTime initialDate;
  final DateTime currentDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
  final DateTime selectedDateTime;
  final SelectableDayPredicate? selectableDayPredicate;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onTimeChanged;
  final ValueChanged<DateTime> onDisplayedMonthChanged;
  final ValueChanged<DateTime> onYearPickerChanged;
  final CalendarWeekdayDecoration weekdayDecoration;
  final CalendarMonthPickerDecoration monthPickerDecoration;
  final CalendarWeekPickerDecoration weekPickerDecoration;
  final CalendarHeaderDecoration headerDecoration;
  final CalendarFooterDecoration footerDecoration;
  final Color mainColor;
  final CupertinoCalendarMode mode;
  final CupertinoCalendarType type;
  final String? timeLabel;
  final int minuteInterval;
  final bool use24hFormat;
  final int? firstDayOfWeekIndex;
  final List<CupertinoCalendarAction>? actions;

  @override
  CupertinoCalendarPickerState createState() => CupertinoCalendarPickerState();
}

class CupertinoCalendarPickerState extends State<CupertinoCalendarPicker> {
  late DateTime _currentDate;
  late DateTime _selectedDateTime;
  late PageController _pageController;
  late CupertinoCalendarViewMode _previousViewMode;
  late CupertinoCalendarViewMode _viewMode;
  late GlobalKey<CustomCupertinoDatePickerDateTimeState> _timePickerKey;

  CupertinoCalendarViewMode get viewMode => _viewMode;

  set viewMode(CupertinoCalendarViewMode mode) {
    _previousViewMode = viewMode;
    _viewMode = mode;
  }

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;

    final int delta = switch (widget.mode) {
      CupertinoCalendarMode.date ||
      CupertinoCalendarMode.dateTime =>
        DateUtils.monthDelta(
          widget.minimumDateTime,
          _currentDate,
        ),
      CupertinoCalendarMode.dateWeek ||
      CupertinoCalendarMode.dateTimeWeek =>
        PackageDateUtils.weekDelta(
          widget.minimumDateTime,
          _currentDate,
        ),
    };

    _pageController = PageController(initialPage: delta);
    _previousViewMode = CupertinoCalendarViewMode.monthPicker;
    _viewMode = CupertinoCalendarViewMode.monthPicker;
    _timePickerKey = GlobalKey();
    _selectedDateTime = widget.selectedDateTime;
  }

  @override
  void didUpdateWidget(CupertinoCalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final DateTime initialMonth = widget.initialDate;
    final DateTime oldInitialMonth = oldWidget.initialDate;
    if (initialMonth != oldInitialMonth && initialMonth != _currentDate) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => switch (widget.mode) {
          CupertinoCalendarMode.date ||
          CupertinoCalendarMode.dateTime =>
            _showMonth(widget.initialDate, jump: true),
          CupertinoCalendarMode.dateWeek ||
          CupertinoCalendarMode.dateTimeWeek =>
            _showWeek(widget.initialDate, jump: true),
        },
      );
    }

    if (widget.selectedDateTime != oldWidget.selectedDateTime) {
      _selectedDateTime = widget.selectedDateTime;
    }
  }

  /// Earliest allowable month.
  bool get _isDisplayingFirstMonth {
    final DateTime minimumDate = widget.minimumDateTime;
    return !_currentDate.isAfter(
      DateTime(minimumDate.year, minimumDate.month),
    );
  }

  /// Latest allowable month.
  bool get _isDisplayingLastMonth {
    final DateTime maximumDate = widget.maximumDateTime;
    return !_currentDate.isBefore(
      DateTime(maximumDate.year, maximumDate.month),
    );
  }

  /// Earliest allowable week.
  bool get _isDisplayingFirstWeek {
    final DateTime minimumDate = widget.minimumDateTime;
    return _currentDate.isSameWeekAs(minimumDate);
  }

  /// Latest allowable week.
  bool get _isDisplayingLastWeek {
    final DateTime maximumDate = widget.maximumDateTime;
    return _currentDate.isSameWeekAs(maximumDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime minimumDate = widget.minimumDateTime;
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(minimumDate, monthPage);
      final bool isCurrentMonth =
          DateUtils.isSameMonth(_currentDate, monthDate);
      if (!isCurrentMonth) {
        _currentDate = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentDate);
      }
    });
  }

  void _handleWeekPageChanged(int weekPage) {
    setState(() {
      final DateTime minimumDate = widget.minimumDateTime;
      final DateTime weekDate =
          DateUtils.addDaysToDate(minimumDate, weekPage * 7);
      final bool isCurrentWeek = _currentDate.isSameWeekAs(weekDate);
      if (!isCurrentWeek) {
        _currentDate = DateTime(weekDate.year, weekDate.month, weekDate.day);
        widget.onDisplayedMonthChanged(_currentDate);
      }
    });
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handleNextWeek() {
    if (!_isDisplayingLastWeek) {
      _pageController.nextPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handlePreviousWeek() {
    if (!_isDisplayingFirstWeek) {
      _pageController.previousPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  VoidCallback? get _nextChevronCallback => switch (widget.mode) {
        CupertinoCalendarMode.date ||
        CupertinoCalendarMode.dateTime =>
          _isDisplayingLastMonth ? null : _handleNextMonth,
        CupertinoCalendarMode.dateWeek ||
        CupertinoCalendarMode.dateTimeWeek =>
          _isDisplayingLastWeek ? null : _handleNextWeek
      };

  VoidCallback? get _previousChevronCallback => switch (widget.mode) {
        CupertinoCalendarMode.date ||
        CupertinoCalendarMode.dateTime =>
          _isDisplayingFirstMonth ? null : _handlePreviousMonth,
        CupertinoCalendarMode.dateWeek ||
        CupertinoCalendarMode.dateTimeWeek =>
          _isDisplayingFirstWeek ? null : _handlePreviousWeek
      };

  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.minimumDateTime, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _showWeek(DateTime week, {bool jump = false}) {
    final int weekPage = PackageDateUtils.weekDelta(
      widget.minimumDateTime,
      week,
    ) + 1;
    if (jump) {
      _pageController.jumpToPage(weekPage);
    } else {
      _pageController.animateToPage(
        weekPage,
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _toggleYearPicker(bool shouldShowYearPicker) {
    setState(() {
      viewMode = shouldShowYearPicker
          ? CupertinoCalendarViewMode.yearPicker
          : _previousViewMode;
    });
  }

  void _toggleTimePicker(bool shouldShowTimePicker) {
    setState(() {
      viewMode = shouldShowTimePicker
          ? CupertinoCalendarViewMode.timePicker
          : _previousViewMode;
    });
  }

  void _onYearPickerChanged(DateTime date) {
    _selectedDateTime = _selectedDateTime.copyWith(
      year: date.year,
      month: date.month,
    );
    widget.onYearPickerChanged(date);
  }

  void _onDateChanged(DateTime dateTime) {
    _selectedDateTime = _selectedDateTime.copyWith(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
    );
    widget.onDateChanged(_selectedDateTime);
  }

  void _onTimeChanged(DateTime dateTime) {
    _selectedDateTime = _selectedDateTime.copyWith(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
    widget.onTimeChanged(_selectedDateTime);
  }

  void _onDayPeriodChanged(TimeOfDay newTime) {
    final DateTime newDateTime = _selectedDateTime.copyWith(
      hour: newTime.hour,
      minute: _selectedDateTime.minute,
    );
    _timePickerKey.currentState?.scrollToDate(
      newDateTime,
      _selectedDateTime,
      false,
    );
    _selectedDateTime = newDateTime;

    if (viewMode != CupertinoCalendarViewMode.timePicker) {
      widget.onTimeChanged(_selectedDateTime);
    }
  }

  void _onActionPressed(CupertinoCalendarAction action) {
    switch (action) {
      case final ConfirmCupertinoCalendarAction _:
        action.onPressed?.call(_selectedDateTime);
        Navigator.of(context).maybePop();
        break;
      case final CancelCupertinoCalendarAction _:
        action.onPressed?.call();
        Navigator.of(context).maybePop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CupertinoCalendarAction>? actions = widget.actions;
    final bool withActions = actions != null && actions.isNotEmpty;

    return CupertinoPickerMediaQuery(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 13.0),
          CupertinoPickerAnimatedCrossFade(
            firstChild: CalendarHeader(
              mode: widget.mode,
              currentMonth: _currentDate,
              onNextSegmentIconTapped: _nextChevronCallback,
              onPreviousSegmentIconTapped: _previousChevronCallback,
              onYearPickerStateChanged: _toggleYearPicker,
              decoration: widget.headerDecoration,
            ),
            crossFadeState: viewMode == CupertinoCalendarViewMode.timePicker
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
          Expanded(
            child: CupertinoPickerAnimatedCrossFade(
              crossFadeState:
                  viewMode == CupertinoCalendarViewMode.yearPicker ||
                          viewMode == CupertinoCalendarViewMode.timePicker
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              firstChild: Column(
                children: <Widget>[
                  const SizedBox(height: 11.0),
                  CalendarWeekdays(
                    decoration: widget.weekdayDecoration,
                    firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
                  ),
                  switch (widget.mode) {
                    CupertinoCalendarMode.date ||
                    CupertinoCalendarMode.dateTime =>
                      CalendarMonthPicker(
                        monthPageController: _pageController,
                        onMonthPageChanged: _handleMonthPageChanged,
                        currentDate: widget.currentDateTime,
                        displayedMonth: _currentDate,
                        minimumDate: widget.minimumDateTime,
                        maximumDate: widget.maximumDateTime,
                        selectableDayPredicate: widget.selectableDayPredicate,
                        selectedDate: widget.selectedDateTime,
                        onChanged: _onDateChanged,
                        decoration: widget.monthPickerDecoration,
                        mainColor: widget.mainColor,
                        firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
                      ),
                    CupertinoCalendarMode.dateWeek ||
                    CupertinoCalendarMode.dateTimeWeek =>
                      CalendarWeekPicker(
                        weekPageController: _pageController,
                        onWeekPageChanged: _handleWeekPageChanged,
                        currentDate: widget.currentDateTime,
                        displayedWeek: _currentDate,
                        minimumDate: widget.minimumDateTime,
                        maximumDate: widget.maximumDateTime,
                        selectedDate: widget.selectedDateTime,
                        onChanged: _onDateChanged,
                        decoration: widget.weekPickerDecoration,
                        mainColor: widget.mainColor,
                        firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
                      )
                  },
                ],
              ),
              secondChild: Padding(
                padding: const EdgeInsets.only(
                  left: 7.0,
                  right: 7.0,
                  top: 10.0,
                  bottom: 38.0,
                ),
                child: switch (viewMode) {
                  CupertinoCalendarViewMode.yearPicker =>
                    CustomCupertinoDatePicker(
                      minimumDate: DateTime(
                        widget.minimumDateTime.year,
                        widget.minimumDateTime.month,
                      ),
                      maximumDate: DateTime(
                        widget.maximumDateTime.year,
                        widget.maximumDateTime.month,
                      ),
                      mode: CupertinoDatePickerMode.monthYear,
                      onDateTimeChanged: _onYearPickerChanged,
                      initialDateTime: _currentDate,
                    ),
                  CupertinoCalendarViewMode.timePicker =>
                    CupertinoTimePickerWheel(
                      pickerKey: _timePickerKey,
                      onTimeChanged: _onTimeChanged,
                      minimumDateTime:
                          widget.minimumDateTime.truncateToMinutes(),
                      maximumDateTime:
                          widget.maximumDateTime.truncateToMinutes(),
                      initialDateTime: _selectedDateTime.truncateToMinutes(),
                      minuteInterval: widget.minuteInterval,
                      use24hFormat: widget.use24hFormat,
                    ),
                  _ => const SizedBox(),
                },
              ),
            ),
          ),
          if (widget.mode == CupertinoCalendarMode.dateTime ||
              widget.mode == CupertinoCalendarMode.dateTimeWeek)
            CupertinoPickerAnimatedCrossFade(
              firstChild: CalendarFooter(
                decoration: widget.footerDecoration,
                label: widget.timeLabel,
                type: widget.type,
                mainColor: widget.mainColor,
                time: TimeOfDay.fromDateTime(_selectedDateTime),
                onTimePickerStateChanged: _toggleTimePicker,
                onTimeChanged: _onDayPeriodChanged,
                use24hFormat: widget.use24hFormat,
              ),
              crossFadeState: viewMode == CupertinoCalendarViewMode.yearPicker
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          if (widget.type == CupertinoCalendarType.compact &&
              withActions) ...<Widget>[
            const CupertinoPickerDivider(horizontalIndent: 0.0),
            CalendarActions(
              actions: actions,
              onPressed: _onActionPressed,
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
