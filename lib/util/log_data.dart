void logPrint(Object object) async {
  int defaultPrintLength = 1020;
  if (object.toString().length <= defaultPrintLength) {
    print(object);
  } else {
    print(
        "===================================================================================================");
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(object.toString())
        .forEach((match) => print(match.group(0)));
    print(
        "===================================================================================================");
  }
}
