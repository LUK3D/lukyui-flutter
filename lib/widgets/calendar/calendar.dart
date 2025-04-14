import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import 'package:lukyui/widgets/fadeout_mask.dart';

import '../../utils/shadow.dart';
import 'year_month_picker.dart';

// Calendar widget that shows a monthly grid and allows date selection
class LukyCalendar extends StatefulWidget {
  final DateTime? initialDate; // Optional initial date to show as selected
  final Function(DateTime)?
      onDateSelected; // Callback for when a date is selected
  final double? width; // Optional width for the calendar
  final double? height; // Optional height for the calendar
  final Color? backgroundColor; // Optional background color for the calendar
  final BorderRadius? borderRadius; // Optional border radius for the calendar
  final BorderRadius?
      buttonBorderRadius; // Optional border radius for the calendar
  final Color? selectedTextColor; // Optional selected color for the calendar
  final Color?
      selectedBackgroudColor; // Optional selected color for the calendar
  final Color? foregroundColor; // Optional foreground color for the calendar
  final Widget? Function(
          String label, DateTime value, Function(DateTime date) onClick)?
      selectedDateBuilder; // Optional builder for selected date
  final Widget? Function(
          String label, DateTime value, Function(DateTime date) onClick)?
      dayBuilder; // Optional builder for each day

  final double? buttonSpacing;
  final List<String>? monthsLabel;
  final List<String>? daysLabel;
  final List<BoxShadow>? boxShadow; // Optional box shadow for the calendar

  const LukyCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.foregroundColor,
    this.selectedTextColor,
    this.selectedDateBuilder,
    this.dayBuilder,
    this.selectedBackgroudColor,
    this.buttonBorderRadius,
    this.buttonSpacing,
    this.daysLabel,
    this.monthsLabel,
    this.boxShadow,
  })  : assert(daysLabel == null || daysLabel.length == 7,
            "Days label must be null or have 7 entries"),
        assert(monthsLabel == null || monthsLabel.length == 12,
            "Months label must be null or have 12 entries");

  @override
  State<LukyCalendar> createState() => _LukyCalendarState();
}

class _LukyCalendarState extends State<LukyCalendar> {
  late DateTime _selectedDate; // Currently selected date
  late DateTime _currentMonth; // The month currently being displayed
  bool selectingYearOrMonth =
      false; // Flag to indicate if year selection is active

  @override
  void initState() {
    super.initState();
    // Initialize selected date and current month (start of the selected month)
    _selectedDate = widget.initialDate ?? DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_selectedDate.year, _currentMonth.month - 1);
      _selectedDate =
          DateTime(_currentMonth.year, _currentMonth.month, _selectedDate.day);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _selectedDate =
          DateTime(_currentMonth.year, _currentMonth.month, _selectedDate.day);
    });
  }

  List<Widget> _buildDayLabels(BuildContext context) {
    final theme = Luky.of(context).theme;
    late final days =
        widget.daysLabel ?? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days
        .map((day) => Center(
              child: Text(day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  )),
            ))
        .toList();
  }

  Map<int, String>? _getMonthsMap() {
    if (widget.monthsLabel == null) {
      return null;
    }

    final data = <int, String>{};

    for (var months in widget.monthsLabel!) {
      data[widget.monthsLabel!.indexOf(months)] = months;
    }

    return data;
  }

  // Build date cells for the current month
  List<Widget> _buildDateCells(BuildContext context) {
    final theme = Luky.of(context).theme;
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday =
        firstDayOfMonth.weekday % 7; // Convert to 0-indexed (Sunday = 0)
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // Calculate how many cells needed to fill the weeks grid
    final totalCells = firstWeekday + daysInMonth;
    final weeks = (totalCells / 7).ceil() * 7;

    return List.generate(weeks, (index) {
      final dayOffset = index - firstWeekday + 1;

      final date = DateTime(_currentMonth.year, _currentMonth.month, dayOffset);

      // Check if this date is currently selected
      final isSelected = _selectedDate.year == date.year &&
          _selectedDate.month == date.month &&
          _selectedDate.day == date.day;

      final label =
          '${(dayOffset <= 0 || dayOffset > daysInMonth) ? date.day : dayOffset}';
      if (widget.dayBuilder != null) {
        return widget.dayBuilder!.call(label, date, (date) {
          setState(() => _selectedDate = date);
          widget.onDateSelected?.call(date);
        })!;
      }

      if (widget.selectedDateBuilder != null && isSelected) {
        return widget.selectedDateBuilder!.call(label, date, (date) {
          setState(() => _selectedDate = date);
          widget.onDateSelected?.call(date);
        })!;
      }

      return Opacity(
          opacity: (dayOffset <= 0 || dayOffset > daysInMonth) ? 0.3 : 1,
          child: LukyButton(
            variant: LukyButtonVariant.light,
            backgroundColor: isSelected
                ? (widget.selectedBackgroudColor ?? theme.colorScheme.primary)
                : null,
            padding: EdgeInsets.all((getSize(LukySize.xs, context) ?? 4) - 3),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            borderRadius:
                widget.buttonBorderRadius ?? BorderRadius.circular(100),
            foregroundColor: isSelected
                ? (widget.selectedTextColor ?? theme.colorScheme.onPrimary)
                : (widget.foregroundColor ?? theme.colorScheme.onSurface),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (widget.selectedTextColor ?? theme.colorScheme.onPrimary)
                    : (widget.foregroundColor ?? theme.colorScheme.onSurface),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              setState(() => _selectedDate = date);
              widget.onDateSelected?.call(date);
            },
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format current month to something like "April 2025"
    final monthName = widget.monthsLabel != null
        ? "${widget.monthsLabel![_currentMonth.month - 1]} ${_currentMonth.year}"
        : DateFormat.yMMMM().format(_currentMonth);
    final theme = Luky.of(context).theme;

    return SizedBox(
      width: widget.width ?? 300,
      height: widget.height,
      child: Container(
        width: widget.width ?? 300,
        height: widget.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.colorScheme.surface,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          boxShadow: widget.boxShadow ?? LukyShadow.basic,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Header with month and navigation arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (!selectingYearOrMonth)
                      ? IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: widget.foregroundColor ??
                                theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          onPressed: _goToPreviousMonth)
                      : SizedBox(),
                  LukyButton(
                    onPressed: () {
                      setState(() {
                        selectingYearOrMonth = !selectingYearOrMonth;
                      });
                    },
                    size: LukySize.xs,
                    backgroundColor:
                        theme.colorScheme.dividerColor.withAlpha(100),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    borderRadius: BorderRadius.circular(100),
                    variant: LukyButtonVariant.solid,
                    foregroundColor: widget.foregroundColor ??
                        theme.colorScheme.onSurface.withAlpha(100),
                    child: Text(
                      monthName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.foregroundColor ??
                            theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  (!selectingYearOrMonth)
                      ? IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: widget.foregroundColor ??
                                theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          onPressed: _goToNextMonth)
                      : SizedBox(),
                ],
              ),

              selectingYearOrMonth
                  ? LukyFadeoutMask(
                      child: LukyYearAndMonthPicker(
                        width: widget.width ?? 300,
                        height: widget.height ?? 300,
                        initialDate: _selectedDate,
                        months: _getMonthsMap(),
                        onDateChanged: (value) {
                          setState(() {
                            _selectedDate = value;
                            _currentMonth = DateTime(value.year, value.month);
                          });
                        },
                      ),
                    )
                  : Column(
                      children: [
                        // Weekday labels
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 7,
                          children: _buildDayLabels(context),
                        ),
                        // Calendar date cells
                        GridView.count(
                          mainAxisSpacing: widget.buttonSpacing ?? 0,
                          crossAxisSpacing: widget.buttonSpacing ?? 0,
                          shrinkWrap: true,
                          crossAxisCount: 7,
                          children: _buildDateCells(context),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
