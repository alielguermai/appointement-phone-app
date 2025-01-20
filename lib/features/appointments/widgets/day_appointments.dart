import 'package:flutter/material.dart';

class DayAppointments extends StatefulWidget {
  const DayAppointments({super.key});

  @override
  State<DayAppointments> createState() => _DayAppointmentsState();
}

class _DayAppointmentsState extends State<DayAppointments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            Text(
              'Today\'s Appointments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16), // Add space between header and container
            Container(
              width: double.infinity, // Make the container take full width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Subtle shadow
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 8), // Margin around the container
              padding: const EdgeInsets.all(16), // Padding inside the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  Text(
                    'Team Meeting',
                    style: TextStyle(
                      fontSize: 16, // Slightly larger font size
                      fontWeight: FontWeight.bold, // Bold for title
                    ),
                  ),
                  const SizedBox(height: 8), // Space between title and time
                  Text(
                    '2:00 PM - 3:00 PM',
                    style: TextStyle(
                      fontSize: 14, // Normal font size
                      color: Colors.grey[600], // Subtle text color
                    ),
                  ),
                  const SizedBox(height: 4), // Space between time and location
                  Text(
                    'Conference Room A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // Subtle text color
                    ),
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
