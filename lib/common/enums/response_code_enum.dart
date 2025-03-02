enum ResponseCodeEnum {
  success(code: 0, desc: "成功"),
  needLogin(code: -5, desc: "需要登录"),
  tokenExpireCode(code: -6, desc: "token过期"),
  fail(code: -1, desc: "请求失败"),
  eventHasExpired(code: 20051, desc: '活动已过期'),
  insufficientBalance(code: 30028, desc: "赏金-开启状态时用户账户金额不足提示码");

  final int code;
  final String desc;

  const ResponseCodeEnum({required this.code, required this.desc});
}
