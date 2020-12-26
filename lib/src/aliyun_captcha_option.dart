// https://help.aliyun.com/document_detail/121898.html

class AliyunCaptchaOption {
  String appKey;
  String scene;
  String language;
  int width;
  int height;
  int fontSize;
  bool hideErrorCode;
  Map<String, dynamic> upLang;
  dynamic test;

  AliyunCaptchaOption({
    this.appKey,
    this.scene,
    this.language,
    this.width,
    this.height,
    this.fontSize,
    this.hideErrorCode,
    this.upLang,
    this.test,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonObject = Map<String, dynamic>();
    if (appKey != null) jsonObject.putIfAbsent("appkey", () => appKey);
    if (scene != null) jsonObject.putIfAbsent("scene", () => scene);
    if (language != null) jsonObject.putIfAbsent("language", () => language);
    if (width != null) jsonObject.putIfAbsent("width", () => width);
    if (height != null) jsonObject.putIfAbsent("height", () => height);
    if (fontSize != null) jsonObject.putIfAbsent("fontSize", () => fontSize);
    if (hideErrorCode != null)
      jsonObject.putIfAbsent("hideErrorCode", () => hideErrorCode);
    if (upLang != null) jsonObject.putIfAbsent("upLang", () => upLang);
    if (test != null) jsonObject.putIfAbsent("test", () => test);

    return jsonObject;
  }
}
