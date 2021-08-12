import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class PaymentMappingModel{


  int? InvoicePaymentMappingId;
  int? InvoiceId;

  int? PartyId;
  int? PaymentCategoryId;
  String? PaymentCategoryName;
  double? Amount;
  String? Comment;
  int? IsActive;
  AnimationController? scaleController;
  bool? isEdit;
  bool? isDelete;
  DateTime? createdDate;

/*  guestNoController=AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  scaleAnimation = new Tween(begin: 0.0, end: 1.0)
      .animate(new CurvedAnimation(parent: guestNoController, curve: Curves.easeInOutBack));*/


  PaymentMappingModel({
    this.InvoicePaymentMappingId,
    this.InvoiceId,
    this.PaymentCategoryId,
    this.PaymentCategoryName,
    this.Amount,

    this.PartyId,
    this.createdDate,
    this.scaleController,
    this.Comment,
    this.IsActive,
    this.isEdit,
    this.isDelete

  });







  factory PaymentMappingModel.fromJson(Map<String, dynamic> json,TickerProviderStateMixin tickerProviderStateMixin) => PaymentMappingModel(
      InvoicePaymentMappingId: json["InvoicePaymentMappingId"],
      InvoiceId: json["InvoiceId"],
      PaymentCategoryId: json["PaymentCategoryId"],
      PaymentCategoryName: json["PaymentCategoryName"],
      Amount: json["PaidAmount"],
      PartyId:  json["PartyId"],
      Comment: json["Comment"],
      createdDate: DateTime.parse(json["CreatedDate"]),
      IsActive: json["IsActive"],
      scaleController: AnimationController(duration: Duration(milliseconds: 300,),vsync: tickerProviderStateMixin),
      isEdit: true,
      isDelete: false
  );

  Map<String, dynamic> toJson() => {
    "InvoicePaymentMappingId": InvoicePaymentMappingId,
    "InvoiceId": InvoiceId,
    "PartyId": PartyId,
    "PaymentCategoryId": PaymentCategoryId,
    "Amount": Amount,
    "Comment": Comment,
    "IsActive": IsActive,
    "CreatedDate": createdDate!.toIso8601String(),



  };
}