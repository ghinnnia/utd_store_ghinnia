class GetSplashDelayUseCase {
  final String nim = '20123046';
  final int lastDigit = 6;

  int execute() {
    if (lastDigit == 0) return 5;
    return lastDigit;
  }
}