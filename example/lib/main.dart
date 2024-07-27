import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_form/stepper_form.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyStepperFormWidget(),
    );
  }
}




class MyStepperFormWidget extends StatelessWidget {
  const MyStepperFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Form Demo'),
      ),
      body: StepperForm(
        pages: [
          StepperPage(
            header: 'Step 1',
            content: Text('Content for Step 1'),
            action: [StepperActions.next],
          ),
          StepperPage(
            header: 'Step 2',
            content: Text('Content for Step 2'),
            action: [StepperActions.previous, StepperActions.submit],
          ),
        ],
      ),
    );
  }
}

