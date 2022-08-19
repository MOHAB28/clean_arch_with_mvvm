import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../resources/routes_manager.dart';
import '../view_model/on_boarding_viewmodel.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/constants_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/models/model.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  final AppPrefrences _appPrefs = instance<AppPrefrences>();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();
  @override
  void initState()  {
    _appPrefs.setOnBoardingScreenViewed();
    _viewModel.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSLiderViewObject,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox();
        } else {
          return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
              toolbarHeight: AppSize.s1,
              backgroundColor: ColorManager.white,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: ColorManager.white,
              ),
            ),
            body: PageView.builder(
              controller: _controller,
              itemCount: snapshot.data!.numberOfSlides,
              onPageChanged: (index) {
                _viewModel.onPageChanged(index);
              },
              itemBuilder: (context, index) {
                return PageViewItemBuilder(sliderObject: snapshot.data!.slider);
              },
            ),
            bottomSheet: Container(
              color: ColorManager.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.loginRoute,
                        );
                      },
                      child: Text(
                        AppStrings.skip,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  Container(
                    color: ColorManager.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Left Arrow
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              _controller.animateToPage(
                                _viewModel.previousPage(),
                                duration: const Duration(
                                  milliseconds:
                                      AppConstants.sliderAnimationTime,
                                ),
                                curve: Curves.bounceInOut,
                              );
                            },
                            child: SizedBox(
                              height: AppSize.s20,
                              width: AppSize.s20,
                              child: SvgPicture.asset(ImageAssets.leftArrowIc),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            for (int i = 0;
                                i < snapshot.data!.numberOfSlides;
                                i++)
                              Padding(
                                padding: const EdgeInsets.all(AppPadding.p8),
                                child: GetProperCircule(
                                  currentIndex: snapshot.data!.currentIndex,
                                  index: i,
                                ),
                              )
                          ],
                        ),
                        //Right Arrow
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              _controller.animateToPage(
                                _viewModel.nextPage(),
                                duration: const Duration(
                                  milliseconds:
                                      AppConstants.sliderAnimationTime,
                                ),
                                curve: Curves.bounceInOut,
                              );
                            },
                            child: SizedBox(
                              height: AppSize.s20,
                              width: AppSize.s20,
                              child: SvgPicture.asset(ImageAssets.rightArrowIc),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class GetProperCircule extends StatelessWidget {
  const GetProperCircule({
    Key? key,
    required int index,
    required int currentIndex,
  })  : _currentIndex = currentIndex,
        _index = index,
        super(key: key);
  final int _index;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    if (_index == _currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    }
  }
}

class PageViewItemBuilder extends StatelessWidget {
  const PageViewItemBuilder({
    Key? key,
    required SliderObject sliderObject,
  })  : _sliderObject = sliderObject,
        super(key: key);
  final SliderObject _sliderObject;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSize.s40),
        Text(
          _sliderObject.title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: AppSize.s7),
        Text(
          _sliderObject.subTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSize.s60),
        SvgPicture.asset(_sliderObject.image),
      ],
    );
  }
}
