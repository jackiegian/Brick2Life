import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constructors/account.dart';
import '../../Managers/data_manager.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onLogin;

  SignUpScreen({required this.onLogin});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  bool passToggle = true;
  bool repeatPassToggle = true;

  bool validateFields(BuildContext context) {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, compila tutti i campi')),
      );
      return false;
    }

    if (passwordController.text != repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le password non coincidono.')),
      );
      return false;
    }

    return true;
  }

  void accountRegistration(BuildContext context) {
    if (!validateFields(context)) return;

    String name = nameController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    final dataManager = Provider.of<DataManager>(context, listen: false);

    if (dataManager.getAccountByUsername(username) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('L\'username è già in uso.')),
      );
      return;
    }

    Account newAccount = Account(
      name: name,
      username: username,
      password: password,
      imgProfile: '',
      isOnline: true,
    );

    if (dataManager.addAccount(newAccount)) {
      dataManager.setLoginAccount(newAccount);

      Navigator.pushNamed(
        context,
        '/signup_image',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la registrazione.')),
      );
    }
  }

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
                    'Benvenut*!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Compila i campi sottostanti per registrarti',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 48,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valueName) {
                    if (valueName == null || valueName.isEmpty) {
                      return 'Inserisci un nome.';
                    }
                    return null;
                  },
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.abc_rounded),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Nome',
                  ),
                ),
                SizedBox(height: 24),
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
                  textInputAction: TextInputAction.next,
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
                  controller: repeatPasswordController,
                  obscureText: repeatPassToggle,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Ripeti Password',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            repeatPassToggle = !repeatPassToggle;
                          });
                        },
                        icon: repeatPassToggle
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
                      accountRegistration(context);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(
                      child: Text('Registrati',
                      overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sei già registrato?",
                      style: TextStyle(fontSize: 13),
                    ),
                    TextButton(
                      onPressed: widget.onLogin,
                      child: Text(
                        "Accedi",
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
