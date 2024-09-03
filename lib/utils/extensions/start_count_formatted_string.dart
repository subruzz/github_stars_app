/// Extension on [int] for formatting star counts.
/// 
/// Adds the [formattedStars] getter to convert integer star counts into a
/// more readable format with "k" for thousands and "M" for millions.
/// 
/// Example:
/// ```dart
/// int starCount = 12345;
/// print(starCount.formattedStars); // Output: "12.3k"
/// ```
/// - Numbers from 1,000 to less than 1,000,000 are formatted with "k".
/// - Numbers 1,000,000 or more are formatted with "M".
/// - Numbers below 1,000 are shown as-is.
extension StarCountExtension on int {
  String get formattedStars {
    if (this >= 1000 && this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else {
      return toString();
    }
  }
}
