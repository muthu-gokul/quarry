class PaymentStatus {
  PaymentStatus({
    this.paymentStatus,
    this.isActive,
  });

  String paymentStatus;
  bool isActive;
  factory PaymentStatus.fromJson(Map<String, dynamic> json) => PaymentStatus(
    paymentStatus: json["PaymentStatus"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "PaymentStatus": paymentStatus,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}