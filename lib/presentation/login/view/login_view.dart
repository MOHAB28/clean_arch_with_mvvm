import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../../app/app_prefs.dart';
import '../../common/state_render/state_render_implementer.dart';
import '../../../app/di.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewmodel _viewmodel = instance<LoginViewmodel>();
  final AppPrefrences _appPrefs = instance<AppPrefrences>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  _blind() {
    _viewmodel.start();
    _userNameController
        .addListener(() => _viewmodel.setUserName(_userNameController.text));
    _passwordController
        .addListener(() => _viewmodel.setPassword(_passwordController.text));
    _viewmodel.isUserLoggedInSuccefully.stream.listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          _appPrefs.setUserLoggedIn();
          Navigator.pushReplacementNamed(context, Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _blind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        toolbarHeight: AppSize.s1,
        backgroundColor: ColorManager.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
        ),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewmodel.outputState,
        builder: (context, snapshot) {
          return snapshot.data
                  ?.getScreenWidget(context, _getContent(), () {}) ??
              _getContent();
        },
      ),
    );
  }

  Widget _getContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Center(
                child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),
              const SizedBox(height: AppSize.s28),
              StreamBuilder<bool>(
                stream: _viewmodel.loginUserNameOutputs,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: AppStrings.username,
                      labelText: AppStrings.username,
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.usernameError,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSize.s28),
              StreamBuilder<bool>(
                stream: _viewmodel.loginPasswordOutputs,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: AppStrings.password,
                      labelText: AppStrings.password,
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.passwordError,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSize.s28),
              StreamBuilder<bool>(
                stream: _viewmodel.allTextFieldsAreValidOutputs,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: AppSize.s40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (snapshot.data ?? false)
                          ? () {
                              _viewmodel.login();
                            }
                          : null,
                      child: const Text(AppStrings.login),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSize.s8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.forgotPasswordRoute,
                      );
                    },
                    child: Text(
                      AppStrings.forgetPassword,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.registerRoute,
                      );
                    },
                    child: Text(
                      AppStrings.registerText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _viewmodel.dispose();
    super.dispose();
  }
}
