import 'dart:async';

import 'package:cla/presentation/common/state_render/state_render.dart';

import '../../../domain/usecase/login_usecase.dart';
import '../../base/base_view_model.dart';
import '../../common/freezed_data_classes.dart';
import '../../common/state_render/state_render_implementer.dart';

class LoginViewmodel extends BaseViewModel
    with LoginViewmodelInputs, LoginViewmodelOutputs {
  final StreamController _userNameController =
      StreamController<String>.broadcast();
  final StreamController _passwordController =
      StreamController<String>.broadcast();
  final StreamController _allFieldsValid = StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccefully = StreamController<bool>();

  var loginObject = LoginObject('', '');
  @override
  void dispose() {
    super.dispose();
    isUserLoggedInSuccefully.close();
    _userNameController.close();
    _passwordController.close();
  }

  final LoginUseCase _loginUseCase;
  LoginViewmodel(this._loginUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void setPassword(String password) {
    loginPasswordInputs.add(password);
    loginObject = loginObject.copyWith(password: password);
    allTextFieldsAreValidInputs.add(null);
  }

  @override
  void setUserName(String userName) {
    loginUserNameInputs.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    allTextFieldsAreValidInputs.add(null);
  }

  @override
  void login() async {
    inputState.add(
        LoadingState(stateRenderTypes: StateRenderTypes.popupLoadingState));
    final successOrFailure = await _loginUseCase(
      LoginUseCaseInput(
        loginObject.userName,
        loginObject.password,
      ),
    );

    successOrFailure.fold(
      (failure) => {
        inputState.add(
          ErrorState(
            stateRenderTypes: StateRenderTypes.popupErrorState,
            message: failure.message,
          ),
        ),
      },
      (auth) {
        inputState.add(ContentState());
        isUserLoggedInSuccefully.add(true);
      },
    );
  }

  @override
  Sink get allTextFieldsAreValidInputs => _allFieldsValid.sink;

  @override
  Sink get loginPasswordInputs => _passwordController.sink;

  @override
  Sink get loginUserNameInputs => _userNameController.sink;

  @override
  Stream<bool> get allTextFieldsAreValidOutputs =>
      _allFieldsValid.stream.map((_) => _allAreValid());

  @override
  Stream<bool> get loginPasswordOutputs =>
      _passwordController.stream.map((password) => _isPasswordValid(password));
  @override
  Stream<bool> get loginUserNameOutputs =>
      _userNameController.stream.map((userName) => _isUerNameValid(userName));

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUerNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _allAreValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUerNameValid(loginObject.userName);
  }
}

abstract class LoginViewmodelInputs {
  void setUserName(String userName);
  void setPassword(String password);
  void login();

  Sink get loginUserNameInputs;
  Sink get loginPasswordInputs;
  Sink get allTextFieldsAreValidInputs;
}

abstract class LoginViewmodelOutputs {
  Stream<bool> get loginUserNameOutputs;
  Stream<bool> get loginPasswordOutputs;
  Stream<bool> get allTextFieldsAreValidOutputs;
}
