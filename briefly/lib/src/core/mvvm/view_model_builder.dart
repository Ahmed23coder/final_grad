import 'package:flutter/material.dart';

class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() viewModelBuilder;
  final Widget Function(BuildContext context, T viewModel, Widget? child) builder;
  final Function(T viewModel)? onModelReady;
  final Widget? child;

  const ViewModelBuilder.reactive({
    super.key,
    required this.viewModelBuilder,
    required this.builder,
    this.onModelReady,
    this.child,
  });

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier> extends State<ViewModelBuilder<T>> {
  late T _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModelBuilder();
    if (widget.onModelReady != null) {
      widget.onModelReady!(_viewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) => widget.builder(context, _viewModel, child),
      child: widget.child,
    );
  }
}
