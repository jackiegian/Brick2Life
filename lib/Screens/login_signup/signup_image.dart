import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constructors/account.dart';
import '../../Managers/data_manager.dart';

class SignUpImageScreen extends StatefulWidget {
  @override
  State<SignUpImageScreen> createState() => _SignUpImageScreenState();
}

class _SignUpImageScreenState extends State<SignUpImageScreen> {
  final List<String> ImgProfiles = [
    "assets/img_profile/profile_1.png",
    "assets/img_profile/profile_2.png",
    "assets/img_profile/profile_3.png",
    "assets/img_profile/profile_4.png",
    "assets/img_profile/profile_5.png",
    "assets/img_profile/profile_6.png",
  ];

  String? selectedImage;

  void profileImage(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);

    if (selectedImage != null) {
      dataManager.loginAccount!.imgProfile = selectedImage!;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/house_choice',
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Per favore, seleziona un'immagine")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Bring2Life",
          style: TextStyle(
            fontSize: 45,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Consumer<DataManager>(builder: (context, manager, child) {
        return Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              'Ciao ${manager.loginAccount!.name}!',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Seleziona un'immagine per il tuo profilo",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 48,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: EdgeInsets.all(10),
                itemCount: ImgProfiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = ImgProfiles[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedImage == ImgProfiles[index]
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImgProfiles[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 48,
            ),
            FilledButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  profileImage(context);
                });
              },
              child: Container(
                width: screenWidth * 0.3,
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Inizia')),
              ),
            ),
          ],
        );
      }),
    );
  }
}
