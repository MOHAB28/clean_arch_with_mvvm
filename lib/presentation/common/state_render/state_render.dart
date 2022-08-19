import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

enum StateRenderTypes {
  popupLoadingState,
  popupErrorState,

  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  contentState;
}

class StateRender extends StatelessWidget {
  const StateRender({
    Key? key,
    required StateRenderTypes stateRenderTypes,
    required Function retryActionFunction,
    String message = AppStrings.loading,
    // String title = '',
  })  : _stateRenderTypes = stateRenderTypes,
        _retryActionFunction = retryActionFunction,
        _message = message,
        // _title = title,
        super(key: key);

  final StateRenderTypes _stateRenderTypes;
  final Function _retryActionFunction;
  final String _message;
  // final String _title;

  @override
  Widget build(BuildContext context) {
    switch (_stateRenderTypes) {
      case StateRenderTypes.popupLoadingState:
        return const GetPopupDialog(
          children: [
            GetAnimatedImage(
              animationName: JsonAssets.loading,
            )
          ],
        );
      case StateRenderTypes.popupErrorState:
        return GetPopupDialog(
          children: [
            const GetAnimatedImage(animationName: JsonAssets.error),
            GetMessage(message: _message),
            GetRetryButton(
              buttonTitle: AppStrings.ok,
              dismissContext: context,
              retryActionFunction: _retryActionFunction,
              stateRenderTypes: _stateRenderTypes,
            ),
          ],
        );
      case StateRenderTypes.fullScreenLoadingState:
        return GetItemsColumn(
          children: [
            const GetAnimatedImage(animationName: JsonAssets.loading),
            GetMessage(message: _message),
          ],
        );
      case StateRenderTypes.fullScreenErrorState:
        return GetItemsColumn(
          children: [
            const GetAnimatedImage(animationName: JsonAssets.error),
            GetMessage(message: _message),
            GetRetryButton(
              buttonTitle: AppStrings.retryAgain,
              dismissContext: context,
              retryActionFunction: _retryActionFunction,
              stateRenderTypes: _stateRenderTypes,
            ),
          ],
        );
      case StateRenderTypes.fullScreenEmptyState:
        return GetItemsColumn(
          children: [
            const GetAnimatedImage(animationName: JsonAssets.empty),
            GetMessage(message: _message),
          ],
        );
      case StateRenderTypes.contentState:
        return const SizedBox();

      default:
        return const SizedBox();
    }
  }
}

class GetPopupDialog extends StatelessWidget {
  const GetPopupDialog({
    Key? key,
    // required BuildContext dialogContext,
    required List<Widget> children,
  })  :
        //  _dialogContext = dialogContext,
        _children = children,
        super(key: key);
  // final BuildContext _dialogContext;
  final List<Widget> _children;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: AppSize.s1_5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [BoxShadow(color: Colors.black26)],
        ),
        child: GetDialogContent(children: _children),
      ),
    );
  }
}

class GetDialogContent extends StatelessWidget {
  const GetDialogContent({
    Key? key,
    required List<Widget> children,
  })  : _children = children,
        super(key: key);
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _children,
    );
  }
}

class GetItemsColumn extends StatelessWidget {
  const GetItemsColumn({
    Key? key,
    required List<Widget> children,
  })  : _children = children,
        super(key: key);
  final List<Widget> _children;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _children,
    );
  }
}

class GetAnimatedImage extends StatelessWidget {
  const GetAnimatedImage({
    Key? key,
    required String animationName,
  })  : _animationName = animationName,
        super(key: key);
  final String _animationName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(_animationName),
    );
  }
}

class GetMessage extends StatelessWidget {
  const GetMessage({
    Key? key,
    required String message,
  })  : _message = message,
        super(key: key);
  final String _message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          _message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ColorManager.black,
            
            fontSize: FontSize.s18,
          ),
        ),
      ),
    );
  }
}

class GetRetryButton extends StatelessWidget {
  const GetRetryButton({
    Key? key,
    required String buttonTitle,
    required Function retryActionFunction,
    required BuildContext dismissContext,
    required StateRenderTypes stateRenderTypes,
  })  : _buttonTitle = buttonTitle,
        _retryActionFunction = retryActionFunction,
        _dismissContext = dismissContext,
        _stateRenderTypes = stateRenderTypes,
        super(key: key);
  final StateRenderTypes _stateRenderTypes;
  final String _buttonTitle;
  final Function _retryActionFunction;
  final BuildContext _dismissContext;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: ElevatedButton(
          onPressed: () {
            if (_stateRenderTypes == StateRenderTypes.fullScreenErrorState) {
              _retryActionFunction.call();
            } else {
              Navigator.pop(_dismissContext);
            }
          },
          child: Text(
            _buttonTitle,
            style: const TextStyle(
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
  }
}
