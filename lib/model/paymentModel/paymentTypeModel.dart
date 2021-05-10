class PaymentTypeModel {
  PaymentTypeModel({
    this.paymentCategoryId,
    this.paymentCategoryName,
  });

  int paymentCategoryId;
  String paymentCategoryName;

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) => PaymentTypeModel(
    paymentCategoryId: json["PaymentCategoryId"],
    paymentCategoryName: json["PaymentCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "PaymentCategoryId": paymentCategoryId,
    "PaymentCategoryName": paymentCategoryName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}