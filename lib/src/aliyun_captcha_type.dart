enum AliyunCaptchaType {
  slide,
  smart,
}

extension AliyunCaptchaTypeParseToString on AliyunCaptchaType {
  String get name {
    return this.toString().split('.').last;
  }

  String? toValue() {
    if (this == AliyunCaptchaType.slide) {
      return 'nc';
    } else if (this == AliyunCaptchaType.smart) {
      return 'ic';
    }
    return null;
  }
}
