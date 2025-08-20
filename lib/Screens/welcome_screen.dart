import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart'
    as carousel;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Managers/data_manager.dart';
import '../Managers/welcome_navigator.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> imgList = [
    "assets/landing/frame4.png",
    "assets/landing/frame2.png",
    "assets/landing/frame3.png",
    "assets/landing/frame1.png"
  ];

  final List<String> imgTextList = [
    "Crea la tua casa",
    "Gestisci le pulizie",
    "Crea liste della spesa",
    "La vita tra coinquilini \n ora è più semplice!"
  ];

  final List<String> subtitleTextList = [
    "Personalizza la casa e aggiungi coinquilini per una convivenza organizzata e collaborativa.",
    "Assegna compiti di pulizia tra i coinquilini per mantenere l'ordine e ridurre i conflitti.",
    "Crea e aggiorna liste della spesa per gestire gli acquisti e evitare dimenticanze.",
    "Esplora tutte le funzionalità e inizia a semplificarti la vita  oggi stesso!"
  ];

  int _currentPage = 0;

  carousel.CarouselController? _carouselController =
      carousel.CarouselController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<DataManager>(builder: (context, manager, child) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.1,
          centerTitle: true,
          title: Text(
            "Brick2Life",
            style: TextStyle(
              fontSize: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CarouselSlider(
                items: imgList.map((i) {
                  int index = imgList.indexOf(i);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image.asset(i),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          imgTextList[index],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          subtitleTextList[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                carouselController: _carouselController,
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: screenHeight * 0.6,
                  initialPage: 0,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: (value, _) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  enableInfiniteScroll:
                      false,
                ),
              ),
              if (_currentPage <
                  imgList.length -
                      1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          IconButton.filled(
                            onPressed: _currentPage > 0
                                ? () {
                                    _carouselController?.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,

                            iconSize: 36,
                            icon: Icon(
                              Icons.chevron_left,
                              color: _currentPage > 0
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors
                                      .grey,
                            ),
                          ),

                          buildCarouselIndicator(),

                          IconButton.filled(
                            onPressed: () {
                              if (_carouselController != null) {
                                _carouselController?.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                print('Error: CarouselController is null');
                              }
                            },
                            iconSize: 36,
                            icon: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          _carouselController?.animateToPage(
                            imgList.length - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "Salta",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_currentPage ==
                  imgList.length - 1)
                buildAuthButtons(screenWidth, screenHeight),
            ],
          ),
        ),
      );
    });
  }

  Widget buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < imgList.length; i++)
          Container(
            margin: EdgeInsets.all(5),
            height: i == _currentPage ? 7 : 5,
            width: i == _currentPage ? 7 : 5,
            decoration: BoxDecoration(
              color: i == _currentPage
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget buildAuthButtons(double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 300), () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: screenHeight * 0.8,
                      child: AuthPageView(
                        initialPage: 1,
                      ),
                    );
                  },
                );
              });
            },
            child: Container(
              width: screenWidth * 0.25,
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Registrati',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Future.delayed(Duration(milliseconds: 300), () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: screenHeight * 0.8,
                      child: AuthPageView(initialPage: 0),
                    );
                  },
                );
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              width: screenWidth * 0.25,
              child: Center(
                child: Text(
                  'Accedi',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
