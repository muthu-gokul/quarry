import 'package:intl/intl.dart';

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
    this.supplierName
  });

  int dieselPurchaseId;
  String billNumber;
  int employeeId;
  String purchaserName;
  String supplierName;
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
    supplierName: json["SupplierName"],
    dieselBunkLocation: json["DieselBunkLocation"],
    dieselBunkContactNumber: json["DieselBunkContactNumber"],
    dieselQuantity: json["DieselQuantity"],
    dieselRate: json["DieselRate"],
    totalAmount: json["TotalAmount"],
    billDate:json["BillDate"]!=null? DateTime.parse(json["BillDate"]):null,
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

  Map<String, dynamic> toGridJson() => {
    "DieselPurchaseId": dieselPurchaseId,
    "Bill Number": billNumber,
    "EmployeeId": employeeId,
    "Purchaser Name": purchaserName,
    "Supplier Name": supplierName,
    "Location": dieselBunkLocation,
    "Contact Number": dieselBunkContactNumber,
    "Quantity": dieselQuantity,
    "Diesel Price": dieselRate,
    "Total Price": totalAmount,
    "Date": billDate!=null?DateFormat.yMMMd().format(billDate):" ",
  };

  dynamic get(String propertyName) {

    var _mapRep = toGridJson();

    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found $propertyName');
  }

}
