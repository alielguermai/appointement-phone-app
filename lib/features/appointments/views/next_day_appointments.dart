import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class NextDaysAppointments extends StatefulWidget {
  final int numberOfDays;
  final ScrollController scrollController;
  final Function(DateTime)? onDayVisible;

  const NextDaysAppointments({
    super.key,
    this.numberOfDays = 3,
    required this.scrollController,
    this.onDayVisible,
  });

  @override
  State<NextDaysAppointments> createState() => _NextDaysAppointmentsState();
}

class _NextDaysAppointmentsState extends State<NextDaysAppointments> {
  late Future<Map<String, List<Map<String, dynamic>>>> appointmentsByDay;
  late final List<String> formattedDates;
  late final List<String> dbDates;
  bool isDeleting = false;
  Map<String, GlobalKey> dayKeys = {};

  /*
  @override
  void initState() {
    super.initState();
    formattedDates = [];
    dbDates = [];

    // Initialize dates and keys
    for (int i = 1; i <= widget.numberOfDays; i++) {
      DateTime futureDate = DateTime.now().add(Duration(days: i));
      String formattedDate = DateFormat('E d').format(futureDate);
      String dbDate = DateFormat('yyyy-M-d').format(futureDate);

      formattedDates.add(formattedDate);
      dbDates.add(dbDate);
      dayKeys[formattedDate] = GlobalKey();
    }

    appointmentsByDay = fetchAppointmentsForMultipleDays();
    _setupScrollListener();
  }
  */

  @override
  void initState() {
    super.initState();
    formattedDates = [];
    dbDates = [];
    dayKeys = {};

    // Get the current date
    DateTime now = DateTime.now();

    // Determine the start of the current week (assuming the week starts on Monday)
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // Sunday

    // Generate dates for the current week
    for (DateTime date = startOfWeek; date.isBefore(endOfWeek.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('E d').format(date);
      String dbDate = DateFormat('yyyy-M-d').format(date);

      formattedDates.add(formattedDate);
      dbDates.add(dbDate);
      dayKeys[formattedDate] = GlobalKey();
    }

    appointmentsByDay = fetchAppointmentsForMultipleDays();
    _setupScrollListener();
  }


  void _setupScrollListener() {
    widget.scrollController.addListener(() {
      _checkVisibleDates();
    });
  }

  void _checkVisibleDates() {
  if (!mounted) return;

  for (String formattedDate in formattedDates) {
    final key = dayKeys[formattedDate];
    if (key?.currentContext != null) {
      final RenderBox box = key!.currentContext!.findRenderObject() as RenderBox;
      final RenderAbstractViewport viewport = RenderAbstractViewport.of(box)!;
      final double offset = viewport.getOffsetToReveal(box, 0.5).offset;

      if (offset >= 0 && offset <= MediaQuery.of(context).size.height) {
        int index = formattedDates.indexOf(formattedDate);
        if (index != -1) {
          DateTime visibleDate = DateTime.now().add(Duration(days: index + 1));
          widget.onDayVisible?.call(visibleDate);
          break;
        }
      }
    }
  }
}


  Future<Map<String, List<Map<String, dynamic>>>> fetchAppointmentsForMultipleDays() async {
    try {
      final firestore = FirebaseFirestore.instance;
      Map<String, List<Map<String, dynamic>>> results = {};

      for (int i = 0; i < dbDates.length; i++) {
        final querySnapshot = await firestore
            .collection("appointments")
            .where("date", isEqualTo: dbDates[i])
            .get();

        results[formattedDates[i]] = querySnapshot.docs.map((doc) {
          return {
            "docId": doc.id,
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

  void deleteAppointment(String docId) async {
    if (docId.isEmpty) {
      print("Error: Document ID is empty");
      return;
    }

    setState(() {
      isDeleting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(docId)
          .delete();

      // Re-fetch appointments
      final updatedAppointments = await fetchAppointmentsForMultipleDays();

      setState(() {
        appointmentsByDay = Future.value(updatedAppointments);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment deleted successfully")),
        );
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

  Widget buildAppointmentCard(Map<String, dynamic> appointment) {
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
                          arguments: appointment["docId"],
                        );
                      },
                      child: const Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: isDeleting ? null : () {
                        if (appointment["docId"] != null) {
                          deleteAppointment(appointment["docId"]);
                        }
                      },
                      child: isDeleting
                          ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                          : const Icon(Icons.delete, size: 15, color: Colors.red),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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

  @override
  void dispose() {
    // Don't dispose the ScrollController as it's managed by parent
    super.dispose();
  }
}