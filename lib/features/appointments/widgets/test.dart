import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendarPage extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;

  const WeekCalendarPage({
    super.key,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  State<WeekCalendarPage> createState() => _WeekCalendarPageState();
}

class _WeekCalendarPageState extends State<WeekCalendarPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(WeekCalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate!;
      });
    }
  }

  DateTime get startOfWeek {
    return _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(_selectedDate);
      }
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(_selectedDate);
      }
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(date);
      }
    });
  }

  bool _isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildWeekDayName(String day) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(DateTime date) {
    final isSelected = _isSelectedDate(date);
    final isToday = _isToday(date);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          width: 45,
          height: 45,
          child: TextButton(
            onPressed: () => _selectDate(date),
            style: TextButton.styleFrom(
              backgroundColor: isSelected
                  ? Colors.blue
                  : isToday
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthYearHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousWeek,
            tooltip: 'Previous week',
          ),
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextWeek,
            tooltip: 'Next week',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = List.generate(
      7,
          (index) => startOfWeek.add(Duration(days: index)),
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMonthYearHeader(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeekDayName('Mon'),
                _buildWeekDayName('Tue'),
                _buildWeekDayName('Wed'),
                _buildWeekDayName('Thu'),
                _buildWeekDayName('Fri'),
                _buildWeekDayName('Sat'),
                _buildWeekDayName('Sun'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((date) => _buildDateButton(date)).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}