/// Returns the ordinal label for a 1-based priority
/// (1 -> "1st", 2 -> "2nd", 3 -> "3rd", 4 -> "4th", 21 -> "21st"...).
String ordinal(int n) {
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 13) return '${n}th';
  return switch (n % 10) {
    1 => '${n}st',
    2 => '${n}nd',
    3 => '${n}rd',
    _ => '${n}th',
  };
}
