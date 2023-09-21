import 'dart:io';

import 'package:advanced_clean_architecture_with_mvvm/app/constants.dart';
import 'package:advanced_clean_architecture_with_mvvm/app/di.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/assets_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/color_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/font_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/strings_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/style_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final _formKey = GlobalKey<FormState>();

  // .. text editing controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  // .. private bind function
  _bind() {
    _viewModel.start();

    // .. listeners
    // .. to view model
    _usernameController.addListener(() {
      _viewModel.setUsername(_usernameController.text);
    });

    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      _viewModel.setPassword(_passwordController.text);
    });

    _mobileNumberController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberController.text);
    });
  }

  // .. init state
  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data
                  // .. magic function
                  ?.getScreenWidget(context, _getContentWidget(),
                      () => _viewModel.register()) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
                child: Image(image: AssetImage(ImageAssets.splashLogo))),
            SizedBox(
              height: AppSize.hs8,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUsername,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _usernameController,
                      decoration: InputDecoration(
                          hintText: AppStrings.username,
                          labelText: AppStrings.username,
                          errorText: snapshot.data),
                    );
                  }),
            ),
            SizedBox(
              height: AppSize.hs12,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        padding: EdgeInsets.zero,
                        onChanged: (country) {
                          // .. update country code in view model
                          _viewModel.setCountryCode(
                              country.dialCode ?? Constants.token);
                        },
                        initialSelection: '+966',
                        favorite: const ['+966', 'JO'],
                        hideMainText: true,
                        showCountryOnly: true,
                        showOnlyCountryWhenClosed: true,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorMobileNumber,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _mobileNumberController,
                            decoration: InputDecoration(
                              hintText: AppStrings.mobileNumber,
                              labelText: AppStrings.mobileNumber,
                              errorText: snapshot.data,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: AppSize.hs12,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmail,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailHint,
                          errorText: snapshot.data),
                    );
                  }),
            ),
            SizedBox(
              height: AppSize.hs12,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPassword,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: snapshot.data),
                    );
                  }),
            ),
            SizedBox(
              height: AppSize.hs12,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: Container(
                height: AppSize.hs40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    border: Border.all(
                        color: ColorManager.grey, width: AppSize.ws1_5)),
                child: GestureDetector(
                  child: _getMediaWidget(),
                  onTap: () {
                    _showPicker(context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: AppSize.hs28,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<bool>(
                  stream: _viewModel.outputAreAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.hs40,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: const Text(AppStrings.register)),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppStrings.alreadyHaveAccount,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                AppStrings.profilePicture,
                style: getRegularStyle(
                    color: ColorManager.grey, fontSize: FontSize.s14),
              )),
          Flexible(
            child: StreamBuilder<File>(
              stream: _viewModel.outputIsProfilePicture,
              builder: (context, snapshot) {
                return _imagePicketByUser(snapshot.data);
              },
            ),
          ),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.camera),
                  title: const Text(AppStrings.photoGallery),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text(AppStrings.photoCamera),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
