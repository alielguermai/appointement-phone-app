import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? phoneNumber;
  String? countryCode;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Enter your Phone number',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: 20,
              ),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'MA',
                onChanged: (phone) {
                  phoneNumber = phone.number;
                  countryCode = phone.countryCode;
                },
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (phoneNumber == null || phoneNumber!.isEmpty) {
                      setState(() {
                        errorMessage = 'Phone number is required';
                      });
                    } else {
                      setState(() {
                        errorMessage = null;
                      });
                      print(phoneNumber);
                      print(countryCode);
                    }
                  },
                  child: Text('Login'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
