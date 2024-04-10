import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSubmitting = false;
  String _statusMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _statusMessage = '';
      });

      try {
        final String email = _emailController.text;
        await _auth.sendPasswordResetEmail(email: email);

        setState(() {
          _statusMessage = 'Password reset email sent to $email';
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'Failed to send password reset email';
        });
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color.fromRGBO(237, 42, 110, 1)),// Removes the back button
        title: Center(
          child: Row(
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Color.fromRGBO(237, 42, 110, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(// Set the background color
                  backgroundColor: Color.fromRGBO(237, 42, 110, 1), // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Set border radius here
                  ),
                  minimumSize: Size(150, 50), // Set minimum button size
                ),
                onPressed: _isSubmitting ? null : _resetPassword,
                child: _isSubmitting
                    ? CircularProgressIndicator()
                    : Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
              ),
              SizedBox(height: 16.0),
              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
