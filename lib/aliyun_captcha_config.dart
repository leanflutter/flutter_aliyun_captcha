// https://help.aliyun.com/document_detail/121898.html

class AliyunCaptchaConfig {
  String appKey;
  String scene;
  String token;
  int isOpt;
  String language;
  int timeout;
  int retryTimes;
  int errorTimes;
  bool bannerHidden;
  bool initHidden;
  Map<String, dynamic> apimap;

  AliyunCaptchaConfig({
    this.appKey,
    this.scene,
    this.token,
    this.isOpt,
    this.language,
    this.timeout,
    this.retryTimes,
    this.errorTimes,
    this.bannerHidden,
    this.initHidden,
    this.apimap,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonObject = Map<String, dynamic>();
    if (appKey != null) jsonObject.putIfAbsent("appkey", () => appKey);
    if (scene != null) jsonObject.putIfAbsent("scene", () => scene);
    if (token != null) jsonObject.putIfAbsent("token", () => token);
    if (isOpt != null) jsonObject.putIfAbsent("is_Opt", () => isOpt);
    if (language != null) jsonObject.putIfAbsent("language", () => language);
    if (timeout != null) jsonObject.putIfAbsent("timeout", () => timeout);
    if (retryTimes != null)
      jsonObject.putIfAbsent("retryTimes", () => retryTimes);
    if (errorTimes != null)
      jsonObject.putIfAbsent("errorTimes", () => errorTimes);
    if (bannerHidden != null)
      jsonObject.putIfAbsent("bannerHidden", () => bannerHidden);
    if (initHidden != null)
      jsonObject.putIfAbsent("initHidden", () => initHidden);
    if (apimap != null) jsonObject.putIfAbsent("apimap", () => apimap);

    return jsonObject;
  }
}
