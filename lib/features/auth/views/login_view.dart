import 'package:appointement_phone_app/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? phoneNumber;
  String? countryCode;
  String? errorMessage;
  late FirebaseAuth _auth;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }


  void _verifyPhone() async {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      setState(() {
        errorMessage = 'Phone number is required';
      });
      return;
    }

    if (countryCode == null) {
      setState(() {
        errorMessage = 'Country code is required';
      });
      return;
    }

    final fullPhoneNumber = '$countryCode$phoneNumber';
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print("The verfication code is send");
          Navigator.of(context).pushNamed(AppRoutes.homePageRoute);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            errorMessage = 'Verification failed. Please try again.';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          Navigator.of(context).pushNamed(AppRoutes.otpPageRoute);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            errorMessage = 'Timeout occurred. Please try again.';
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }


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
              SizedBox(height: 20),
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
                  onPressed: _verifyPhone,
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
