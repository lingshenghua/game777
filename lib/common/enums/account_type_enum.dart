enum AccountTypeEnum {
  phone('PHONE'),
  email('EMAIL'),
  password('PASSWORD'),
  smsCode('SMSCODE'),
  underlineSmsCode('UNDERLINE_SMSCODE');

  final String value;

  const AccountTypeEnum(this.value);
}
