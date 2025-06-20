int convertISODateStringToUnixTimestampInSeconds(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  return ((dateTime.millisecondsSinceEpoch) / 1000).floor();
}

DateTime convertUnixTimeStampToDatetime(int unixTimestampInSecond) {
  // Convert to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestampInSecond * 1000);
  return dateTime;
}

bool isNullOrBlank(String? value) {
  return value == null || value.trim().isEmpty;
}
