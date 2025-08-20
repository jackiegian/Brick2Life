import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constructors/account.dart';
import '../../Managers/data_manager.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignUp;

  LoginScreen({required this.onSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void accountLogin(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, compila tutti i campi')),
      );
      return;
    }

    final dataManager = Provider.of<DataManager>(context, listen: false);

    try {
      dataManager.setLoginAccountFromCredentials(username, password);

      if (dataManager.loginAccount != null) {
        if (dataManager.loginHouse != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        } else {
          Navigator.pushNamed(
            context,
            '/choice_house',
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username o password non validi')),
      );
    }
  }

  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Bentornat*!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Accedi compilando i campi sottostanti',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 48),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valueUsername) {
                    if (valueUsername == null || valueUsername.isEmpty) {
                      return 'Inserisci un username.';
                    }
                    return null;
                  },
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.person),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valuePassword) {
                    if (valuePassword == null || valuePassword.isEmpty) {
                      return 'Inserisci una password.';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  controller: passwordController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Password',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        icon: passToggle
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      accountLogin(context);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(
                      child: Text('Accedi'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sei nuovo?",
                      style: TextStyle(fontSize: 13),
                    ),
                    TextButton(
                      onPressed: widget.onSignUp,
                      child: Text(
                        "Crea un account",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
