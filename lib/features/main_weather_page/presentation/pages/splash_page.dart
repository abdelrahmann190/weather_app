import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/core/services/app_routes.dart';
import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/splash_page_scroll_points.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 500,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  return _buildSplashPageView()[index];
                },
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(
                    () {
                      currentIndex = value;
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: 100,
              child: _buildScrollableDots(),
            ),
            GestureDetector(
              onTap: _nextButtonOnTap,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 30),
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orange,
                ),
                child: Center(
                  child: BlocConsumer<AppControllerBloc, AppControllerState>(
                    listener: (context, state) {
                      if (state is CityNameLoaded) {
                        Navigator.of(context)
                            .popAndPushNamed(AppRoutes.mainWeatherPageRoute);
                      } else if (state is CityNameError) {
                        Navigator.of(context)
                            .popAndPushNamed(AppRoutes.mainWeatherPageRoute);
                      }
                    },
                    builder: (context, state) {
                      return const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSplashPageView() {
    final List<Widget> widgetsList = [
      _buildFirstPage(),
      _buildSecondPage(),
      _buildThirdPage(),
    ];
    return widgetsList;
  }

  Widget _buildFirstPage() {
    return const Center(
      child: Text(
        'Welcome to our weather app',
      ),
    );
  }

  Widget _buildSecondPage() {
    return const Center(
      child: Text(
        "Hope you like it",
      ),
    );
  }

  Widget _buildThirdPage() {
    return const Center(
      child: Text(
        "Let's gooooooooooooo",
      ),
    );
  }

  Widget _buildScrollableDots() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ScrollPoints(
            size: index == currentIndex ? 20 : 10,
            color: index == currentIndex ? Colors.orange : Colors.grey,
          ),
        );
      },
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Future<void> _nextButtonOnTap() async {
    _pageController.nextPage(
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.ease,
    );
    if (currentIndex == 2) {
      BlocProvider.of<AppControllerBloc>(context).add(
        const GetCurrentCityNameEvent(),
      );
    }
  }

  @override
  void initState() {
    BlocProvider.of<AppControllerBloc>(context).add(
      const CheckIfTheAppIsBeingOpenedForFirstTimeEvent(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
