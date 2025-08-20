import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';

class InviteMemberScreen extends StatefulWidget {
  @override
  _InviteMemberScreenState createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    final houseId = dataManager.loginHouse?.id ??
        'N/A';

    final TextEditingController idController =
        TextEditingController(text: houseId);

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: houseId)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ID copiato negli appunti!')),
        );
      });
      Navigator.pop(context);
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Invita nella casa",
          style: TextStyle(fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Copia l'ID della casa \n e condividilo con i tuoi coinquilini!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign
                        .center,
                  ),
                ),
                SizedBox(height: 48),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.pin),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'ID della casa',
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 48),
                Align(
                  alignment: Alignment.center,
                  child: FilledButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        copyToClipboard();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: screenWidth * 0.3,
                      child: Center(child: Text('Copia ID')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
