import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label; // Field label
  final String hintText; // Hint text inside the field
  final VoidCallback? onTap; // Logic to execute when tapped
  final bool readOnly; // Makes the field read-only
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Field Label
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
      
        // TextField with hint and custom behavior
        TextField(
            readOnly: readOnly, // Makes it uneditable if necessary
            onTap: onTap, // Custom tap logic (e.g., open date picker)
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                )))
      ]),
    );
  }
}
