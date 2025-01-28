import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:appointement_phone_app/features/appointments/widgets/custom_button.dart';
import 'package:appointement_phone_app/features/appointments/widgets/custom_text_field.dart';
import 'package:appointement_phone_app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _Appointments();
}

class _Appointments extends State<Appointments> {
  final List<String> meetingTypes = [
    "Business Meeting",
    "Team Meeting",
    "Client Call",
    "Project Discussion",
    "One-on-One",
    "Brainstorming Session",
  ];

  final List<String> locations = [
    "Office building",
    "Apartement",
    "Room"
  ];

  final List<String> categories = [
    "Business",
    "Project",
    "Internship"
  ];

  String selectedMeetingType = "Business Meeting";
  String selectedLocationType = "Office building";
  String selectedCategorieType = "Business";
  String selectedContact = ""; // Store selected contact
  String selectedDate = ""; // Store the selected date
  String selectedTime = ""; // Store selected time

  // Function to show the time picker
  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Default time
    );

    if (pickedTime != null) {
      setState(() {
        // Format the time as HH:MM AM/PM
        selectedTime = pickedTime.format(context);
      });
    }
  }

  // Function to show the calendar and select a date
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Today's date
      firstDate: DateTime(2000), // Minimum selectable date
      lastDate: DateTime(2100), // Maximum selectable date
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  // Generic method to show a bottom sheet and select an item from a list
  void _showSelectionList(List<String> options, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  onSelected(options[index]); // Pass the selected value back
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  // Function to fetch and display contacts
  Future<void> _selectContact() async {
    if (!await FlutterContacts.requestPermission()) {
      // Permission denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("Please allow access to contacts in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Fetch contacts
    final contacts = await FlutterContacts.getContacts(withProperties: true);

    // Show contacts in bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName),
            onTap: () {
              setState(() {
                selectedContact = contact.displayName; // Save selected contact
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }


  void saveAppointmentToFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must be logged in to create an appointment.')));
        return;
      }

      // data to save
      final appointmentData = {
        "meetingType": selectedMeetingType,
        "contact": selectedContact,
        "date": selectedDate,
        "time": selectedTime,
        "location": selectedLocationType,
        "category": selectedCategorieType,
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user.uid,
      };

      await firestore.collection("appointments").add(appointmentData);

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment created successfully!")),
      );
      Navigator.of(context).pushNamed(AppRoutes.homePageRoute);
    } catch (e) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create appointment: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Create New Appointment',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  CustomTextField(
                    label: "Title",
                    hintText: selectedMeetingType,
                    onTap: () {
                      _showSelectionList(meetingTypes, (selectedValue) {
                        setState(() {
                          selectedMeetingType = selectedValue;
                        });
                      });
                    },
                    readOnly: true,
                  ),
                  CustomTextField(
                    label: "With",
                    hintText: selectedContact.isEmpty
                        ? "Select contact"
                        : selectedContact,
                    onTap: _selectContact,
                    readOnly: true,
                  ),
                  CustomTextField(
                    label: "Date",
                    onTap: _selectDate,
                    readOnly: true,
                    hintText: selectedDate.isEmpty ? "Select Date" : selectedDate,
                  ),
                  CustomTextField(
                    label: "Time",
                    onTap: _selectTime,
                    readOnly:
                    true, hintText: selectedTime.isEmpty ? "Select Time" : selectedTime,
                  ),
                  CustomTextField(
                    label: "Location",
                    onTap: () {
                      _showSelectionList(locations, (selectedValue) {
                        setState(() {
                          selectedLocationType = selectedValue;
                        });
                      });
                    },
                    readOnly:
                    true, hintText: selectedLocationType,
                  ),
                  CustomTextField(
                    label: "Category",
                    onTap: () {
                      _showSelectionList(categories, (selectedValue) {
                        setState(() {
                          selectedCategorieType = selectedValue;
                        });
                      });
                    },
                    readOnly:
                    true, hintText: selectedCategorieType,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: "Create Appointment",
                        onPressed: () {
                          if (selectedContact.isNotEmpty &&
                              selectedDate.isNotEmpty &&
                              selectedTime.isNotEmpty) {
                            saveAppointmentToFirestore();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}