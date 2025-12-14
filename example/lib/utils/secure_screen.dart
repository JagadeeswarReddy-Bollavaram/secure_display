/// Base utilities for bank operations
class ScreenProtector {
  /// Returns a greeting message
  static String getGreeting() {
    return 'Hello from Screen Protector!';
  }

  /// Example utility function
  static String formatAccountNumber(String accountNumber) {
    if (accountNumber.length < 4) {
      return accountNumber;
    }
    // Mask all but last 4 digits
    final masked = '*' * (accountNumber.length - 4);
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return '$masked$lastFour';
  }
}
