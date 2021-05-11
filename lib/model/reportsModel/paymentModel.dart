class PaymentModel {
  PaymentModel({
    this.paymentCategoryId,
    this.paymentType,
    this.isActive,
  });

  int paymentCategoryId;
  String paymentType;
  bool isActive;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    paymentCategoryId: json["PaymentCategoryId"],
    paymentType: json["PaymentType"],
      isActive:true
  );

  Map<String, dynamic> toGridJson() => {
    "PaymentCategoryId": paymentCategoryId,
    "PaymentType": paymentType,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
