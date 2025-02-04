import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class TodayAppointments extends StatefulWidget {
  const TodayAppointments({super.key});

  @override
  State<TodayAppointments> createState() => _TodayAppointmentsState();
}

class _TodayAppointmentsState extends State<TodayAppointments> {
  late Future<List<Map<String, dynamic>>> appointments;
  late Color appointmentColor;

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      final firestore = FirebaseFirestore.instance;
      // IF I want for tomorrow
      final tomorrow = DateTime.now().add(Duration(days: 1));

      final today = DateFormat('yyyy-M-d').format(DateTime.now()); // Updated format

      final querySnapshot = await firestore
          .collection("appointments")
          .where("date", isEqualTo: today) // Ensure "date" matches the field name in Firestore
          .limit(5)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching appointments: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    appointmentColor = getRandomColor();
    appointments = fetchAppointments(); // Fetch appointments in initState
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Appointments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: appointments,
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

                final appointments = snapshot.data!;

                return Column(
                  children: [
                    ...appointments.map((appointment) {
                      final appointmentColor = getRandomColor();
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.editAppointment,
                                            arguments: appointment,
                                          );
                                        },
                                        child: const Icon(Icons.edit, size: 15, color: Colors.white),
                                      )
                                    ],
                                  )
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
                                      )
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
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    TextButton(
                      onPressed: () {
                        // Navigate to a screen that shows all appointments
                        //Navigator.pushNamed(context, AppRoutes.allAppointments);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Color getRandomColor([double opacity = 1.0]) {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
    opacity, // Default is 1.0 (fully opaque)
  );
}
