import 'package:fitness_sync/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
            controller: controller,
            itemBuilder: (context, index) {
              return SizedBox(
                width: media.width,
                height: media.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/img/on_1.png",
                        width: media.width, fit: BoxFit.fitWidth),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Track your trainings",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.blackColor),
                      ),
                    )
                  ],
                ),
              );
            })
      ],
    ));
  }
}
