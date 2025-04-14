import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import '../../utils/centered_detector.dart';
import '../../utils/snap_list_view.dart';
import '../smooth_scroll/source.dart';

class LukyYearAndMonthPicker extends StatefulWidget {
  final DateTime? initialDate;
  final int startYear;
  final int? endYear;
  final Color? selectedTextColor;
  final Color? selectedBackgroudColor;
  final Color? foregroundColor;
  final double width;
  final double height;
  final Function(DateTime value)? onDateChanged;
  final bool animateToInitialValue;
  final Map<int, String>? months;
  LukyYearAndMonthPicker({
    super.key,
    this.initialDate,
    this.startYear = 1900,
    this.endYear,
    this.selectedTextColor,
    this.selectedBackgroudColor,
    this.foregroundColor,
    required this.width,
    required this.height,
    this.onDateChanged,
    this.animateToInitialValue = true,
    this.months,
  })  : assert(startYear >= 1900, "Start year must be greater than 1900"),
        assert(endYear == null || endYear > startYear,
            "End year must be greater than start year"),
        assert(initialDate == null ||
            (initialDate.year >= startYear &&
                (endYear == null || initialDate.year <= endYear))),
        assert(
            initialDate == null ||
                (initialDate.month >= 1 && initialDate.month <= 12),
            "Initial date month must be between 1 and 12"),
        assert(months != null && months.length == 12 || months == null,
            "Months map must be null or have 12 entries");

  @override
  State<LukyYearAndMonthPicker> createState() => _LukyYearAndMonthPickerState();
}

class _LukyYearAndMonthPickerState extends State<LukyYearAndMonthPicker> {
  late final Map<int, String> monthMap = widget.months ??
      {
        0: "January",
        1: "February",
        2: "March",
        3: "April",
        4: "May",
        5: "June",
        6: "July",
        7: "August",
        8: "September",
        9: "October",
        10: "November",
        11: "December",
      };

  late String selectedMoth;
  late int selectedYear = DateTime.now().year;
  late List<Widget> yearList;
  late List<Widget> monthList;
  late DateTime actualInitialDate;
  final GlobalKey _parentKey = GlobalKey();
  ScrollController monthScrollController = ScrollController();
  ScrollController yearScrollController = ScrollController();

  triggerChange() {
    final month = monthMap.entries.firstWhere(
      (element) => element.value == selectedMoth,
      orElse: () => MapEntry(0, monthMap[0]!),
    );
    widget.onDateChanged?.call(
      DateTime(
        selectedYear,
        month.key + 1,
        actualInitialDate.day,
      ),
    );
  }

  List<Widget> yearListBuilder(BuildContext context) {
    final theme = Luky.of(context).theme;
    final actualEndYear = widget.endYear ?? (DateTime.now().year + 74);
    List<Widget> yearList = [];
    for (int i = widget.startYear; i <= actualEndYear; i++) {
      final isSelected = selectedYear == i;

      yearList.add(LukyCenteredDetector(
        parentKey: _parentKey,
        tolerance: 20,
        shouldCheckOnInit: isSelected,
        animateToInitialValue: widget.animateToInitialValue,
        debounceDuration: Duration(milliseconds: 200),
        onCenterChanged: (isCentered, center) {
          if (isCentered) {
            setState(() {
              selectedYear = i;
            });
            triggerChange();
          }
        },
        scrollController: yearScrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                i.toString(),
                style: TextStyle(
                  color: selectedYear == i
                      ? (widget.selectedTextColor ?? theme.colorScheme.primary)
                      : (widget.foregroundColor ?? theme.colorScheme.onSurface),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return yearList;
  }

  List<Widget> monthListBuilder(BuildContext context) {
    final theme = Luky.of(context).theme;
    return List.generate(
      12,
      (index) {
        return LukyCenteredDetector(
          parentKey: _parentKey,
          tolerance: 20,
          shouldCheckOnInit: selectedMoth == monthMap[index],
          animateToInitialValue: widget.animateToInitialValue,
          debounceDuration: Duration(milliseconds: 200),
          onCenterChanged: (isCentered, center) {
            if (isCentered) {
              setState(() {
                selectedMoth = monthMap[index]!;
              });
              triggerChange();
            }
          },
          scrollController: monthScrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  monthMap[index]!,
                  style: TextStyle(
                    color: selectedMoth == monthMap[index]
                        ? (widget.selectedTextColor ??
                            theme.colorScheme.primary)
                        : (widget.foregroundColor ??
                            theme.colorScheme.onSurface),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  void initState() {
    selectedMoth = DateFormat.yMMMM()
        .format(widget.initialDate ?? DateTime.now())
        .split(" ")
        .first;
    selectedYear = widget.initialDate?.year ?? DateTime.now().year;
    super.initState();
    actualInitialDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.width,
              height: 40,
              decoration: BoxDecoration(
                color: (widget.selectedBackgroudColor ??
                        Luky.of(context).theme.colorScheme.primary)
                    .withAlpha(50),
                borderRadius:
                    BorderRadius.circular(getSize(LukySize.xs, context) ?? 10),
              ),
            ),
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: Row(
                key: _parentKey,
                children: [
                  Expanded(
                    child: LukyDynMouseScroll(
                        scrollSpeed: 0.5,
                        builder: (context, controller, physics) {
                          monthScrollController = controller;
                          monthList = monthListBuilder(context);

                          return LukyCenterSnapListView(
                            padding: EdgeInsets.symmetric(vertical: 140),
                            physics: physics,
                            controller: monthScrollController,
                            itemCount: monthList.length,
                            itemBuilder: (context, index) {
                              return monthList[index];
                            },
                            itemHeight: 40,
                          );
                        }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LukyDynMouseScroll(
                        scrollSpeed: 0.5,
                        // animationCurve: Curves.linear,
                        builder: (context, controller, physics) {
                          yearScrollController = controller;
                          yearList = yearListBuilder(context);

                          return LukyCenterSnapListView(
                            disableOnDemandRendering: true,
                            padding: EdgeInsets.symmetric(vertical: 140),
                            physics: physics,
                            controller: yearScrollController,
                            itemCount: yearList.length,
                            itemBuilder: (context, index) {
                              return yearList[index];
                            },
                            itemHeight: 40,
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
