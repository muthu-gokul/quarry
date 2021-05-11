import 'package:intl/intl.dart';

class CustomerSaleGridModel {
  CustomerSaleGridModel({
    this.customerId,
    this.plantId,
    this.plantName,
    this.date,
    this.saleNumber,
    this.customerName,
    this.location,
    this.contactNumber,
    this.vehicleNumber,
    this.materialId,
    this.materialName,
    this.quantity,
    this.amount,
    this.paymentCategoryId,
    this.paymentType,
  });

  int customerId;
  int plantId;
  String plantName;
  DateTime date;
  int saleNumber;
  String customerName;
  String location;
  String contactNumber;
  String vehicleNumber;
  int materialId;
  String materialName;
  double quantity;
  double amount;
  int paymentCategoryId;
  String paymentType;

  factory CustomerSaleGridModel.fromJson(Map<String, dynamic> json) => CustomerSaleGridModel(
    customerId: json["CustomerId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    date: DateTime.parse(json["CreatedDate"]),
    saleNumber: json["SaleNumber"],
    customerName: json["CustomerName"],
    location: json["Location"],
    contactNumber: json["CustomerContactNumber"],
    vehicleNumber: json["VehicleNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    quantity: json["Quantity"],
    amount: json["Amount"],
    paymentCategoryId: json["PaymentCategoryId"],
    paymentType: json["PaymentCategoryName"],
  );

  Map<String, dynamic> toGridJson() => {
    "CustomerId": customerId,
    "PlantId": plantId,
    "Plant Name": plantName,
    "Date": date!=null?DateFormat("dd-MM-yyyy").format(date):" ",
    "Sale Number": saleNumber,
    "Customer Name": customerName,
    "Location": location,
    "Contact Number": contactNumber,
    "Vehicle Number": vehicleNumber,
    "MaterialId": materialId,
    "Material Name": materialName,
    "Quantity": quantity,
    "Amount": amount,
    "PaymentCategoryId": paymentCategoryId,
    "Payment Type": paymentType,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
