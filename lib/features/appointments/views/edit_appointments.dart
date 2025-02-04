import 'package:appointement_phone_app/features/appointments/widgets/custom_button.dart';
import 'package:appointement_phone_app/features/appointments/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class EditAppointments extends StatefulWidget {
  const EditAppointments({super.key});

  @override
  State<EditAppointments> createState() => _EditAppointmentsState();
}

class _EditAppointmentsState extends State<EditAppointments> {
  late Map<String, dynamic> appointmentData;

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

  final List<String> reminderOptions = [
    '1 Day Before',
    '2 Hours Before',
    '30 Minutes Before',
  ];

  final List<String> statusOptions = [
    "Scheduled",
    "In Progress",
    "Completed",
  ];

  late String selectedMeetingType;
  late String selectedLocationType;
  late String selectedCategorieType;
  late String selectedContact;
  late String selectedDate;
  late String selectedTime;
  late String selectedStatus;
  late String? _reminderPreference;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the appointment data passed from the previous screen
    appointmentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Initialize the state with the existing appointment data
    selectedMeetingType = appointmentData["meetingType"];
    selectedLocationType = appointmentData["location"];
    selectedCategorieType = appointmentData["category"];
    selectedContact = appointmentData["contact"];
    selectedDate = appointmentData["date"];
    selectedTime = appointmentData["time"];
    selectedStatus = appointmentData["status"];
    _reminderPreference = appointmentData["reminderPreference"];
  }

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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must be logged in to edit an appointment.')));
        return;
      }

      // data to save
      final updatedAppointmentData = {
        "title": selectedMeetingType,
        "meetingType": selectedMeetingType,
        "contact": selectedContact,
        "date": selectedDate,
        "time": selectedTime,
        "location": selectedLocationType,
        "category": selectedCategorieType,
        "status": selectedStatus, // Add the selected status
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user.uid,
        'reminderPreference': _reminderPreference,
      };

      await firestore.collection("appointments").doc(appointmentData["id"]).update(updatedAppointmentData);

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment updated successfully!")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update appointment: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Appointment"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16.0),
              CustomTextField(
                label: "With",
                hintText: selectedContact.isEmpty
                    ? "Select contact"
                    : selectedContact,
                onTap: _selectContact,
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: "Date",
                onTap: _selectDate,
                readOnly: true,
                hintText: selectedDate.isEmpty ? "Select Date" : selectedDate,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: "Time",
                onTap: _selectTime,
                readOnly: true,
                hintText: selectedTime.isEmpty ? "Select Time" : selectedTime,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: "Location",
                onTap: () {
                  _showSelectionList(locations, (selectedValue) {
                    setState(() {
                      selectedLocationType = selectedValue;
                    });
                  });
                },
                readOnly: true,
                hintText: selectedLocationType,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: "Category",
                onTap: () {
                  _showSelectionList(categories, (selectedValue) {
                    setState(() {
                      selectedCategorieType = selectedValue;
                    });
                  });
                },
                readOnly: true,
                hintText: selectedCategorieType,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _reminderPreference,
                items: reminderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _reminderPreference = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Reminder Preference'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a reminder preference';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: "Save Changes",
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
    );
  }
}