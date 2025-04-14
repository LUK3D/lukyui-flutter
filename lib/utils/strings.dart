/// Ellipse text if it is too long
String ellipseText(String text, {int maxLength = 20}) {
  if (text.length > maxLength) {
    return '${text.substring(0, maxLength)}...';
  }
  return text;
}
