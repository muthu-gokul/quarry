import 'package:intl/intl.dart';

class InvoiceReportGridModel {
  InvoiceReportGridModel({
    this.plantId,
    this.plantName,
    this.invoiceId,
    this.invoiceNumber,
    this.invoiceType,
    this.invoiceDate,
    this.partyId,
    this.partyName,
    this.grandTotalAmount,
    this.invoicePaymentMappingId,
    this.paidOrReceivedAmount,
    this.paymentStatus,
    this.paymentCategoryId,
    this.paymentCategoryName,
  });

  int plantId;
  String plantName;
  int invoiceId;
  int invoiceNumber;
  String invoiceType;
  DateTime invoiceDate;
  int partyId;
  String partyName;
  double grandTotalAmount;
  int invoicePaymentMappingId;
  double paidOrReceivedAmount;
  String paymentStatus;
  int paymentCategoryId;
  String paymentCategoryName;

  factory InvoiceReportGridModel.fromJson(Map<String, dynamic> json) => InvoiceReportGridModel(
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    invoiceId: json["InvoiceId"],
    invoiceNumber: json["InvoiceNumber"],
    invoiceType: json["InvoiceType"],
    invoiceDate: DateTime.parse(json["InvoiceDate"]),
    partyId: json["PartyId"],
    partyName: json["PartyName"],
    grandTotalAmount: json["GrandTotalAmount"],
    invoicePaymentMappingId: json["InvoicePaymentMappingId"],
    paidOrReceivedAmount: json["PaidOrReceivedAmount"],
    paymentStatus: json["PaymentStatus"],
    paymentCategoryId: json["PaymentCategoryId"],
    paymentCategoryName: json["PaymentCategoryName"],
  );

  Map<String, dynamic> toGridJson() => {
    "Invoice Number": invoiceNumber,
    "Date": invoiceDate!=null?DateFormat("dd-MM-yyyy").format(invoiceDate):" ",
    "Invoice Type": invoiceType,
    "Party Name": partyName,
    "Gross Amount": grandTotalAmount,
    "Paid/ReceivedAmount": paidOrReceivedAmount,
    "Payment Status": paymentStatus,
    "Payment Type": paymentCategoryName,
    "Plant Name": plantName,
  };

  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
