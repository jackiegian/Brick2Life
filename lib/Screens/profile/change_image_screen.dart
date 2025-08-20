import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';

class ChangeImageScreen extends StatefulWidget {
  @override
  State<ChangeImageScreen> createState() => _ChangeImageScreenState();
}

class _ChangeImageScreenState extends State<ChangeImageScreen> {
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
      dataManager.notifyListeners();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Immagine cambiata con successo!')),
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cambia immagine profilo",
        style: TextStyle(fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<DataManager>(builder: (context, manager, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
            
                    profileImage(context);
                  },
                  child: Container(
                    width: screenWidth * 0.3,
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('Cambia')),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
