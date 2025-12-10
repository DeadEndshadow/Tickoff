/// Flutter test configuration
/// 
/// This file configures the test runner behavior for the TickOff app
import 'dart:async';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Set up any global test configuration here
  
  // Run the tests
  await testMain();
  
  // Clean up after tests
}
