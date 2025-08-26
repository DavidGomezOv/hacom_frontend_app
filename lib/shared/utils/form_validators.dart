class FormValidators {
  static String? commonValidator(
    String? value,
    String emptyErrorMessage, {
    int? minLength,
    String? minLengthErrorMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyErrorMessage;
    }
    if (minLength != null && value.length < minLength) {
      return minLengthErrorMessage;
    }
    return null;
  }
}
