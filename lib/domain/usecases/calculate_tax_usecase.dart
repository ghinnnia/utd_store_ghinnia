class CalculateTaxUseCase {
  final int twoDigitLast = 46;
  final int loopCount = 46 * 10000000;

  int executeHeavyLoop() {
    int result = 0;
    for (int i = 0; i < loopCount; i++) {
      result += i;
    }
    return result;
  }
}
// calculatenya