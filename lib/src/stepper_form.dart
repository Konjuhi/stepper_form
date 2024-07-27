import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stepper_form/src/extension.dart';
import 'package:stepper_form/src/responsive_layout_builder.dart';
import 'package:stepper_form/src/stepper_notifier.dart';

import 'app_button.dart';
import 'ghost_button.dart';

enum Steps {
  before,
  current,
  after,
}

enum StepperActions {
  previous,
  next,
  submit,
  draft,
}

class StepperForm extends ConsumerStatefulWidget {
  /// StepperForm provides a way to display a sequence of steps or pages, each
  /// containing form elements or other content, and allows the user to navigate
  /// through these steps. Actions such as 'Next', 'Previous', 'Submit', and
  /// 'Save Draft' are supported to manage navigation and data handling.
  ///
  /// Usage example:
  /// ```dart
  /// StepperForm(
  ///   pages: [
  ///     StepperPage(
  ///       header: 'Step 1',
  ///       content: Text('Content for step 1'),
  ///       action: [SAction.next],
  ///     ),
  ///     StepperPage(
  ///       header: 'Step 2',
  ///       content: Text('Content for step 2'),
  ///       action: [SAction.previous, SAction.submit],
  ///     ),
  ///   ],
  /// )
  /// ```
  const StepperForm({
    required this.pages,
    this.percentageOfScreenHeight,
    this.stepperHeaderHeight,
    this.backButton,
    this.appButtonSubmittedText,
    this.nextButton,
    this.appButtonSaveDraftText,
    this.appButtonUnsavedDraftText,
    super.key,
  });

  final List<StepperPage> pages;
  final double? percentageOfScreenHeight;
  final double? stepperHeaderHeight;
  final String? backButton;
  final String? nextButton;
  final String? appButtonSubmittedText;
  final String? appButtonSaveDraftText;
  final String? appButtonUnsavedDraftText;

  @override
  StepperFormState createState() => StepperFormState();
}

class StepperFormState extends ConsumerState<StepperForm>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _ghostButtonController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _ghostButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Set the initial step based on the state
    final initialState = ref.read(stepperProvider);
    _currentStep = initialState.currentStep;
    if (kDebugMode) {
      print('Current step: $_currentStep');
    }
    if (_currentStep > 0) {
      _ghostButtonController.forward(from: 0);
    } else {
      _ghostButtonController.reverse(from: 1);
    }

    _updateProgress(animate: false);
  }

  void _nextStep() {
    if (_currentStep < widget.pages.length - 1) {
      setState(() {
        _currentStep++;
      });
      _updateProgress();
      if (_currentStep > 0 && _currentStep < widget.pages.length - 1) {
        _ghostButtonController.forward();
      }
      ref.read(stepperProvider.notifier).reset();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _updateProgress();
      if (_currentStep == 0) {
        _ghostButtonController.reverse();
      }
      ref.read(stepperProvider.notifier).reset();
    }
  }

  void _updateProgress({bool animate = true}) {
    final targetValue = (_currentStep + 1) / widget.pages.length;
    if (animate) {
      _controller.animateTo(
        targetValue,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _controller.value = targetValue;
    }
  }

  List<Widget> _buildActionButtons() {
    final buttons = <Widget>[];

    final actions = widget.pages[_currentStep].action;

    void toggleDraft() {
      final hasDraftData =
      ref.watch(stepperProvider).stepData.containsKey(_currentStep);

      if (hasDraftData) {
        ref.read(stepperProvider.notifier).reset();
      } else {
        ref
            .read(stepperProvider.notifier)
            .saveState(_currentStep, _currentStep);
        ref.read(stepperProvider.notifier).setCurrentStep(_currentStep);
      }
    }

    if (widget.pages[_currentStep].action.contains(StepperActions.draft)) {
      final hasDraftData =
      ref.watch(stepperProvider).stepData.containsKey(_currentStep);
      buttons.add(
        Flexible(
          child: AppButton(
            height: 35,
            horizontalPadding: 26,
            verticalPadding: 20,
            style: TextStyle(
              color: Colors.white,
            ),
            onPressed: toggleDraft,
            text: hasDraftData
                ? widget.appButtonUnsavedDraftText ?? "Un save draft"
                : widget.appButtonSaveDraftText ?? "Save draft",
          ),
        ),
      );
    }
    if (actions.contains(StepperActions.previous) &&
        widget.pages[_currentStep].hasBackButton) {
      buttons.add(
        Flexible(
          child: FadeTransition(
            opacity: _ghostButtonController,
            child: GhostButton(
              verticalPadding: 20,
              horizontalPadding: 26,
              onPressed: _prevStep,
              text: widget.backButton ?? "Back",
            ),
          ),
        ),
      );
    } else if (actions.contains(StepperActions.previous)) {
      buttons.add(
        Flexible(
          child: FadeTransition(
            opacity: _ghostButtonController,
            child: GhostButton(
              verticalPadding: 20,
              horizontalPadding: 26,
              onPressed: null,
              // Disabled
              text: widget.backButton ?? "Back",
            ),
          ),
        ),
      );
    }

    if (actions.contains(StepperActions.next)) {
      buttons.add(
        Flexible(
          child: AppButton(
            height: 35,
            horizontalPadding: 26,
            verticalPadding: 20,
            onPressed: _nextStep,
            text: widget.nextButton ?? "Continue",
          ),
        ),
      );
    }

    if (actions.contains(StepperActions.submit)) {
      buttons.add(
        Flexible(
          child: AppButton(
            height: 35,
            horizontalPadding: 26,
            verticalPadding: 20,
            onPressed: () {
              widget.pages[_currentStep].onSubmitted?.call();
            },
            text: widget.appButtonSubmittedText ?? "Create",
          ),
        ),
      );
    }

    final buttonsWithGaps = <Widget>[];

    for (var i = 0; i < buttons.length; i++) {
      buttonsWithGaps.add(buttons[i]);
      if (i < buttons.length - 1) {
        buttonsWithGaps.add(const Gap(20));
      }
    }

    return buttonsWithGaps;
  }

  @override
  void dispose() {
    _controller.dispose();
    _ghostButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = widget.pages[_currentStep];
    return SizedBox(
      height: widget.percentageOfScreenHeight ?? context.screenHeight * 0.8,
      child: Column(
        children: [
          SizedBox(
            height: widget.stepperHeaderHeight ?? 100,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      top: 50,
                      child: ProgressIndicatorWidget(
                        color:
                        Colors.grey,
                        width: constraints.maxWidth,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: ProgressIndicatorWidget(
                        color:
                        Colors.yellow,
                        width: constraints.maxWidth * _controller.value,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          widget.pages.length,
                              (index) => StepWidget(
                            index: index,
                            width: constraints.maxWidth / widget.pages.length,
                            currentStep: _currentStep.toDouble(),
                            stepLabels:
                            widget.pages.map((e) => e.header).toList(),
                            beforeColor: Colors.grey,
                            currentColor: Colors.purple,
                            afterColor:Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (!ScreenSize.of(context).isSmall) const Gap(47),
          Expanded(
            child: Column(
              children: [
                if (!ScreenSize.of(context).isSmall) ...[
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  const Gap(47),
                ],
                Expanded(child: currentPage.content),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildActionButtons(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepperPage {
  /// Creates a [StepperPage].
  ///
  /// [header] is required and represents the title of this stepper page.
  ///
  /// [content] is required and typically holds the main widget or information
  /// for this stepper page.
  ///
  /// [action] is required and should contain a list of [StepperActions]s
  /// that are
  /// allowed on this page. The actions cannot
  /// contain both [StepperActions.next]
  /// and [StepperActions.submit], and each action must be unique.
  /// [onSubmitted] is an optional callback that is invoked when the page
  /// action is a submission action.
  ///
  /// [hasBackButton] determines whether the back button is visible and
  /// enabled on this stepper page. By default, it is set to `true`, meaning
  /// the back button will be shown and can be used to navigate to the previous
  /// step. If set to `false`, the back button will not be displayed, preventing
  /// navigation to the previous step from this page.
  StepperPage({
    required this.header,
    required this.content,
    required List<StepperActions> action,
    this.onSubmitted,
    this.hasBackButton = true,
  }) : action = _validateActions(action);

  final String header;
  final Widget content;
  final List<StepperActions> action;
  final VoidCallback? onSubmitted;
  final bool hasBackButton;

  static List<StepperActions> _validateActions(List<StepperActions> actions) {
    // Ensuring that SAction.next and SAction.submit are not both present
    final containsNext = actions.contains(StepperActions.next);
    final containsSubmit = actions.contains(StepperActions.submit);
    if (containsNext && containsSubmit) {
      throw ArgumentError(
          'Action list cannot contain both SAction.next and SAction.submit. '
              'Choose one.');
    }
    // Checking for duplicated actions

    final actionSet = <StepperActions>{};
    for (final action in actions) {
      if (!actionSet.add(action)) {
        throw ArgumentError('Duplicate action detected: $action.'
            ' Each action must be unique.');
      }
    }
    return actions;
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    required this.color,
    required this.width,
    super.key,
    this.height = 6,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  const StepWidget({
    required this.index,
    required this.width,
    required this.currentStep,
    required this.stepLabels,
    super.key,
    this.beforeColor,
    this.currentColor,
    this.afterColor,
  });

  final int index;
  final double width;
  final double currentStep;
  final List<String> stepLabels;
  final Color? beforeColor;
  final Color? currentColor;
  final Color? afterColor;

  Steps get _stepState {
    if (index < currentStep) return Steps.before;
    if (index == currentStep) return Steps.current;
    return Steps.after;
  }

  TextStyle _stepTextStyle(BuildContext context, Steps stepState) {
    Color textColor;
    switch (stepState) {
      case Steps.before:
        textColor = Colors.black;
        break;
      case Steps.current:
        textColor = Colors.red;
        break;
      case Steps.after:
        textColor = Colors.purple;
        break;
    }
    return TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,  // Optional: add text styling as needed
      fontSize: 16,  // Optional: specify the font size
    );
  }


  @override
  Widget build(BuildContext context) {
    Color containerColor;

    switch (_stepState) {
      case Steps.before:
        containerColor = beforeColor ?? Colors.blueGrey;

      case Steps.current:
        containerColor = currentColor ?? Colors.purple;

      case Steps.after:
        containerColor = afterColor ?? Colors.blue;
    }

    return SizedBox(
      width: width,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!ScreenSize.of(context).isSmall)
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                stepLabels[index],
                style: _stepTextStyle(context, _stepState),
              ),
            ),
          Positioned(
            top: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: containerColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
