class DieselPurchaseGridModel {
  DieselPurchaseGridModel({
    this.dieselPurchaseId,
    this.billNumber,
    this.employeeId,
    this.purchaserName,
    this.dieselBunkLocation,
    this.dieselBunkContactNumber,
    this.dieselQuantity,
    this.dieselRate,
    this.totalAmount,
    this.billDate,
  });

  int dieselPurchaseId;
  String billNumber;
  int employeeId;
  String purchaserName;
  String dieselBunkLocation;
  String dieselBunkContactNumber;
  double dieselQuantity;
  double dieselRate;
  double totalAmount;
  DateTime billDate;

  factory DieselPurchaseGridModel.fromJson(Map<String, dynamic> json) => DieselPurchaseGridModel(
    dieselPurchaseId: json["DieselPurchaseId"],
    billNumber: json["BillNumber"],
    employeeId: json["EmployeeId"],
    purchaserName: json["PurchaserName"],
    dieselBunkLocation: json["DieselBunkLocation"],
    dieselBunkContactNumber: json["DieselBunkContactNumber"],
    dieselQuantity: json["DieselQuantity"],
    dieselRate: json["DieselRate"],
    totalAmount: json["TotalAmount"],
    billDate: DateTime.parse(json["BillDate"]),
  );

  Map<String, dynamic> toJson() => {
    "DieselPurchaseId": dieselPurchaseId,
    "BillNumber": billNumber,
    "EmployeeId": employeeId,
    "PurchaserName": purchaserName,
    "DieselBunkLocation": dieselBunkLocation,
    "DieselBunkContactNumber": dieselBunkContactNumber,
    "DieselQuantity": dieselQuantity,
    "DieselRate": dieselRate,
    "TotalAmount": totalAmount,
    "BillDate": billDate.toIso8601String(),
  };
}
