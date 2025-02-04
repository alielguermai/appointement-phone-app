import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NextDaysAppointments extends StatefulWidget {
  final int numberOfDays; // Number of future days to fetch appointments for

  const NextDaysAppointments({super.key, this.numberOfDays = 3});

  @override
  State<NextDaysAppointments> createState() => _NextDaysAppointmentsState();
}

class _NextDaysAppointmentsState extends State<NextDaysAppointments> {
  late Future<Map<String, List<Map<String, dynamic>>>> appointmentsByDay;
  late final List<String> formattedDates;
  late final List<String> dbDates;

  @override
  void initState() {
    super.initState();
    formattedDates = [];
    dbDates = [];

    for (int i = 1; i <= widget.numberOfDays; i++) {
      DateTime futureDate = DateTime.now().add(Duration(days: i));
      formattedDates.add(DateFormat('E d').format(futureDate)); // Display format
      dbDates.add(DateFormat('yyyy-M-d').format(futureDate)); // DB format
    }

    appointmentsByDay = fetchAppointmentsForMultipleDays();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAppointmentsForMultipleDays() async {
    try {
      final firestore = FirebaseFirestore.instance;
      Map<String, List<Map<String, dynamic>>> results = {};

      for (int i = 0; i < dbDates.length; i++) {
        final querySnapshot = await firestore
            .collection("appointments")
            .where("date", isEqualTo: dbDates[i]) // Fetch appointments for each day
            .get();

        results[formattedDates[i]] = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
      }

      return results;
    } catch (e) {
      print("Error fetching appointments: $e");
      return {};
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return Colors.blue.shade700;
      case 'Completed':
        return Colors.lightGreen;
      case 'In Progress':
        return Colors.orangeAccent.shade100;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: appointmentsByDay,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No appointments found."),
              );
            }

            final appointmentsByDay = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appointmentsByDay.entries.map((entry) {
                final date = entry.key;
                final appointments = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 15),
                      child: Text(
                        date, // Display formatted date
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...appointments.map((appointment) {
                      final appointmentColor = getStatusColor(appointment["status"]);
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: appointmentColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${appointment["time"]} ",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${appointment["status"]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.editAppointment,
                                            arguments: appointment,
                                          );
                                        },
                                        child: const Icon(Icons.edit, size: 15, color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Icon(Icons.delete, size: 15, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: appointmentColor.withOpacity(0.15),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${appointment['title']}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${appointment['date']}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${appointment['contact']}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        "${appointment['location']}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
