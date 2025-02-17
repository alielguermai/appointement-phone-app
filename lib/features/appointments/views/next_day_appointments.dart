import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NextDaysAppointments extends StatefulWidget {
  final int numberOfDays;
  final DateTime week;

  const NextDaysAppointments({
    super.key,
    this.numberOfDays = 3,
    required this.week,
  });

  @override
  State<NextDaysAppointments> createState() => _NextDaysAppointmentsState();
}

class _NextDaysAppointmentsState extends State<NextDaysAppointments> {
  late Future<Map<String, List<Map<String, dynamic>>>> appointmentsByDay;
  List<String> formattedDates = [];
  List<String> dbDates = [];
  bool isDeleting = false;
  Map<String, GlobalKey> dayKeys = {};

  late final List<DateTime> dateTimes;

  @override
  void initState() {
    super.initState();
    _initializeData();
    appointmentsByDay = fetchAppointmentsForMultipleDays();
  }

  void _updateData() {

    formattedDates.clear();
    dbDates.clear();
    dateTimes.clear();
    dayKeys.clear();

    DateTime now = widget.week;
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    for (DateTime date = startOfWeek; date.isBefore(endOfWeek.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('E d').format(date);
      String dbDate = DateFormat('yyyy-M-d').format(date);

      formattedDates.add(formattedDate);
      dbDates.add(dbDate);
      dateTimes.add(date);
      dayKeys[formattedDate] = GlobalKey();
    }
  }

  @override
  void didUpdateWidget(NextDaysAppointments oldWidget) {
    super.didUpdateWidget(oldWidget);


    if (widget.week != oldWidget.week) {
      _updateData();
      setState(() {
        appointmentsByDay = fetchAppointmentsForMultipleDays();
      });
    }
  }

  void _initializeData() {
    formattedDates = [];
    dbDates = [];
    dateTimes = [];
    dayKeys = {};

    DateTime now = widget.week;
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    for (DateTime date = startOfWeek; date.isBefore(endOfWeek.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('E d').format(date);
      String dbDate = DateFormat('yyyy-M-d').format(date);

      formattedDates.add(formattedDate);
      dbDates.add(dbDate);
      dateTimes.add(date);
      dayKeys[formattedDate] = GlobalKey();
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAppointmentsForMultipleDays() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user is logged in.");
        return {};
      }

      String currentUserId = currentUser.uid;
      Map<String, List<Map<String, dynamic>>> results = {};

      for (int i = 0; i < dbDates.length; i++) {

        List<Map<String, dynamic>> combinedResults = [];


        final userQuerySnapshot = await firestore
            .collection("appointments")
            .where("date", isEqualTo: dbDates[i])
            .where("userId", isEqualTo: currentUserId)
            .get();

        final contactQuerySnapshot = await firestore
            .collection("appointments")
            .where("date", isEqualTo: dbDates[i])
            .where("contactId", isEqualTo: currentUserId)
            .get();

        combinedResults.addAll(userQuerySnapshot.docs.map((doc) => {
              "docId": doc.id,
              ...doc.data(),
            }));

        combinedResults.addAll(contactQuerySnapshot.docs.map((doc) => {
              "docId": doc.id,
              ...doc.data(),
            }));


        final uniqueResults = {for (var item in combinedResults) item["docId"]: item}.values.toList();

        results[formattedDates[i]] = uniqueResults;
      }

      return results;
    } catch (e) {
      print("Error fetching appointments: $e");
      return {};
    }
  }




  void deleteAppointment(String docId) async {
    if (docId.isEmpty) {
      print("Error: Document ID is empty");
      return;
    }

    /*
    setState(() {
      isDeleting = true;
    });
    */

    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(docId)
          .delete();

      final updatedAppointments = await fetchAppointmentsForMultipleDays();

      setState(() {
        appointmentsByDay = Future.value(updatedAppointments);
      });

      if (mounted) {
        _showSuccess("Appointment delted successfuly");
      }
    } catch (e) {
      print("Error deleting appointment: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting appointment: $e")),
        );
      }
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget buildAppointmentCard(Map<String, dynamic> appointment) {
  final appointmentColor = getStatusColor(appointment["status"]);

  return Dismissible(
      key: Key(appointment["docId"]),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        deleteAppointment(appointment["docId"]);
      },
      child: Container(
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
                            arguments: appointment["docId"],
                          );
                        },
                        child: const Icon(Icons.edit, size: 15, color: Colors.white),
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
              padding: const EdgeInsets.all(10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${appointment['contact']} ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(" With "),
                          Text(
                            " ${appointment['from']}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
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
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: appointmentsByDay,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
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
            return Container(
              margin: const EdgeInsets.only(left: 10, top: 5),
              child: const Text(
                "No appointments found.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final appointmentsByDay = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: appointmentsByDay.entries.map((entry) {
              final date = entry.key;
              final appointments = entry.value;

              return Column(
                key: dayKeys[date],
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (appointments.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 5),
                      width: double.infinity,
                      child: const Text(
                        "No appointments found.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...appointments.map((appointment) => buildAppointmentCard(appointment)),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}