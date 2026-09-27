import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/base_type_enum.dart';
import '../models/base_view_model.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget? staticChild;

  final Function(T viewModel)? onViewModelReady;

  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;

  final T Function() viewModelBuilder;

  final bool disposeViewModel;

  final bool createNewViewModelOnInsert;

  final BaseType providerType;

  final bool fireOnViewModelReadyOnce;

  final bool initialiseSpecialViewModelsOnce;

  final Function(T viewModel)? onDispose;

  const BaseView.nonReactive({
    required this.viewModelBuilder,
    required this.builder,
    this.onViewModelReady,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewViewModelOnInsert = false,
    this.fireOnViewModelReadyOnce = false,
    this.initialiseSpecialViewModelsOnce = false,
    super.key,
  }) : providerType = BaseType.nonReactive,
       staticChild = null;

  const BaseView.reactive({
    required this.viewModelBuilder,
    required this.builder,
    this.staticChild,
    this.onViewModelReady,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewViewModelOnInsert = false,
    this.fireOnViewModelReadyOnce = false,
    this.initialiseSpecialViewModelsOnce = false,
    super.key,
  }) : providerType = BaseType.reactive;

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T? _viewModel;

  @override
  void initState() {
    super.initState();
    if (_viewModel == null) {
      _createViewModel();
    } else if (widget.createNewViewModelOnInsert) {
      _createViewModel();
    }
  }

  void _createViewModel() {
    _viewModel = widget.viewModelBuilder();

    if (widget.initialiseSpecialViewModelsOnce &&
        !(_viewModel as BaseViewModel).initialised) {
      _initialiseSpecialViewModels();
      (_viewModel as BaseViewModel?)?.setInitialised(true);
    } else if (!widget.initialiseSpecialViewModelsOnce) {
      _initialiseSpecialViewModels();
    }

    if (widget.onViewModelReady != null) {
      if (widget.fireOnViewModelReadyOnce &&
          !(_viewModel as BaseViewModel).onModelReadyCalled) {
        widget.onViewModelReady!(_viewModel!);
        (_viewModel as BaseViewModel?)?.setOnModelReadyCalled(true);
      } else if (!widget.fireOnViewModelReadyOnce) {
        widget.onViewModelReady!(_viewModel!);
      }
    }
  }

  void _initialiseSpecialViewModels() {
    if (_viewModel is Initialisable) {
      (_viewModel as Initialisable).initialise();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(_viewModel!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.providerType == BaseType.nonReactive) {
      if (!widget.disposeViewModel) {
        return ChangeNotifierProvider<T>.value(
          value: _viewModel!,
          child: widget.builder(context, _viewModel!, widget.staticChild),
        );
      }

      return ChangeNotifierProvider<T>(
        create: (context) => _viewModel!,
        child: widget.builder(context, _viewModel!, widget.staticChild),
      );
    }

    if (!widget.disposeViewModel) {
      return ChangeNotifierProvider<T>.value(
        value: _viewModel!,
        child: Consumer<T>(
          builder: builderWithDynamicSourceInitialise,
          child: widget.staticChild,
        ),
      );
    }

    return ChangeNotifierProvider<T>(
      create: (context) => _viewModel!,
      child: Consumer<T>(
        builder: builderWithDynamicSourceInitialise,
        child: widget.staticChild,
      ),
    );
  }

  Widget builderWithDynamicSourceInitialise(
    BuildContext context,
    T? viewModel,
    Widget? child,
  ) {
    if (viewModel is DynamicSourceViewModel) {
      if (viewModel.changeSource) {
        _initialiseSpecialViewModels();
      }
    }

    return widget.builder(context, viewModel!, child);
  }
}

T getParentViewModel<T>(BuildContext context, {bool listen = true}) =>
    Provider.of<T>(context, listen: listen);
