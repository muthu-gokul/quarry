class EmpLoanAmountTypeModel {
  EmpLoanAmountTypeModel({
    this.amountType,
  });

  String? amountType;

  factory EmpLoanAmountTypeModel.fromJson(Map<String, dynamic> json) => EmpLoanAmountTypeModel(
    amountType: json["AmountType"],
  );

  Map<String, dynamic> toGridJson() => {
    "AmountType": amountType,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
