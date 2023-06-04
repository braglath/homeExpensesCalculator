extension ConversionsOnInt on int {
  int get to10Percent => (this * (10 / 100)).toInt();
  int get to15Percent => (this * (15 / 100)).toInt();
  int get to20Percent => (this * (20 / 100)).toInt();
}
