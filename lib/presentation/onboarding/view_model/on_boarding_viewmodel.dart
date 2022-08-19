import 'dart:async';

import '../../../domain/models/model.dart';
import '../../base/base_view_model.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  final StreamController<SliderViewObject> _controller =
      StreamController<SliderViewObject>();
  late List<SliderObject> _list;
  int _currentIndex = 0;
  @override
  void dispose() {
    _controller.close();
  }

  @override
  void start() {
    _list = getSLiderObjects;
    _updateData();
  }

  @override
  int nextPage() {
    int nextIndex = ++_currentIndex;
    if(nextIndex == _list.length ){
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _updateData();
  }

  @override
  int previousPage() {
    int previousIndex = -- _currentIndex;
    if(previousIndex == -1){
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  Sink<SliderViewObject> get inputSliderViewObject => _controller.sink;

  @override
  Stream<SliderViewObject> get outputSLiderViewObject =>
      _controller.stream.map((slider) => slider);
  void _updateData() {
    inputSliderViewObject.add(
      SliderViewObject(
        currentIndex: _currentIndex,
        numberOfSlides: _list.length,
        slider: _list[_currentIndex],
      ),
    );
  }

  List<SliderObject> get getSLiderObjects {
    return [
      SliderObject(AppStrings.onBoardingTitle1, AppStrings.onBoardingSubTitle1,
          ImageAssets.onboardingLogo1),
      SliderObject(AppStrings.onBoardingTitle2, AppStrings.onBoardingSubTitle2,
          ImageAssets.onboardingLogo2),
      SliderObject(AppStrings.onBoardingTitle3, AppStrings.onBoardingSubTitle3,
          ImageAssets.onboardingLogo3),
      SliderObject(AppStrings.onBoardingTitle4, AppStrings.onBoardingSubTitle4,
          ImageAssets.onboardingLogo4),
    ];
  }
}

abstract class OnBoardingViewModelInputs {
  int nextPage();
  int previousPage();
  void onPageChanged(int index);

  Sink<SliderViewObject> get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSLiderViewObject;
}
