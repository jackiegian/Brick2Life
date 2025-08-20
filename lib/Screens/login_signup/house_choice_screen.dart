import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_house_screen.dart';
import 'join_house_screen.dart';
import '../../Managers/data_manager.dart';

class HouseChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Brick2Life",
          style: TextStyle(
            fontSize: 45,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Consumer<DataManager>(
          builder: (BuildContext context, manager, child) {
        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ci siamo quasi!',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Crea o entra in una casa",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pushNamed(
                            context,
                            '/create_house',
                          );
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          width: screenWidth * 0.5,
                          child: Center(child: Text('Crea una nuova casa'))),
                    ),
                    SizedBox(height: 24),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pushNamed(
                            context,
                            '/join_house',
                          );
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          width: screenWidth * 0.5,
                          child: Center(
                              child: Text(
                            'Entra in una casa',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 72,
              ),
            ],
          ),
        );
      }),
    );
  }
}
