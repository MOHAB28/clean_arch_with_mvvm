import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../../../../domain/models/model.dart';
import '../../../../../domain/usecase/base_usecase.dart';
import '../../../../../domain/usecase/get_home_data_usecase.dart';
import '../../../../base/base_view_model.dart';
import '../../../../common/state_render/state_render.dart';
import '../../../../common/state_render/state_render_implementer.dart';

class HomeViewmodel extends BaseViewModel
    with HomeViewmodelInputs, HomeViewmodelOutputs {
  final StreamController<HomeObject> _homeController =
      BehaviorSubject<HomeObject>();

  final GetHomeDataUsecase _usecase;
   HomeViewmodel(this._usecase);

  @override
  void start() {
    _getHomeData();
  }

  void _getHomeData() async {
    inputState.add(LoadingState(
        stateRenderTypes: StateRenderTypes.fullScreenLoadingState));
    final successOrfailure = await _usecase(NoParams());
    successOrfailure.fold(
      (failure) => inputState.add(
        ErrorState(
          stateRenderTypes: StateRenderTypes.popupErrorState,
          message: failure.message,
        ),
      ),
      (homeData) {
        inputState.add(ContentState());
        homeInputs.add(homeData);
      },
    );
  }

  @override
  void dispose() {
    _homeController.close();
    super.dispose();
  }

  @override
  Sink get homeInputs => _homeController.sink;

  @override
  Stream<HomeObject> get homeOutputs =>
      _homeController.stream.map((homeData) => homeData);
}

abstract class HomeViewmodelInputs {
  Sink get homeInputs;
}

abstract class HomeViewmodelOutputs {
  Stream<HomeObject> get homeOutputs;
}
