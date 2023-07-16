import 'package:advanced_clean_architecture_with_mvvm/app/app_prefs.dart';
import 'package:advanced_clean_architecture_with_mvvm/app/di.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/onboarding/view_model/onboarding_view_model.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/onboarding/widgets/onboarding_page_widget.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/assets_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/color_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/constants_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/routes_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/strings_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _appPreferences.setOnboardingScreenViewed();
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSliderViewObject,
      builder: (context, snapshot) {
        return _getContentWidget(snapshot.data);
      },
    );
  }

  Widget _getContentWidget(SliderViewObject? data) {
    if (data == null) {
      return Container();
    }

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
            controller: _pageController,
            itemCount: data.numOfSlides,
            onPageChanged: (index) {
              _viewModel.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              // return onboarding page
              return OnBoardingPage(data.sliderObject);
            }),
      ),
      bottomSheet: Container(
        color: ColorManager.white,
        height: AppSize.hs120,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.loginRoute);
                },
                child: Text(
                  AppStrings.skip,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            SizedBox(height: AppSize.hs16),

            // widgets indicator and arrows
            _getBottomSheetWidget(data),
          ],
        ),
      ),
    );
  }

  Widget _getBottomSheetWidget(SliderViewObject? data) {
    return Container(
      color: ColorManager.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left arrow
          Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.ws20,
                height: AppSize.hs20,
                child: SvgPicture.asset(
                  ImageAssets.leftArrowIc,
                  color: ColorManager.darkGrey,
                ),
              ),
              onTap: () {
                // go to previous slide
                _pageController.animateToPage(
                  _viewModel.goPrevious(),
                  duration: const Duration(
                    milliseconds: AppConstants.sliderAnimationTime,
                  ),
                  curve: Curves.bounceInOut,
                );
              },
            ),
          ),

          // circle indicator

          // right arrow

          Row(
            children: [
              for (int i = 0; i < data!.numOfSlides; i++)
                Padding(
                  padding: EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, data.currentIndex),
                )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.ws20,
                height: AppSize.hs20,
                child: SvgPicture.asset(
                  ImageAssets.rightArrowIc,
                  color: ColorManager.darkGrey,
                ),
              ),
              onTap: () {
                // go to previous slide
                _pageController.animateToPage(
                  _viewModel.goNext(),
                  duration: const Duration(
                    milliseconds: AppConstants.sliderAnimationTime,
                  ),
                  curve: Curves.bounceInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(
        ImageAssets.hollowCircleIc,
        color: ColorManager.darkGrey,
      );
    } else {
      return SvgPicture.asset(
        ImageAssets.solidCircleIc,
        color: ColorManager.darkGrey,
      );
    }
  }

  // .. dispose function
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
