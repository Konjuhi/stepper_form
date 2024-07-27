import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepperState {
  StepperState({this.currentStep = 0, this.stepData = const {}});

  final int currentStep;
  final Map<int, dynamic> stepData;

  StepperState copyWith({int? currentStep, Map<int, dynamic>? stepData}) {
    return StepperState(
      currentStep: currentStep ?? this.currentStep,
      stepData: stepData ?? this.stepData,
    );
  }
}

class StepperNotifier extends StateNotifier<StepperState> {
  StepperNotifier() : super(StepperState());

  void setCurrentStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void saveState(int step, dynamic data) {
    final newStepData = Map<int, dynamic>.from(state.stepData)..[step] = data;
    state = state.copyWith(stepData: newStepData);
    if (kDebugMode) {
      print('Draft saved for step $step: $data');
    }
  }

  void reset() {
    state = StepperState();
  }
}

final stepperProvider =
StateNotifierProvider<StepperNotifier, StepperState>((ref) {
  return StepperNotifier();
});
