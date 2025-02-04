import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendarPage extends StatefulWidget {
  const WeekCalendarPage({super.key});

  @override
  State<WeekCalendarPage> createState() => _WeekCalendarPageState();
}

class _WeekCalendarPageState extends State<WeekCalendarPage> {
  DateTime selectedDate = DateTime.now();

  DateTime get startOfWeek {
    return selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
  }

  void _nextWeek() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 7));
    });
  }

  void _previousWeek() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 7));
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Month and Year Display with Navigation Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previousWeek),
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextWeek),
              ],
            ),
          ),

          // Weekday Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ))
                  .toList(),
            ),
          ),

          // Dates Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((date) {
                bool isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: 45, // Ensuring enough space for two-digit numbers
                      height: 45,
                      child: TextButton(
                        onPressed: () => _selectDate(date),
                        style: TextButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors.transparent,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10), // More padding
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
