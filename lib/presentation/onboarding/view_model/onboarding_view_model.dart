import 'dart:async';

import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/base/base_view_model.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/assets_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/strings_manager.dart';

class OnboardingViewModel extends BaseViewModel
    with OnboardingViewModelInputs, OnboardingViewModelOutputs {
  // .. communicate view-model with view
  // ... using stream controllers => for OUTPUTS
  // .... stream controller of type (SliderViewObject)
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  // .. slider object list
  late final List<SliderObject> _list;

  // .. current slider index
  int _currentIndex = 0;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    // update the current index
    _currentIndex = index;

    // send the new data to view
    _postDataToView();
  }

  // ... INPUTS
  @override
  // .. get the sink and initialize it (_streamController.sink)
  Sink get inputSliderViewObject => _streamController.sink;

  // ... OUTPUTS
  @override
  // .. get the stream and initialize it (_streamController.stream) .. map..
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((event) => event);

  // ...
  // .. on boarding view functions

  // ..
  void _postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }

  // .. get slider data
  List<SliderObject> _getSliderData() => [
        const SliderObject(AppStrings.onBoardingTitle1,
            AppStrings.onBoardingSubTitle1, ImageAssets.onboardingLogo1),
        const SliderObject(AppStrings.onBoardingTitle2,
            AppStrings.onBoardingSubTitle2, ImageAssets.onboardingLogo2),
        const SliderObject(AppStrings.onBoardingTitle3,
            AppStrings.onBoardingSubTitle3, ImageAssets.onboardingLogo3),
        const SliderObject(AppStrings.onBoardingTitle4,
            AppStrings.onBoardingSubTitle4, ImageAssets.onboardingLogo4),
      ];
}

// .. inputs
// ... means "ORDERS" that our view model will receive from view
abstract mixin class OnboardingViewModelInputs {
  //.. when click on right arrow or swipe left
  int goNext();

  //.. when click on left arrow or swipe right
  int goPrevious();

  //..
  void onPageChanged(int index);

  // .. INPUTS
  // .. stream controller inputs
  // .. getter
  Sink get inputSliderViewObject;
}

abstract mixin class OnboardingViewModelOutputs {
  // .. OUTPUTS
  // .. stream controller outputs of type (SliderViewObject)
  // .. getter
  Stream<SliderViewObject> get outputSliderViewObject;
}

// slider view object model
class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
