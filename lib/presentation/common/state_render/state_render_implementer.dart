import 'package:flutter/material.dart';
import '../../../app/constants.dart';
import '../../resources/strings_manager.dart';
import 'state_render.dart';

abstract class FlowState {
  StateRenderTypes getStateRenderTypes();
  String getMessage();
}

class LoadingState extends FlowState {
  StateRenderTypes stateRenderTypes;
  String message;

  LoadingState({
    required this.stateRenderTypes,
    this.message = AppStrings.loading,
  });
  @override
  String getMessage() => message;

  @override
  StateRenderTypes getStateRenderTypes() => stateRenderTypes;
}

class ErrorState extends FlowState {
  StateRenderTypes stateRenderTypes;
  String message;

  ErrorState({
    required this.stateRenderTypes,
    required this.message,
  });
  @override
  String getMessage() => message;

  @override
  StateRenderTypes getStateRenderTypes() => stateRenderTypes;
}

class EmptyState extends FlowState {
  String message;

  EmptyState({
    required this.message,
  });
  @override
  String getMessage() => message;

  @override
  StateRenderTypes getStateRenderTypes() =>
      StateRenderTypes.fullScreenEmptyState;
}

class ContentState extends FlowState {
  @override
  String getMessage() => Constants.empty;

  @override
  StateRenderTypes getStateRenderTypes() => StateRenderTypes.contentState;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
    BuildContext context,
    Widget contentScreen,
    Function retryActionFunction,
  ) {
    switch (runtimeType) {
      case LoadingState:
        if (getStateRenderTypes() == StateRenderTypes.popupLoadingState) {
          showPopup(
            context,
            retryActionFunction,
            getStateRenderTypes(),
            getMessage(),
          );
          return contentScreen;
        } else {
          return StateRender(
            retryActionFunction: retryActionFunction,
            stateRenderTypes: getStateRenderTypes(),
            message: getMessage(),
          );
        }
      case ErrorState:
        dismissDialog(context);
        if (getStateRenderTypes() == StateRenderTypes.popupErrorState) {
          showPopup(
            context,
            retryActionFunction,
            getStateRenderTypes(),
            getMessage(),
          );
          return contentScreen;
        } else {
          return StateRender(
            retryActionFunction: retryActionFunction,
            stateRenderTypes: getStateRenderTypes(),
            message: getMessage(),
          );
        }
      case EmptyState:
        return StateRender(
          retryActionFunction: retryActionFunction,
          stateRenderTypes: StateRenderTypes.fullScreenEmptyState,
          message: getMessage(),
        );
      case ContentState:
        dismissDialog(context);
        return contentScreen;
      default:
        dismissDialog(context);
        return contentScreen;
    }
  }
}

bool _isCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

void dismissDialog(BuildContext context) {
  if (_isCurrentDialogShowing(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

void showPopup(
  BuildContext context,
  Function retryActionFunction,
  StateRenderTypes stateRenderTypes,
  String message,
) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => showDialog(
      context: context,
      builder: (BuildContext context) => StateRender(
        retryActionFunction: retryActionFunction,
        stateRenderTypes: stateRenderTypes,
        message: message,
      ),
    ),
  );
}
