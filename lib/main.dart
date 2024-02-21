import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductCard(),
    ));
  });
}

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int _currentIndex;
  final List<Map<String, dynamic>> _products = [
    {
      'image': 'assets/images/1.jpeg',
    },
    {
      'image': 'assets/images/2.jpeg',
    },
    {
      'image': 'assets/images/3.jpg',
    },
    {
      'image': 'assets/images/4.jpeg',
    }
  ];

  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(imagePath: _products[_currentIndex]['image']),
          Center(
            child: ProductCarousel(
              products: _products,
              currentIndex: _currentIndex,
              carouselController: _carouselController,
              onIndexChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: CarouselIndicator(
              itemCount: _products.length,
              currentIndex: _currentIndex,
              onTap: (index) {
                _carouselController.animateToPage(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final String imagePath;

  const BackgroundImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}

class ProductCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final int currentIndex;
  final CarouselController carouselController;
  final Function(int, CarouselPageChangedReason)? onIndexChanged;

  const ProductCarousel({
    required this.products,
    required this.currentIndex,
    required this.carouselController,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        initialPage: currentIndex,
        height: 600.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.70,
        enlargeCenterPage: true,
        onPageChanged: onIndexChanged,
      ),
      items: products.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Function(int)? onTap;

  const CarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () {
            onTap?.call(index);
          },
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex ? Colors.white : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
