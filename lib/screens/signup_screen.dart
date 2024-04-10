import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:science_expert01/screens/components/squareButton.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _rePasswordVisible = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateRePassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleRePasswordVisibility() {
    setState(() {
      _rePasswordVisible = !_rePasswordVisible;
    });
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Check if email already exists
        QuerySnapshot emailQuery = await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: _emailController.text)
            .get();

        if (emailQuery.docs.isNotEmpty) {
          // Email already exists, show error dialog
          _showErrorDialog(context, 'Email is Already in use');
          return;
        }

        // Check if name already exists
        QuerySnapshot nameQuery = await FirebaseFirestore.instance
            .collection('Users')
            .where('Name', isEqualTo: _nameController.text)
            .get();

        if (nameQuery.docs.isNotEmpty) {
          // Name already exists, show error dialog
          _showErrorDialog(context, 'Name is Already in use');
          return;
        }

        // Email and name are unique, proceed with signup
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await userCredential.user!.updateDisplayName(_nameController.text);

        await FirebaseFirestore.instance.collection('Users').add({
          'Name': _nameController.text,
          'Email': _emailController.text,
        });

        print("Signed up: ${userCredential.user!.uid}");

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign Up Successful'),
              content: Text('You have successfully signed up!'),
              actions: [
                TextButton(
                  onPressed: () => _navigateToLoginScreen(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // Navigate to the home screen or another screen upon successful signup
      } catch (e) {
        print("Error: $e");

        // Show error dialog
        _showErrorDialog(
            context, 'There was an error during sign up. Please try again.');
        // Handle error (show error message, etc.)
      }
    }
  }

void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Up Failed'),
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style: TextStyle(
                      color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align "Login" text to the left
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 30.0,
                color: Color.fromRGBO(237, 42, 110, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Image.asset('assets/signUp.png', width: 200),
                SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: _validateName,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _rePasswordController,
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _rePasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleRePasswordVisibility,
                    ),
                  ),
                  obscureText: !_rePasswordVisible,
                  validator: _validateRePassword,
                ),
                SizedBox(height: 30.0),
                SquareButton(
                  text: 'Sign Up',
                  size: 75.0,
                  onPressed: () {
                    _signUp(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
