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
}