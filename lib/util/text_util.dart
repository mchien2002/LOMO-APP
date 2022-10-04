String getSubContent(String content, int length) {
  final index = getIndex(content, length);
  if (index != -1) {
    return content.substring(0, index) + " ...";
  } else {
    return content.substring(0, length) + " ...";
  }
}

int getIndex(String content, length) {
  final index = content.indexOf(" ", length);
  if (index != -1) return index;
  if (index == -1 && length < content.length) {
    return getIndex(content, length + 1);
  }
  return -1;
}
