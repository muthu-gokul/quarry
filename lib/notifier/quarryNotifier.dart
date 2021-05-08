import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quarry/api/ApiManager.dart';
import 'package:quarry/api/sp.dart';
import 'package:quarry/model/customerDetailsModel.dart';
import 'package:quarry/model/dropDownValues.dart';
import 'package:quarry/model/materialDetailGridModel.dart';
import 'package:quarry/model/materialProcessModel.dart';
import 'package:quarry/model/plantDetailsModel/plantGridModel.dart';
import 'package:quarry/model/plantDetailsModel/plantLicenseModel.dart';
import 'package:quarry/model/plantDetailsModel/plantTypeModel.dart';
import 'package:quarry/model/quarryLocModel.dart';
import 'package:quarry/model/saleModel.dart';
import 'package:quarry/model/vendorModel.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/calculation.dart';
import 'package:quarry/widgets/decimal.dart';
import 'package:quarry/widgets/printerService/printer/enums.dart';
import 'package:quarry/widgets/printerService/printer/network_printer.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/capability_profile.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/enums.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/pos_column.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/pos_styles.dart';

import '../widgets/decimal.dart';

class QuarryNotifier extends ChangeNotifier{

  bool isNavDrawerOpen=false;
  void updateNavDrawer(bool value){
    isNavDrawerOpen=value;
    notifyListeners();
  }


  List<String> navMenu=['Quarry Location','Vendor','Material Processed','Sale'];
  int navMenuSelected=0;
  void updateNavMenuSelected(int value){
    navMenuSelected=value;
    notifyListeners();
  }




  double position=0;
  int QLSelectedTab=0;
  void updateOLSelectedTab(int value){
    QLSelectedTab=value;
    if(value==0){
      position=0;
    }else if(value==1){
      position=SizeConfig.width100;
    }else if(value==2){
      position=((SizeConfig.width90)*2)+SizeConfig.width20;
    }
    notifyListeners();
  }


  PageController QLAddnewController=new PageController();
  void updatePageViewController(int index){
    this.QLAddnewController.animateToPage(index,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
    notifyListeners();
  }

  bool isQLOCPaymentOpen=false;
  void updateQLOCPayment(bool value){
    isQLOCPaymentOpen=value;
    notifyListeners();
  }

  List<int> paymentListSelected=[];
  List<String> paymentList=["Cash","Card","Credit"];


  List<int> materialsSelected=[];
  List<String> materialsList=["Big Rock","Small Rock","Granite","M-Sand","P-Sand"];
  bool isQLMaterialsOpen=false;
  void updateQLMaterials(bool value){
    isQLMaterialsOpen=value;
    notifyListeners();
  }


  TextEditingController quarryname=new TextEditingController();
  TextEditingController location=new TextEditingController();
  TextEditingController quarryInCharge=new TextEditingController();
  TextEditingController contactNo=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController quarrySize=new TextEditingController();
  String selectedGateNo;


  List<String> quarryLocGridCol=["Quarry Name","Location","In-Charge","Contact No","Email Id","No.of Gates","Quarry Size"];
  List<QuarryLocModel> quarryLocGridList=[
    QuarryLocModel(
      quarryname: "Rhinos Sand",
      location: "Hosur",
      quarryInCharge: "Bala",
      contactNo: "9876543211",
      email: "bala@gmail.com",
      noOfGates: "6",
      quarrySize: "5 Acre",
    ),    QuarryLocModel(
      quarryname: "Maharaja Quarry",
      location: "Chennai",
      quarryInCharge: "Vijay",
      contactNo: "9876543211",
      email: "vijay@gmail.com",
      noOfGates: "3",
      quarrySize: "10 Acre",
    ), QuarryLocModel(
      quarryname: "Blue Art Quarry",
      location: "Chennai",
      quarryInCharge: "Babu",
      contactNo: "9876543211",
      email: "babu@gmail.com",
      noOfGates: "4",
      quarrySize: "7 Acre",
    ), QuarryLocModel(
      quarryname: "Black Stone Quarry",
      location: "Chennai",
      quarryInCharge: "Babu",
      contactNo: "9876543211",
      email: "babu@gmail.com",
      noOfGates: "4",
      quarrySize: "7 Acre",
    ),
  ];

  void addQLList(){
    if(quarryname.text.isNotEmpty||location.text.isNotEmpty||quarryInCharge.text.isNotEmpty||contactNo.text.isNotEmpty|| email.text.isNotEmpty||quarrySize.text.isNotEmpty) {
      quarryLocGridList.add(QuarryLocModel(
          quarryname: quarryname.text,
          location: location.text,
          quarryInCharge: quarryInCharge.text,
          contactNo: contactNo.text,
          email: email.text,
          noOfGates: selectedGateNo,
          quarrySize: quarrySize.text
      ));
    }
    quarryname.clear();
    location.clear();
    quarryInCharge.clear();
    contactNo.clear();
    email.clear();
    quarrySize.clear();
    notifyListeners();

    updateOLSelectedTab(0);
    updatePageViewController(0);

  }





/*----------------------VENDOR ----------------------*/
  bool isVendorAddNewOpen=false;
  bool isVendorAddNewHW=false;
  void updateQVendorAddNew(bool value){
    isVendorAddNewOpen=value;
    notifyListeners();
  }
  void updateVendorAddNewHW(bool value){
    isVendorAddNewHW=value;
    notifyListeners();
  }


  double Vendorposition=0;
  int VendorSelectedTab=0;

  void updateVendorSelectedTab(int value){
    VendorSelectedTab=value;
    if(value==0){
      Vendorposition=0;
    }else if(value==1){
      Vendorposition=SizeConfig.width100;
    }else if(value==2){
      Vendorposition=((SizeConfig.width90)*2)+SizeConfig.width20;
    }
    notifyListeners();
  }


  PageController VendorAddnewController=new PageController();
  void updateVendorPageViewController(int index){
    this.VendorAddnewController.animateToPage(index,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
    notifyListeners();
  }

  TextEditingController vendorName=new TextEditingController();
  TextEditingController vendorId=new TextEditingController();
  TextEditingController vendorlocation=new TextEditingController();
  TextEditingController vendorPaymentTerms=new TextEditingController();
  TextEditingController vendorContactNo=new TextEditingController();

  List<String> vendorGridCol=["Vendor Name","Vendor Id","Contact No","Location","Payment Terms","Material Count"];
  List<VendorModel> vendorGridList=[
    VendorModel(
      vendorName: "Muthu",
      vendorId: "1567",
      vendorlocation: "Theni",
      vendorContactNo: "987676467",
      paymentTerms: "3",
      materialCount: 4
    ),   VendorModel(
      vendorName: "Gokul",
      vendorId: "15877",
      vendorlocation: "Bangalore",
      vendorContactNo: "987676467",
      paymentTerms: "2",
      materialCount: 10
    ), VendorModel(
      vendorName: "Rajesh",
      vendorId: "1589",
      vendorlocation: "Chennai",
      vendorContactNo: "987676467",
      paymentTerms: "2",
      materialCount: 4
    ), VendorModel(
      vendorName: "Ramesh",
      vendorId: "1587",
      vendorlocation: "Chennai",
      vendorContactNo: "987676467",
      paymentTerms: "2",
      materialCount: 2
    ),
  ];

  void addVendorGrid(){
    vendorGridList.add(VendorModel(
      vendorName: vendorName.text,
      vendorId: vendorId.text,
      vendorlocation: vendorlocation.text,
      vendorContactNo: vendorContactNo.text,
      paymentTerms: vendorPaymentTerms.text,
      materialCount: materialsSelected.length
    ));

    vendorName.clear();
    vendorId.clear();
    vendorlocation.clear();
    vendorPaymentTerms.clear();
    vendorContactNo.clear();
    materialsSelected.clear();
    updateQVendorAddNew(false);
    updateVendorAddNewHW(false);
    updateVendorSelectedTab(0);



  }



/*---------------------PROCESS----------------------*/
  bool isProcessAddNewOpen=false;
  bool isProcessAddNewHW=false;
  void updateProcessAddNew(bool value){
    isProcessAddNewOpen=value;
    notifyListeners();
  }
  void updateProcessAddNewHW(bool value){
    isProcessAddNewHW=value;
    notifyListeners();
  }


  bool isProcessStoneOpen=false;
  void updateProcessStoneOpen(bool value){
    isProcessStoneOpen=value;
    notifyListeners();
  }


  int stoneSelected;
  void updateStoneSelected(int value){
    stoneSelected=value;
    updateProcessStoneOpen(false);
    notifyListeners();
  }
  List<String> processStoneList=["Red Stone","Black Stone","Big Rock","Small Rock"];



  bool isProcessMaterialOpen=false;
  void updateProcessMaterialOpen(bool value){
    isProcessMaterialOpen=value;
    notifyListeners();
  }


  int MaterialSelected;
  void updateMaterialSelected(int value){
    MaterialSelected=value;
    updateProcessMaterialOpen(false);
    notifyListeners();
  }
  List<String> processMaterialList=["M-Sand","P-Sand","Red Stone Chips","Black Stone Chips","Big Rock Chips","Small Rock Chips"];


  List<MaterialProcessModel> materialProcessGridList=[
    MaterialProcessModel(
      stone: "Red Stone",
      materialProcessed: "Red Sand",
      weight: "4554 kg",
      wastage: "500 kg"
    ),    MaterialProcessModel(
      stone: "Black Stone",
      materialProcessed: "Black Sand",
      weight: "5000 kg",
      wastage: "600 kg"
    ),  MaterialProcessModel(
      stone: "Big Rock",
      materialProcessed: "Black Sand",
      weight: "1000 kg",
      wastage: "100 kg"
    ),
  ];


  TextEditingController processWeight=new TextEditingController();
  TextEditingController processWastage=new TextEditingController();

  void addmaterialProcessGridList(){
    if(stoneSelected!=null||MaterialSelected!=null) {
      materialProcessGridList.add(MaterialProcessModel(
          stone: processStoneList[stoneSelected],
          materialProcessed: processMaterialList[MaterialSelected],
          weight: processWeight.text,
          wastage: processWastage.text
      ));
    }

    stoneSelected=null;
    MaterialSelected=null;
    processWeight.clear();
    processWastage.clear();
    updateProcessAddNew(false);
    updateProcessAddNewHW(false);

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    notifyListeners();

  }

/*---------------------SALE----------------------*/
  bool isSaleAddNewOpen=false;
  bool isSaleAddNewHW=false;
  void updateSaleAddNew(bool value){
    isSaleAddNewOpen=value;
    notifyListeners();
  }
  void updateSaleAddNewHW(bool value){
    isSaleAddNewHW=value;
    notifyListeners();
  }

  TextEditingController salePrice=new TextEditingController();
  TextEditingController saleWeight=new TextEditingController();

  List<SaleModel> saleGridList=[
    SaleModel(
      material: "M-Sand",
      weight: "1000 kg",
      price: "25000"
    ),  SaleModel(
      material: "P-Sand",
      weight: "1000 kg",
      price: "30000"
    ),  SaleModel(
      material: "Red Stone Chips",
      weight: "1000 kg",
      price: "15000"
    ),
  ];
  List<String> saleGridCol=["Material","Weight","Price"];

  void addSaleGridList(){
    if(MaterialSelected!=null || saleWeight.text.isNotEmpty || salePrice.text.isNotEmpty){
      saleGridList.add(SaleModel(
        material: processMaterialList[MaterialSelected],
        weight: saleWeight.text,
        price: salePrice.text
      ));
    }

    MaterialSelected=null;
    saleWeight.clear();
    salePrice.clear();
    updateSaleAddNew(false);
    updateSaleAddNewHW(false);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    notifyListeners();

  }

  ///****************************************************       DB HIT        ****************************************************************/

  int UserId;
  String Name;
  String DataBaseName;




  List<TaxDetails> material_TaxList=[];
  List<UnitDetails> material_UnitsList=[];

  initUserDetail(int userid,String name, String dbname,BuildContext context){
    UserId=userid;
    Name=name;
    DataBaseName=dbname;
    //DataBaseName="TetroPOS_QMS";
    print(UserId);
    print(Name);
    print(DataBaseName);
/*    initDropDownValues(context);*/
  }

  final call=ApiManager();
  initDropDownValues(BuildContext context) async {
    print("FFF");
    updatedropDownLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.dropDownValues}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        var parsed=json.decode(value);
        var t=parsed['Table'] as List;
        var t1=parsed['Table1'] as List;
        var t2=parsed['Table2'] as List;
        var t3=parsed['Table3'] as List;
        var t4=parsed['Table4'] as List;
        var t5=parsed['Table5'] as List;
        var t6=parsed['Table6'] as List;
        var t7=parsed['Table7'] as List;
        var t8=parsed['Table8'] as List;
        var t10=parsed['Table10'] as List;

        vehicleList=t1.map((e) => VehicleType.fromJson(e)).toList();
        sale_materialList=t2.map((e) => MaterialTypelist.fromJson(e)).toList();
        sale_paymentList=t3.map((e) => PaymentType.fromJson(e)).toList();
        material_TaxList=t5.map((e) => TaxDetails.fromJson(e)).toList();
        material_UnitsList=t6.map((e) => UnitDetails.fromJson(e)).toList();

        updatedropDownLoader(false);
      });
    }
    catch(e){
      updatedropDownLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.dropDownValues}" , e.toString());
    }
  }

  ///****************************************************      Sale DETAIL   ****************************************************************/


  List<VehicleType> vehicleList=[];
  List<MaterialTypelist> sale_materialList=[];
  List<PaymentType> sale_paymentList=[];
  List<CustomerModel> sale_customerList=[];
  List<CustomerModel> filterSale_customerList=[];

  Future<dynamic> SalesDropDownValues(BuildContext context) async {
    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "Sale"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value":DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;
          var t2=parsed['Table2'] as List;
          var t3=parsed['Table3'] as List;


          vehicleList=t.map((e) => VehicleType.fromJson(e)).toList();
          sale_materialList=t1.map((e) => MaterialTypelist.fromJson(e)).toList();
          sale_paymentList=t2.map((e) => PaymentType.fromJson(e)).toList();
          sale_customerList=t3.map((e) => CustomerModel.fromJson(e)).toList();
          filterSale_customerList=t3.map((e) => CustomerModel.fromJson(e)).toList();


        }
        updateInsertSaleLoader(false);
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  searchCustomer(String value){
    if(value.isEmpty){
      filterSale_customerList=sale_customerList;
    }
    else{
      filterSale_customerList=sale_customerList.where((element) => element.customerName.toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();
  }

  TextEditingController SS_vehicleNo= new TextEditingController();
  int SS_selectedVehicleTypeId;
  String SS_selectedVehicleTypeName;
  TextEditingController SS_emptyVehicleWeight= new TextEditingController();
  int SS_selectedMaterialTypeId=null;
  String SS_selectedMaterialTypeName=null;
  TextEditingController SS_customerNeedWeight= new TextEditingController(text: "0");
  TextEditingController SS_amount= new TextEditingController(text: '0.00');
  int SS_selectedPaymentTypeId=null;
  String SS_selectedPaymentTypeString=null;
  int SS_selectedCustomerId=null;
  String SS_selectedCustomerName=null;
  bool isDiscount=false;
  bool isPercentageDiscount=true;
  bool isAmountDiscount=false;
  double DiscountValue=0.0;
  double DiscountAmount=0.0;
  double TaxAmount=0.0;
  double TaxValue=0.0;
  double DiscountedOutputQtyAmount=0.0;
  double OutputQtyAmount=0.0;
  double SubTotal=0.0;
  double DiscountedSubTotal=0.0;
  double GrandTotal=0.0;
  double RoundOffAmount=0.0;
  //Driver information
  TextEditingController driverName=new TextEditingController();
  TextEditingController driverContactNumber=new TextEditingController();
  TextEditingController driverBeta=new TextEditingController();

  bool isTax=false;
  updateIsTax(bool value){
    isTax=value;
    notifyListeners();
  }



  updateisDiscount(bool value){
    isDiscount=value;
    notifyListeners();
  }


  TextEditingController customPriceController = new TextEditingController();
  bool isCustomPrice=false;
  updateCustomPrice(bool value){
    isCustomPrice=value;
    notifyListeners();
  }
  String materialPrice;

  weightToAmount(){

    String taxValue;
    if(SS_selectedMaterialTypeId!=null){

      if(SS_customerNeedWeight.text.isEmpty){
        SS_amount.text="0.00";
      }
      else{
        if(isCustomPrice){
          if(customPriceController.text.isNotEmpty){
            materialPrice=customPriceController.text;
          }else{
            materialPrice="0.0";
          }
        }else{
          materialPrice=sale_materialList.where((element) => element.MaterialId==SS_selectedMaterialTypeId).toList()[0].MaterialUnitPrice.toString();
        }

        taxValue=sale_materialList.where((element) => element.MaterialId==SS_selectedMaterialTypeId).toList()[0].TaxValue.toString();

        if(isDiscount){
          if(isAmountDiscount){


            SubTotal=double.parse((Decimal.parse(SS_customerNeedWeight.text)*Decimal.parse((materialPrice))).toString());
            DiscountAmount=DiscountValue;
            DiscountedSubTotal=double.parse((Decimal.parse(SubTotal.toString())-Decimal.parse((DiscountAmount.toString()))).toString());
            TaxValue=double.parse(taxValue);
            if(!isTax){
              TaxAmount=0.0;
            }
            else{
              TaxAmount=double.parse(((Decimal.parse(taxValue)*Decimal.parse((DiscountedSubTotal.toString())))/Decimal.parse("100")).toString());
            }

            GrandTotal=double.parse((Decimal.parse(DiscountedSubTotal.toString())+Decimal.parse((TaxAmount.toString()))).toString());
            RoundOffAmount=double.parse((Decimal.parse(GrandTotal.round().toString())-Decimal.parse((GrandTotal.toString()))).toString());

            SS_amount.text=DiscountedSubTotal.toString();



          }
          else if(isPercentageDiscount){

            SubTotal=double.parse((Decimal.parse(SS_customerNeedWeight.text)*Decimal.parse((materialPrice))).toString());
            DiscountAmount=double.parse(((Decimal.parse(SubTotal.toString())*Decimal.parse((DiscountValue.toString())))/Decimal.parse("100")).toString());
            DiscountedSubTotal=double.parse((Decimal.parse(SubTotal.toString())-Decimal.parse((DiscountAmount.toString()))).toString());
            TaxValue=double.parse(taxValue);
            if(!isTax){
              TaxAmount=0.0;
            }
            else{
              TaxAmount=double.parse(((Decimal.parse(taxValue)*Decimal.parse((DiscountedSubTotal.toString())))/Decimal.parse("100")).toString());
            }

            GrandTotal=double.parse((Decimal.parse(DiscountedSubTotal.toString())+Decimal.parse((TaxAmount.toString()))).toString());
            RoundOffAmount=double.parse((Decimal.parse(GrandTotal.round().toString())-Decimal.parse((GrandTotal.toString()))).toString());

            SS_amount.text=DiscountedSubTotal.toString();
          }
        }
        else{
          DiscountAmount=0.0;
          DiscountValue=0.0;
          DiscountedSubTotal=0.0;

          SubTotal=double.parse((Decimal.parse(SS_customerNeedWeight.text)*Decimal.parse((materialPrice))).toString());
          TaxValue=double.parse(taxValue);
          if(!isTax){
            TaxAmount=0.0;
          }
          else{
            TaxAmount=double.parse(((Decimal.parse(taxValue)*Decimal.parse((SubTotal.toString())))/Decimal.parse("100")).toString());
          }

          GrandTotal=double.parse((Decimal.parse(SubTotal.toString())+Decimal.parse((TaxAmount.toString()))).toString());
          RoundOffAmount=double.parse((Decimal.parse(GrandTotal.round().toString())-Decimal.parse((GrandTotal.toString()))).toString());
          SS_amount.text=SubTotal.toString();
        }
        
       
      }


      notifyListeners();
    }
    print(SubTotal);
    print(TaxValue);
    print(TaxAmount);
    print(GrandTotal);
    print(RoundOffAmount);
  }


  amountToWeight(){
    String materialPrice;
    if(SS_selectedMaterialTypeId!=null){

      if(SS_amount.text.isEmpty){
        SS_customerNeedWeight.text="0";
      }else{
        materialPrice=sale_materialList.where((element) => element.MaterialId==SS_selectedMaterialTypeId).toList()[0].MaterialUnitPrice.toString();
        SS_customerNeedWeight.text=(Decimal.parse(SS_amount.text)/Decimal.parse((materialPrice))).toString();
      }


      notifyListeners();
    }
  }
  String SS_Empty_ReqQtyUnit="";

  clearEmptyForm(){
    SS_vehicleNo.clear();
    SS_selectedVehicleTypeId=null;
    SS_selectedMaterialTypeId=null;
    SS_selectedPaymentTypeId=null;
    SS_selectedVehicleTypeName=null;
    SS_selectedMaterialTypeName=null;
    SS_selectedPaymentTypeString=null;
     SS_selectedCustomerId=null;
    SS_selectedCustomerName=null;
    SS_selectCustomerId=null;
    SS_emptyVehicleWeight.clear();
    SS_customerNeedWeight.clear();
    customPriceController.clear();
    driverContactNumber.clear();
    driverName.clear();
    driverBeta.clear();
    SS_Empty_ReqQtyUnit="";
    SS_amount.clear();
    materialPrice="0.0";
    isCustomPrice=false;

     isDiscount=false;
     isPercentageDiscount=true;
     isAmountDiscount=false;
     DiscountValue=0.0;
     DiscountAmount=0.0;
     TaxAmount=0.0;
     TaxValue=0.0;
     DiscountedOutputQtyAmount=0.0;
     OutputQtyAmount=0.0;
     SubTotal=0.0;
     DiscountedSubTotal=0.0;
     GrandTotal=0.0;
     RoundOffAmount=0.0;
     isTax=false;
     notifyListeners();
  }

  List<DateTime> picked=[];

  GetSaleDetailDbhit(BuildContext context) async {

    String fromDate,toDate;

    if(picked.isEmpty){
      fromDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      toDate=DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    }
    else if(picked.length==1){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
    }
    else if(picked.length==2){
      fromDate=DateFormat("yyyy-MM-dd").format(picked[0]).toString();
      toDate=DateFormat("yyyy-MM-dd").format(picked[1]).toString();
    }


    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "USP_GetSaleDetail"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "SaleId",
          "Type": "int",
          "Value": null
        },
        {
          "Key": "FromDate",
          "Type": "String",
          "Value": fromDate
        },
        {
          "Key": "ToDate",
          "Type": "String",
          "Value":toDate
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }

      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        var parsed=json.decode(value);
        saleVehicleNumberList.clear();
        print("GET sALE ");
        var t=parsed['Table'] as List;
        var t1=parsed['Table1'] as List;
        var t2=parsed['Table2'] as List;

        print(t);
        print(t1);
        print(t2);

        saleDetailsGrid=t.map((e) => SaleDetails.fromJson(e)).toList();
        saleDetailsGrid.forEach((element) {
          print(element.MaterialUnitPrice);
        });
        saleGridReportList=t1.map((e) => SaleGridReport.fromJson(e)).toList();
        saleDetailsGridPrintersList=t2.map((e) => SalePrintersList.fromJson(e)).toList();

        saleDetails=saleDetailsGrid.where((element) => element.SaleStatus=='Open').toList();

        saleDetails.forEach((element) {
          saleVehicleNumberList.add(element.VehicleNumber);
        });
        print("SALE LEn-${saleDetailsGrid.length}");
        print("SALE LE-${saleDetails.length}");
        print("SALE LE-${saleVehicleNumberList.length}");
        print("SALE LE-${saleGridReportList.length}");
        print("SALE LE-${saleDetailsGridPrintersList.length}");
        //notifyListeners();

        clearIsOpen();
        updateInsertSaleLoader(false);
        GetCustomerDetailDbhit(context);

      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "USP_GetSaleDetail" , e.toString());
    }
  }


  int PlantId=null;
  int EditPlantId=null;
  String PlantName=null;
  Future<dynamic> UserDropDownValues(BuildContext context) async {
    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value":UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "User"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          var t=parsed['Table'] as List;
          var t1=parsed['Table1'] as List;

          t1.forEach((element) {
            if(element['UserId']==UserId){
              PlantId=element['PlantId'];
              PlantName=element['PlantName'];
            }
          });

          print(PlantId);
          print(PlantName);



        }
        updateInsertSaleLoader(false);
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }
  
  
  
  
  
  
  
  
  
  

  
  
  

  
  
  
  InsertSaleDetailDbhit(BuildContext context) async {
   print("INSERT $GrandTotal");
   print("INSERT $SubTotal");
   print("INSERT TaxAmount $TaxAmount");
    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertSaleDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": PlantId
        },
        {
          "Key": "VehicleNumber",
          "Type": "String",
          "Value": SS_vehicleNo.text
        },
        {
          "Key": "VehicleTypeId",
          "Type": "int",
          "Value": SS_selectedVehicleTypeId
        },
        {
          "Key": "EmptyWeightOfVehicle",
          "Type": "String",
          "Value": SS_emptyVehicleWeight.text
        },
        {
          "Key": "MaterialId",
          "Type": "String",
          "Value": SS_selectedMaterialTypeId
        },
        {
          "Key": "MaterialPrice",
          "Type": "String",
          "Value": materialPrice.isNotEmpty?double.parse(materialPrice):0
        },
        {
          "Key": "RequiredMaterialQty",
          "Type": "String",
          "Value": SS_customerNeedWeight.text
        },


        {
          "Key": "RequiredQtyAmount",
          "Type": "String",
          "Value": SubTotal
        },
        {
          "Key": "DiscountedRequiredQtyAmount",
          "Type": "String",
          "Value": DiscountedSubTotal
        },
        {
          "Key": "PaymentCategoryId",
          "Type": "int",
          "Value": SS_selectedPaymentTypeId
        },
        {
          "Key": "DriverName",
          "Type": "String",
          "Value": driverName.text
        },
        {
          "Key": "DriverContactNumber",
          "Type": "String",
          "Value": driverContactNumber.text
        },
        {
          "Key": "DriverCharges",
          "Type": "String",
          "Value": driverBeta.text.isNotEmpty?double.parse(driverBeta.text.toString()):0.0
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": SS_selectCustomerId
        },
        {
          "Key": "SaleStatus",
          "Type": "String",
          "Value": "Open"
        },

        {
          "Key": "IsDiscount",
          "Type": "int",
          "Value": isDiscount?1:0
        }, 
        {
          "Key": "IsPercentage",
          "Type": "int",
          "Value": isPercentageDiscount?1:0
        }, 
        {
          "Key": "IsAmount",
          "Type": "int",
          "Value": isAmountDiscount?1:0
        }, 
        {
          "Key": "DiscountValue",
          "Type": "String",
          "Value": DiscountValue
        }, 
        {
          "Key": "DiscountAmount",
          "Type": "String",
          "Value": DiscountAmount
        },
        {
          "Key": "TaxAmount",
          "Type": "String",
          "Value": TaxAmount
        },
        {
          "Key": "TaxValue",
          "Type": "String",
          "Value": TaxValue
        },
        {
          "Key": "GrandTotalAmount",
          "Type": "String",
          "Value": GrandTotal
        },
        {
          "Key": "RoundOffAmount",
          "Type": "String",
          "Value": RoundOffAmount
        },


        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        var parsed=json.decode(value);

        print(parsed);
        var t=parsed['Table'] as List;
        var t1=parsed['Table1'] as List;
        var t2=parsed['Table2'] as List;
        var t3=parsed['Table3'] as List;
        print(t);
        print(t1);
        print(t2);
        print(t3);
        //notifyListeners();
        clearEmptyForm();
        clearCustomerDetails();
        printItemwise(context,t3,t,t2,t1,true);
        updateInsertSaleLoader(false);
        GetSaleDetailDbhit(context);
        CustomAlert().billSuccessAlert(context,"","Inward Receipt Successfully Saved","","");
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSaleDetail}" , e.toString());
    }
  }










  double UpdateDiscountAmount=0.0;
  double UpdateOutputQtyAmount=0.0;
  double UpdateDiscountedOutputQtyAmount=0.0;
  double UpdateTaxAmount=0.0;
  double UpdateRoundOffAmount=0.0;
  double UpdateGrandTotalAmount=0.0;


















  UpdateSaleDetailDbhit(BuildContext context,int UpdateIsMaterialReceived,String UpdateReason) async {
  /*  print("UpdateIsMaterialReceived$UpdateIsMaterialReceived");
    print("UPDATE SALE-$SS_selectCustomerId");*/
    print("UPDATE UpdateRoundOffAmount-$UpdateRoundOffAmount");
    print("UPDATE UpdateGrandTotalAmount-$UpdateGrandTotalAmount");
    print("UPDATE UpdateTaxAmount-$UpdateTaxAmount");
    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updateSaleDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "IsOutUpdate",
          "Type": "int",
          "Value": 1
        },
        {
          "Key": "SaleId",
          "Type": "int",
          "Value": SS_UpdateSaleId
        },
        {
          "Key": "LoadWeightOfVehicle",
          "Type": "String",
          "Value": SS_DifferWeightController.text
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": SS_selectCustomerId
        },
        {
          "Key": "SaleStatus",
          "Type": "String",
          "Value": "Closed"
        },
        {
          "Key": "UpdateOutputMaterialQty",
          "Type": "String",
          "Value": SS_UpdatecustomerNeedWeight
        },
        {
          "Key": "UpdateDiscountAmount",
          "Type": "String",
          "Value": UpdateDiscountAmount
        },

        {
          "Key": "UpdateOutputQtyAmount",
          "Type": "String",
          "Value": UpdateOutputQtyAmount
        },

        {
          "Key": "UpdateDiscountedOutputQtyAmount",
          "Type": "String",
          "Value": UpdateDiscountedOutputQtyAmount
        },
        {
          "Key": "UpdateTaxAmount",
          "Type": "String",
          "Value": UpdateTaxAmount
        },
        {
          "Key": "UpdateRoundOffAmount",
          "Type": "String",
          "Value": UpdateRoundOffAmount
        },
        {
          "Key": "UpdateGrandTotalAmount",
          "Type": "String",
          "Value": UpdateGrandTotalAmount
        },


        {
          "Key": "UpdateIsMaterialReceived",
          "Type": "int",
          "Value": UpdateIsMaterialReceived
        },
        {
          "Key": "UpdateReason",
          "Type": "String",
          "Value": UpdateReason
        },

        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        var parsed=json.decode(value);

        print(parsed);
        var t=parsed['Table'] as List;
        var t1=parsed['Table1'] as List;
        var t2=parsed['Table2'] as List;
        var t3=parsed['Table3'] as List;
        print(t);
        print(t1);
        print(t2);
        print(t3);
        //notifyListeners();
        updateInsertSaleLoader(false);
        printItemwise(context,t3,t,t2,t1,false);
        clearLoaderForm();
        clearIsOpen();
        GetSaleDetailDbhit(context);
        if(UpdateIsMaterialReceived==null){
          CustomAlert().billSuccessAlert(context,"","Outward Receipt Successfully Saved","","");
        }

      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSaleDetail}" , e.toString());
    }
  }

  Future<dynamic> DeleteSaleDetailDbhit(BuildContext context,int saleId) async {
    updateInsertSaleLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.deleteSaleDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "SaleId",
          "Type": "int",
          "Value": saleId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {


        print(value);
        GetSaleDetailDbhit(context);
        updateInsertSaleLoader(false);
        CustomAlert().billSuccessAlert(context, "", "Successfully Deleted", "", "");
        notifyListeners();
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.deleteSaleDetail}" , e.toString());
    }
  }


  Future<void> printItemwise(BuildContext context,var printerList,var companydetails,var sales,var customer,bool isEnter) async {

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    final formatterTime = DateFormat.jms();

    final address=companydetails[0]['CompanyAddress'].toString();
    final splitAddress=address.split(',');
    final Map<int,String > values ={
      for(int i=0;i<splitAddress.length;i++)
        i:splitAddress[i]
    };

     Map<int,String > Customervalues;
    if(customer.isNotEmpty){
      if(customer[0]['CustomerAddress']!=null){
        final customeraddress=customer[0]['CustomerAddress'].toString();
        final splitCustomerAddress=customeraddress.split(',');
        Customervalues ={
          for(int i=0;i<splitCustomerAddress.length;i++)
            i:splitCustomerAddress[i]
        };
      }
    }

    print("sales--$sales");

    for(int i=0;i<printerList.length;i++){
      print(sales);
      final PosPrintResult res = await printer.connect('${printerList[i]['PrinterIPAddress']}', port: 9100);
      // Print image
      // final ByteData data = await rootBundle.load('assets/logo.png');
      // final Uint8List bytes = data.buffer.asUint8List();
      // final im.Image image = im.decodeImage(bytes);
      // printer.image(image);
      if (res == PosPrintResult.success) {


        // printer.row([
        //   PosColumn(text: '', width: 1),
        //   PosColumn(text: 'Outlet name', width: 11,styles: PosStyles(align: PosAlign.center, height: bnn.filteruserOutlet[bnn.outletSelected].OutletName.length<15?PosTextSize.size2:PosTextSize.size2,
        //       width: bnn.filteruserOutlet[bnn.outletSelected].OutletName.length<15?PosTextSize.size2:PosTextSize.size1,bold: true)),
        // ]);
        // printer.emptyLines(1);
        //
        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: '${companydetails[0]['CompanyName']??""}', width: 11,styles: PosStyles(align: PosAlign.center,bold: true)),
        ]);
        printer.emptyLines(1);
        values.forEach((key, value) {
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: '${value}', width: 11,styles: PosStyles(align: PosAlign.center)),
          ]);
        });
        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: '${companydetails[0]['CompanyCity']??""}, ${companydetails[0]['CompanyState']??""}-${companydetails[0]['CompanyZipCode']??""}', width: 11,
              styles: PosStyles(align: PosAlign.center,height: PosTextSize.size1,width: PosTextSize.size1)),
        ]);
        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: 'Email: ${companydetails[0]['CompanyEmail']??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
        ]);
        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: 'Ph No: ${companydetails[0]['CompanyContactNumber']??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
        ]);
        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: 'GST: ${companydetails[0]['CompanyGSTNumber']??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
        ]);
        printer.emptyLines(1);


        printer.row([
          PosColumn(text: '', width: 1),
          PosColumn(text: isEnter?'Inward Receipt':'Outward Receipt', width: 11,
              styles: PosStyles(align: PosAlign.center,bold: true,height: PosTextSize.size2,width: PosTextSize.size2)),
        ]);
        printer.emptyLines(1);
        printer.row([
          PosColumn(text: ' Sale No: ${sales[0]['SaleNumber']??""}', width: 5, styles: PosStyles(align: PosAlign.left,bold: true)),
          PosColumn(text: 'Date: ${sales[0]['DateTime']??""}', width: 7, styles: PosStyles(align: PosAlign.right)),
        ]);
        printer.emptyLines(1);
        printer.row([
          PosColumn(text: 'Vehicle Number: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['VehicleNumber'].toString().toUpperCase()??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(text: 'Vehicle Type: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['VehicleTypeName']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(text: 'Empty Vehicle Weight: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['EmptyWeightOfVehicle']??""} Ton', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(text: 'Material Name: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['MaterialName']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(text: 'Required Material Qty: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['RequiredMaterialQty']??""} ${sales[0]['UnitName']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);

        if(!isEnter){
          printer.row([
            PosColumn(text: 'Output Material Qty: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${sales[0]['OutputMaterialQty']??""} ${sales[0]['UnitName']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
        }

        printer.row([
          PosColumn(text: 'Required Qty Amount: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['RequiredQtyAmount']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);

        if(!isEnter){
          printer.row([
            PosColumn(text: 'Output Qty Amount: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${sales[0]['OutputQtyAmount']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          // printer.row([
          //   PosColumn(text:sales[0]['OutputQtyAmount']>sales[0]['RequiredQtyAmount'] ? 'Pay: ':'Balance: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          //   PosColumn(text:sales[0]['OutputQtyAmount']>sales[0]['RequiredQtyAmount'] ? '${sales[0]['OutputQtyAmount']-sales[0]['RequiredQtyAmount']}':'${sales[0]['RequiredQtyAmount']-sales[0]['OutputQtyAmount']}',
          //       width: 6, styles: PosStyles(align: PosAlign.right)),
          // ]);
        }

        printer.row([
          PosColumn(text: 'Payment Type: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: '${sales[0]['PaymentCategoryName']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);
        if(double.parse(sales[0]['OutputMaterialQty']??"0.0")>0){
          printer.row([
            PosColumn(text: 'Material Received: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: isEnter?'No / Yes':'Yes', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
        }
        else{
          printer.row([
            PosColumn(text: 'Material Received: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: isEnter?'No':'No', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
        }


        printer.emptyLines(1);

        if(double.parse(sales[0]['OutputMaterialQty']??"0.0")>0) {
          if (!isEnter) {
            printer.hr(ch: "=");

            printer.row([
              PosColumn(text: ' Material Name', width: 4, styles: PosStyles(align: PosAlign.left)),
              PosColumn(text: 'Rate', width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(text: 'Qty', width: 3, styles: PosStyles(align: PosAlign.right)),
              PosColumn(text: 'Amt',
                  width: 3,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
            printer.hr(ch: "=");

            printer.row([
              PosColumn(text: ' ${sales[0]['MaterialName'] ?? ""}', width: 4, styles: PosStyles(align: PosAlign.left)),
              PosColumn(text: '${sales[0]['MaterialUnitPrice']}', width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(text: '${sales[0]['OutputMaterialQty']} ${sales[0]['UnitName']}', width: 3, styles: PosStyles(align: PosAlign.right)),
              PosColumn(text: '${sales[0]['OutputQtyAmount'] ?? ""}', width: 3, styles: PosStyles(align: PosAlign.right)),
            ]);
            printer.hr();
            printer.emptyLines(1);

            printer.row([
              PosColumn(text: 'SubTotal: ', width: 6, styles: PosStyles(align: PosAlign.right, bold: true)),
              PosColumn(text: '${sales[0]['OutputQtyAmount'] ?? ""}', width: 6, styles: PosStyles(align: PosAlign.right)),
            ]);
            if (sales[0]['DiscountValue'] != null && sales[0]['DiscountAmount'] != null) {
              if (sales[0]['DiscountValue'] > 0) {
                printer.row([
                  PosColumn(
                      text: 'Discount (${sales[0]['IsPercentage'] == 1 ?sales[0]['DiscountValue']:""}${sales[0]['IsPercentage'] == 1 ? "%" : "Rs"})',
                      width: 6, styles: PosStyles(align: PosAlign.right, bold: true)),
                  PosColumn(text: '-${sales[0]['DiscountAmount'] ?? ""}', width: 6, styles: PosStyles(align: PosAlign.right)),
                ]);
              }
            }
            if(double.parse(sales[0]['TaxAmount'].toString())>0){
              printer.row([
                PosColumn(text: 'GST (${sales[0]['TaxValue'] ?? ""}%): ', width: 6, styles: PosStyles(align: PosAlign.right, bold: true)),
                PosColumn(text: '${sales[0]['TaxAmount'] ?? ""}', width: 6, styles: PosStyles(align: PosAlign.right)),
              ]);
            }

            if (sales[0]['RoundOffAmount'] != null) {
              if (sales[0]['RoundOffAmount'] > 0 || sales[0]['RoundOffAmount'] < 0) {
                printer.row([
                  PosColumn(text: 'RoundOff: ', width: 6, styles: PosStyles(align: PosAlign.right, bold: true)),
                  PosColumn(text: '${sales[0]['RoundOffAmount'] ?? ""}', width: 6, styles: PosStyles(align: PosAlign.right)),
                ]);
                /*  printer.emptyLines(1);
              printer.row([
                PosColumn(text: '', width: 1),
                // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: 'Total: ${Calculation().add(sales[0]['TotalAmount'], sales[0]['RoundOffAmount'])}', width: 11,
                    styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
              ]);
              printer.emptyLines(1);*/
              }
              /* else{
              printer.emptyLines(1);
              printer.row([
                PosColumn(text: '', width: 1),
                // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: 'Total: ${sales[0]['TotalAmount']??""}', width: 11,
                    styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
              ]);
              printer.emptyLines(1);
            }*/
            }

            printer.emptyLines(1);
            printer.row([
              PosColumn(text: '', width: 1),
              // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
              PosColumn(text: 'Total: ${sales[0]['TotalAmount'].round() ?? ""}',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,
                      height: PosTextSize.size2,
                      width: PosTextSize.size2)),
            ]);
            printer.emptyLines(1);
          }

          if (customer.isNotEmpty) {
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Customer Details',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center, bold: true,)),
            ]);
            printer.emptyLines(1);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Name: ${customer[0]['CustomerName'] ?? ""}',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center)),

            ]);

            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(
                  text: 'Phone No: ${customer[0]['CustomerContactNumber'] ??
                      ""}',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,)),

            ]);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Email: ${customer[0]['CustomerEmail'] ?? ""}',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,)),

            ]);
            if (Customervalues != null) {
              Customervalues.forEach((key, value) {
                printer.row([
                  PosColumn(text: '', width: 1),
                  PosColumn(text: '${value}',
                      width: 11,
                      styles: PosStyles(align: PosAlign.center)),

                ]);
              });
            }

            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${customer[0]['CustomerCity'] ??
                  ""} - ${customer[0]['CustomerZipCode'] ?? ""}',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,)),

            ]);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${customer[0]['CustomerState'] ?? ""}.',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,)),

            ]);
            print(customer[0]['CustomerGSTNumber']);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(
                  text: 'GST No: ${customer[0]['CustomerGSTNumber'] ?? ""}.',
                  width: 11,
                  styles: PosStyles(align: PosAlign.center,)),

            ]);
          }
        }



        printer.feed(1);

        printer.cut();
        printer.disconnect();
        // CustomAlert().show(context, "Printed Successfully", 300);
      }
      else{
        print("notConnected");
        // CustomAlert().(context, "Printer Not Connected", 300);
      }
    }


  }


  Future<void> printClosedReport(BuildContext context) async {

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    int customerIndex;

    customerIndex=customersList.indexWhere((element) => element.CustomerId==saleDetailsGrid[selectedIndex].CustomerId).toInt();

    print(customerIndex);

    final address=CD_address.text.toString();
    final splitAddress=address.split(',');

    final Map<int,String > values ={
      for(int i=0;i<splitAddress.length;i++)
        i:splitAddress[i]
    };

     Map<int,String > Customervalues;
    if(saleDetailsGrid[selectedIndex].CustomerId!=null){
      if(saleDetailsGrid[selectedIndex].customerAddress!=null){
        final customeraddress=saleDetailsGrid[selectedIndex].customerAddress.toString();
        final splitCustomerAddress=customeraddress.split(',');
        Customervalues ={
          for(int i=0;i<splitCustomerAddress.length;i++)
            i:splitCustomerAddress[i]
        };
      }
    }



    for(int i=0;i<saleDetailsGridPrintersList.length;i++){
      print(saleDetailsGridPrintersList[i].PrinterIPAddress);
      final PosPrintResult res = await printer.connect('${saleDetailsGridPrintersList[i].PrinterIPAddress}', port: 9100);
      // Print image
      // final ByteData data = await rootBundle.load('assets/logo.png');
      // final Uint8List bytes = data.buffer.asUint8List();
      // final im.Image image = im.decodeImage(bytes);
      // printer.image(image);
      if (res == PosPrintResult.success) {


        // printer.row([
        //   PosColumn(text: '', width: 1),
        //   PosColumn(text: 'Outlet name', width: 11,styles: PosStyles(align: PosAlign.center, height: bnn.filteruserOutlet[bnn.outletSelected].OutletName.length<15?PosTextSize.size2:PosTextSize.size2,
        //       width: bnn.filteruserOutlet[bnn.outletSelected].OutletName.length<15?PosTextSize.size2:PosTextSize.size1,bold: true)),
        // ]);
        // printer.emptyLines(1);
        //

        try{
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: '${CD_quarryname.text??""}', width: 11,styles: PosStyles(align: PosAlign.center,bold: true)),
          ]);
          printer.emptyLines(1);
          values.forEach((key, value) {
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${value}', width: 11,styles: PosStyles(align: PosAlign.center)),
            ]);
          });
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: '${CD_city.text??""}, ${CD_state.text??""}-${CD_zipcode.text??""}', width: 11,
                styles: PosStyles(align: PosAlign.center,height: PosTextSize.size1,width: PosTextSize.size1)),
          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Email: ${CD_email.text??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Ph No: ${CD_contactNo.text??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'GST: ${CD_gstno.text??""}', width: 11,styles: PosStyles(align: PosAlign.center)),
          ]);
          printer.emptyLines(1);


          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Outward Receipt', width: 11,
                styles: PosStyles(align: PosAlign.center,bold: true,height: PosTextSize.size2,width: PosTextSize.size2)),
          ]);
          printer.emptyLines(1);
          printer.row([
            PosColumn(text: ' Sale No: ${saleDetailsGrid[selectedIndex].SaleNumber??""}', width: 5, styles: PosStyles(align: PosAlign.left,bold: true)),
            PosColumn(text: 'Date: ${saleDetailsGrid[selectedIndex].SaleDate??""}', width: 7, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.emptyLines(1);
          printer.row([
            PosColumn(text: 'Vehicle Number: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].VehicleNumber.toUpperCase()??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'Vehicle Type: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].VehicleTypeName??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'Empty Vehicle Weight: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].EmptyWeightOfVehicle??""} Ton', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'Material Name: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].MaterialName??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'Required Material Qty: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].RequiredMaterialQty??""} ${saleDetailsGrid[selectedIndex].UnitName??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);

          // if(!isEnter){
          printer.row([
            PosColumn(text: 'Output Material Qty: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].OutputMaterialQty??""} ${saleDetailsGrid[selectedIndex].UnitName??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          // }

          printer.row([
            PosColumn(text: 'Required Qty Amount: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].Amount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);

          // if(!isEnter){
          printer.row([
            PosColumn(text: 'Output Qty Amount: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].OutputQtyAmount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          // printer.row([
          //   PosColumn(text:sales[0]['OutputQtyAmount']>sales[0]['RequiredQtyAmount'] ? 'Pay: ':'Balance: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          //   PosColumn(text:sales[0]['OutputQtyAmount']>sales[0]['RequiredQtyAmount'] ? '${sales[0]['OutputQtyAmount']-sales[0]['RequiredQtyAmount']}':'${sales[0]['RequiredQtyAmount']-sales[0]['OutputQtyAmount']}',
          //       width: 6, styles: PosStyles(align: PosAlign.right)),
          // ]);
          // }

          printer.row([
            PosColumn(text: 'Payment Type: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].PaymentCategoryName??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);

          if(double.parse(saleDetailsGrid[selectedIndex].OutputMaterialQty??"0")>0){
            printer.row([
              PosColumn(text: 'Material Received: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
              PosColumn(text: 'Yes', width: 6, styles: PosStyles(align: PosAlign.right)),
            ]);
          }
          else{
            printer.row([
              PosColumn(text: 'Material Received: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
              PosColumn(text: 'No', width: 6, styles: PosStyles(align: PosAlign.right)),
            ]);
          }


          printer.emptyLines(1);




          if(double.parse(saleDetailsGrid[selectedIndex].OutputMaterialQty??"0")>0){


          printer.hr(ch: "=");
          printer.row([
            PosColumn(text: ' Material Name', width: 4, styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: 'Rate', width: 2, styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: 'Qty', width: 3, styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: 'Amt', width: 3, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.hr(ch: "=");
          printer.row([
            PosColumn(text: ' ${saleDetailsGrid[selectedIndex].MaterialName??""}', width: 4, styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].MaterialUnitPrice}', width: 2, styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].OutputMaterialQty} ${saleDetailsGrid[selectedIndex].UnitName??""}', width: 3, styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].OutputQtyAmount??""}', width: 3, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.hr();
          printer.emptyLines(1);



          // if(!isEnter){
          printer.row([
            PosColumn(text: 'SubTotal: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${saleDetailsGrid[selectedIndex].OutputQtyAmount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          if(saleDetailsGrid[selectedIndex].discountAmount!=null && saleDetailsGrid[selectedIndex].discountValue!=null){
            if(saleDetailsGrid[selectedIndex].discountValue>0){
              printer.row([
                PosColumn(text: 'Discount (${saleDetailsGrid[selectedIndex].isPercentage==1?saleDetailsGrid[selectedIndex].discountValue:""} ${saleDetailsGrid[selectedIndex].isPercentage==1?"%":"Rs"})', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: '-${saleDetailsGrid[selectedIndex].discountAmount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
              ]);
            }
          }
          if(saleDetailsGrid[selectedIndex].TaxAmount>0){
            printer.row([
              PosColumn(text: 'GST (${saleDetailsGrid[selectedIndex].TaxPercentage??""}%): ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
              PosColumn(text: '${saleDetailsGrid[selectedIndex].TaxAmount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
            ]);
          }




          if(saleDetailsGrid[selectedIndex].RoundOffAmount!=null){
            if(saleDetailsGrid[selectedIndex].RoundOffAmount>0 || saleDetailsGrid[selectedIndex].RoundOffAmount<0){
              printer.row([
                PosColumn(text: 'RoundOff: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: '${saleDetailsGrid[selectedIndex].RoundOffAmount??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
              ]);
          /*    printer.emptyLines(1);
              printer.row([
                PosColumn(text: '', width: 1),
                // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: 'Total: ${Calculation().add(saleDetailsGrid[selectedIndex].TotalAmount, saleDetailsGrid[selectedIndex].RoundOffAmount)}', width: 11,
                    styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
              ]);
              printer.emptyLines(1);*/
            }
           /* else{
              printer.emptyLines(1);
              printer.row([
                PosColumn(text: '', width: 1),
                // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
                PosColumn(text: 'Total: ${saleDetailsGrid[selectedIndex].TotalAmount??""}', width: 11,
                    styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
              ]);
              printer.emptyLines(1);
            }*/
          }
            printer.emptyLines(1);
            printer.row([
              PosColumn(text: '', width: 1),
              // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
              PosColumn(text: 'Total: ${saleDetailsGrid[selectedIndex].TotalAmount.round()??""}', width: 11,
                  styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
            ]);
            printer.emptyLines(1);




          // }

          if(customerIndex!=-1){
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Customer Details', width: 11, styles: PosStyles(align: PosAlign.center,bold: true,)),
            ]);
            printer.emptyLines(1);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Name: ${saleDetailsGrid[selectedIndex].CustomerName??""}', width: 11, styles: PosStyles(align: PosAlign.center)),

            ]);

            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Phone No: ${saleDetailsGrid[selectedIndex].customerContactNumber??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

            ]);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'Email: ${saleDetailsGrid[selectedIndex].customerEmail??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

            ]);
            if(Customervalues!=null){
              Customervalues.forEach((key, value) {
                printer.row([
                  PosColumn(text: '', width: 1),
                  PosColumn(text: '${value}', width: 11,styles: PosStyles(align: PosAlign.center)),

                ]);
              });
            }

            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${saleDetailsGrid[selectedIndex].customerCity??""} - ${saleDetailsGrid[selectedIndex].customerZipCode??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

            ]);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${saleDetailsGrid[selectedIndex].customerState??""}.', width: 11, styles: PosStyles(align: PosAlign.center,)),

            ]);
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: 'GST No: ${saleDetailsGrid[selectedIndex].customerGstNumber??""}.', width: 11, styles: PosStyles(align: PosAlign.center,)),

            ]);
          }
          }
          printer.feed(1);

          printer.cut();
          printer.disconnect();
          CustomAlert().billSuccessAlert(context,"","Outward Receipt Successfully Printed","","");
          selectedIndex=-1;
          notifyListeners();
        }catch(e){
          printer.disconnect();
        }


        // CustomAlert().show(context, "Printed Successfully", 300);
      }
      else{
        print("notConnected");
        // CustomAlert().(context, "Printer Not Connected", 300);
      }
    }


  }



  List<SaleDetails> saleDetails=[];
  List<SaleDetails> saleDetailsGrid=[];
  List<SaleGridReport> saleGridReportList=[];
  List<SalePrintersList> saleDetailsGridPrintersList=[];
  List<String> saleVehicleNumberList=[];
  //List<String> saleDetailsGridCol=['Vehicle Number','Material Type','Required Qty','Output Material Qty','Amount','Status'];
  List<String> saleDetailsGridCol=['Date','Sale No','Vehicle Number','Material','Amount'];
 // List<String> saleDetailsGridCol=["Material Name","Unit","Price","GST","Unit","Price","GST"];


 TextEditingController searchVehicleNo =new TextEditingController();
 TextEditingController SS_DifferWeightController =new TextEditingController();
  var SS_LoadedVehicleNo=null;


  String SS_EmptyWeightOfVehicle;
  String SS_VehicleTypeName;
  String SS_MaterialName;
  String SS_RequiredMaterialQty;
  String SS_RequiredMaterialQtyUnit;
  String SS_PaymentCategoryName;
  String SS_TotalWeight;
  int SS_VehicleTypeId;
  int SS_MaterialTypeId;
  int SS_PaymentTypeId;
  int SS_UpdateSaleId;
  int SS_UpdateSaleNo;

  double SS_Amount;
  double SS_DiscountAmount;
  double SS_DiscountedOutputQtyAmount;
  double SS_TaxAmount;
  double SS_RoundOffAmount;
  double SS_GrandTotalAmount;


  double OG_discountValue;
  double OG_TaxValue;
  double OG_TaxAmount;
  double OG_DiscountAmount;
  double OG_SubTotal;
  double OG_DiscountedSubTotal;
  double OG_GrandTotal;
  double OG_RoundOffAmount;
  int OG_isPercentage;
  int OG_isDiscount;
  bool OG_isTax;

  String SS_DifferWeight;

  double SS_MaterialUnitPrice;
  String SS_UpdatecustomerNeedWeight;
  String SS_UpdateAmount;
  String msg="";
  String returnMoney="";
  int SS_isMaterialReceived;
  Color returnColor;

  differWeight(BuildContext context){
    print("SS_MaterialUnitPrice $SS_MaterialUnitPrice");
    print("Fdf-$SS_MaterialUnitPrice");



    if(SS_DifferWeightController.text.isEmpty){
      print("EMPTY");
      msg="";
      returnMoney="";
      SS_UpdatecustomerNeedWeight=SS_RequiredMaterialQty;
      SS_UpdateAmount=SS_Amount.toString();
       OG_TaxAmount=0.0;
       OG_DiscountAmount=0.0;
       OG_SubTotal=0.0;
       OG_GrandTotal=0.0;
    }
    else if(double.parse(SS_EmptyWeightOfVehicle)==double.parse(SS_DifferWeightController.text.toString())){
      msg="";
      returnMoney="";
      SS_UpdatecustomerNeedWeight="0.0";
      SS_UpdateAmount="0.0";
      UpdateTaxAmount=0.0;
      UpdateGrandTotalAmount=0.0;
      UpdateOutputQtyAmount=0.0;
      UpdateDiscountAmount=0.0;
      UpdateDiscountedOutputQtyAmount=0.0;
      UpdateRoundOffAmount=0.0;
    }
    else if(double.parse(SS_TotalWeight)>double.parse(SS_DifferWeightController.text.toString())){
      SS_DifferWeight=(Decimal.parse(SS_TotalWeight)-Decimal.parse((SS_DifferWeightController.text))).toString();
      msg="Material Low ${SS_DifferWeight}. So You need to Return";
      returnMoney=(Decimal.parse(SS_MaterialUnitPrice.toString()??"0")*Decimal.parse((SS_DifferWeight))).toString();
      SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)-Decimal.parse(SS_DifferWeight)).toString();
      SS_UpdateAmount=(Decimal.parse(SS_Amount.toString())-Decimal.parse(returnMoney)).toString();
      returnColor=Colors.red;
      print("__________${double.parse(returnMoney.toString()) > SS_Amount}");



      if(OG_isDiscount==1){
        if(OG_isPercentage==0){

          SS_DifferWeight=(Decimal.parse(SS_TotalWeight)-Decimal.parse((SS_DifferWeightController.text))).toString();
          msg="Material Low ${SS_DifferWeight}. So You need to Return";

          SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)-Decimal.parse(SS_DifferWeight)).toString();
          SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice).toString();
          UpdateDiscountAmount=SS_DiscountAmount;
          UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
          UpdateDiscountedOutputQtyAmount=Calculation().sub(UpdateOutputQtyAmount, UpdateDiscountAmount);
          if(OG_isTax){
            UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
          }
          else{
            UpdateTaxAmount=0.0;
          }

          UpdateGrandTotalAmount=Calculation().add(UpdateDiscountedOutputQtyAmount, UpdateTaxAmount);
          UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);

        }
        else if(OG_isPercentage==1){






          SS_DifferWeight=(Decimal.parse(SS_TotalWeight)-Decimal.parse((SS_DifferWeightController.text))).toString();
          msg="Material Low ${SS_DifferWeight}. So You need to Return";

          SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)-Decimal.parse(SS_DifferWeight)).toString();
          SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice).toString();
          UpdateDiscountAmount=Calculation().discountAmount(discountValue:OG_discountValue,amount: SS_UpdateAmount );
          UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
          UpdateDiscountedOutputQtyAmount=Calculation().sub(UpdateOutputQtyAmount, UpdateDiscountAmount);
          if(OG_isTax){
            UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
          }
          else{
            UpdateTaxAmount=0.0;
          }

          UpdateGrandTotalAmount=Calculation().add(UpdateDiscountedOutputQtyAmount, UpdateTaxAmount);
          UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);

        }
      }
      else{
        OG_DiscountAmount=0.0;
        OG_DiscountedSubTotal=0.0;


        SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)-Decimal.parse(SS_DifferWeight)).toString();
        SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice.toString()).toString();
        UpdateDiscountAmount=0.0;
        UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
        UpdateDiscountedOutputQtyAmount=0.0;
        if(OG_isTax){
          UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
        }
        else{
          UpdateTaxAmount=0.0;
        }
        UpdateGrandTotalAmount=Calculation().add(UpdateOutputQtyAmount, UpdateTaxAmount);
        UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);


      }



      notifyListeners();
    }
    else if(double.parse(SS_TotalWeight)<double.parse(SS_DifferWeightController.text.toString())){
      SS_DifferWeight=(Decimal.parse(SS_DifferWeightController.text)-Decimal.parse((SS_TotalWeight))).toString();
      msg="Material High ${SS_DifferWeight}. So Customer Need To Pay";
      returnMoney=(Decimal.parse(SS_MaterialUnitPrice.toString()??"0")*Decimal.parse((SS_DifferWeight))).toString();
      SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)+Decimal.parse(SS_DifferWeight)).toString();
      SS_UpdateAmount=(Decimal.parse(SS_Amount.toString())+Decimal.parse(returnMoney)).toString();
      returnColor=Colors.green;



      if(OG_isDiscount==1){
        if(OG_isPercentage==0){

          SS_DifferWeight=(Decimal.parse(SS_DifferWeightController.text)-Decimal.parse((SS_TotalWeight))).toString();
          msg="Material High ${SS_DifferWeight}. So Customer Need To Pay";

          SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)+Decimal.parse(SS_DifferWeight)).toString();
          SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice).toString();
          UpdateDiscountAmount=SS_DiscountAmount;
          UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
          UpdateDiscountedOutputQtyAmount=Calculation().sub(UpdateOutputQtyAmount, UpdateDiscountAmount);
          if(OG_isTax){
            UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
          }
          else{
            UpdateTaxAmount=0.0;
          }
          UpdateGrandTotalAmount=Calculation().add(UpdateDiscountedOutputQtyAmount, UpdateTaxAmount);
          UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);




        }
        else if(OG_isPercentage==1){







          SS_DifferWeight=(Decimal.parse(SS_DifferWeightController.text)-Decimal.parse((SS_TotalWeight))).toString();
          msg="Material High ${SS_DifferWeight}. So Customer Need To Pay";


          SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)+Decimal.parse(SS_DifferWeight)).toString();
          SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice).toString();
          UpdateDiscountAmount=Calculation().discountAmount(discountValue:OG_discountValue,amount: SS_UpdateAmount );
          UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
          UpdateDiscountedOutputQtyAmount=Calculation().sub(UpdateOutputQtyAmount, UpdateDiscountAmount);
          if(OG_isTax){
            UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
          }
          else{
            UpdateTaxAmount=0.0;
          }
          UpdateGrandTotalAmount=Calculation().add(UpdateDiscountedOutputQtyAmount, UpdateTaxAmount);
          UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);

        }
      }
      else{
        OG_DiscountAmount=0.0;
        OG_DiscountedSubTotal=0.0;

        SS_DifferWeight=(Decimal.parse(SS_DifferWeightController.text)-Decimal.parse((SS_TotalWeight))).toString();

        SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)+Decimal.parse(SS_DifferWeight)).toString();
        SS_UpdateAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice).toString();
        UpdateDiscountAmount=0.0;
        UpdateOutputQtyAmount=Calculation().mul(SS_UpdatecustomerNeedWeight, SS_MaterialUnitPrice);
        UpdateDiscountedOutputQtyAmount=0.0;
        if(OG_isTax){
          UpdateTaxAmount=Calculation().taxAmount(taxValue: OG_TaxValue,amount:UpdateOutputQtyAmount,discountAmount:UpdateDiscountAmount  );
        }
        else{
          UpdateTaxAmount=0.0;
        }
        UpdateGrandTotalAmount=Calculation().add(UpdateOutputQtyAmount, UpdateTaxAmount);
        UpdateRoundOffAmount=Calculation().sub(UpdateGrandTotalAmount.round(), UpdateGrandTotalAmount);

      }



      notifyListeners();
    }
    else{
      msg="";
      returnMoney="";
      SS_UpdatecustomerNeedWeight=SS_RequiredMaterialQty;
      SS_UpdateAmount=SS_Amount.toString();
      UpdateTaxAmount=SS_TaxAmount;
      UpdateGrandTotalAmount=SS_GrandTotalAmount;
      UpdateOutputQtyAmount=SS_Amount;
      UpdateDiscountAmount=SS_DiscountAmount;
      UpdateDiscountedOutputQtyAmount=SS_DiscountedOutputQtyAmount;
      UpdateRoundOffAmount=SS_RoundOffAmount;
      print("SS_UpdatecustomerNeedWeightEQQUAL $SS_UpdatecustomerNeedWeight");
      print(SS_UpdateAmount);
      print(UpdateGrandTotalAmount);
      print(UpdateTaxAmount);
      print(UpdateDiscountAmount);
      print(UpdateDiscountedOutputQtyAmount);
      print(UpdateRoundOffAmount);
    }
    notifyListeners();
  }





 clearLoaderForm(){

   SS_UpdateAmount="";
   SS_UpdatecustomerNeedWeight="";
   searchVehicleNo.clear();
    SS_LoadedVehicleNo=null;

   SS_DifferWeightController.clear();
    SS_EmptyWeightOfVehicle="";
    SS_VehicleTypeName="";
    SS_MaterialName="";
    SS_RequiredMaterialQty="";
   SS_RequiredMaterialQtyUnit="";
    SS_PaymentCategoryName="";
    SS_TotalWeight="";
    SS_VehicleTypeId=null;
    SS_MaterialTypeId=null;
    SS_PaymentTypeId=null;
   SS_selectCustomerId=null;
    SS_Amount=0.0;
   OG_TaxValue=0.0;
   OG_discountValue=null;

    SS_DifferWeight;

    SS_MaterialUnitPrice=0.0;

    msg="";
    returnMoney="";
  notifyListeners();
 }

  TabController tabController;
  initTabController(TickerProviderStateMixin tickerProviderStateMixin,BuildContext context,bool fromsaleGrid){
    tabController=new TabController(length: 2, vsync: tickerProviderStateMixin);
    tabController.addListener(() {
      if(tabController.index==1){
        if(!fromsaleGrid){
          GetSaleDetailDbhit(context);
        }



      }else if(tabController.index==0){
        GetCustomerDetailDbhit(context);
      }

    });
    if(fromsaleGrid){
      tabController.animateTo(1,duration: Duration(milliseconds: 300),curve: Curves.easeIn);
    }

  }

  editLoader(){
    SS_LoadedVehicleNo=saleDetails[selectedIndex].VehicleNumber;
    searchVehicleNo.text=saleDetails[selectedIndex].VehicleNumber;

    SS_EmptyWeightOfVehicle=saleDetails[selectedIndex].EmptyWeightOfVehicle;
    SS_VehicleTypeName=saleDetails[selectedIndex].VehicleTypeName;
    SS_VehicleTypeId=saleDetails[selectedIndex].VehicleTypeId;
    SS_MaterialName=saleDetails[selectedIndex].MaterialName;
    SS_MaterialTypeId=saleDetails[selectedIndex].MaterialId;
    SS_RequiredMaterialQty=saleDetails[selectedIndex].RequiredMaterialQty;
    SS_RequiredMaterialQtyUnit=saleDetails[selectedIndex].UnitName;
    SS_Amount=saleDetails[selectedIndex].Amount;
    SS_PaymentCategoryName=saleDetails[selectedIndex].PaymentCategoryName;
    SS_PaymentTypeId=saleDetails[selectedIndex].PaymentCategoryId;
    SS_UpdateSaleId=saleDetails[selectedIndex].SaleId;
    SS_UpdateSaleNo=saleDetails[selectedIndex].SaleNumber;
    SS_selectCustomerId=saleDetails[selectedIndex].CustomerId;
    SS_TotalWeight=(Decimal.parse(SS_EmptyWeightOfVehicle)+Decimal.parse((SS_RequiredMaterialQty))).toString();
   // SS_MaterialUnitPrice=sale_materialList.where((element) => element.MaterialId==saleDetails[selectedIndex].MaterialId).toList()[0].MaterialUnitPrice;
    SS_MaterialUnitPrice=saleDetails[selectedIndex].MaterialUnitPrice;


    SS_EmptyWeightOfVehicle=saleDetails[selectedIndex].EmptyWeightOfVehicle;
    SS_VehicleTypeName=saleDetails[selectedIndex].VehicleTypeName;
    SS_VehicleTypeId=saleDetails[selectedIndex].VehicleTypeId;
    SS_MaterialName=saleDetails[selectedIndex].MaterialName;
    SS_MaterialTypeId=saleDetails[selectedIndex].MaterialId;
    SS_RequiredMaterialQty=saleDetails[selectedIndex].RequiredMaterialQty;
    SS_RequiredMaterialQtyUnit=saleDetails[selectedIndex].UnitName;
    SS_Amount=saleDetails[selectedIndex].Amount;

    SS_DiscountAmount=saleDetails[selectedIndex].discountAmount;
    SS_DiscountedOutputQtyAmount=saleDetails[selectedIndex].DiscountedRequiredQtyAmount;
    SS_TaxAmount=saleDetails[selectedIndex].TaxAmount;
    SS_RoundOffAmount=saleDetails[selectedIndex].RoundOffAmount;
    SS_GrandTotalAmount=saleDetails[selectedIndex].TotalAmount;

    SS_PaymentCategoryName=saleDetails[selectedIndex].PaymentCategoryName;
    SS_PaymentTypeId=saleDetails[selectedIndex].PaymentCategoryId;
    SS_UpdateSaleId=saleDetails[selectedIndex].SaleId;
    SS_UpdateSaleNo=saleDetails[selectedIndex].SaleNumber;
    SS_selectCustomerId=saleDetails[selectedIndex].CustomerId;
    OG_discountValue=saleDetails[selectedIndex].discountValue;
    OG_TaxValue=saleDetails[selectedIndex].TaxPercentage;
    OG_isPercentage=saleDetails[selectedIndex].isPercentage;
    OG_isDiscount=saleDetails[selectedIndex].isDiscount;
    SS_TotalWeight=(Decimal.parse(SS_EmptyWeightOfVehicle)+Decimal.parse((SS_RequiredMaterialQty))).toString();
    SS_MaterialUnitPrice=saleDetails[selectedIndex].MaterialUnitPrice;
    notifyListeners();
  }

  int selectedIndex=-1;

  clearIsOpen(){
    selectedIndex=-1;
    notifyListeners();
  }



  ///****************************************************      QUARRY DETAIL   / Company Detail    ****************************************************************/

  TextEditingController CD_quarryname= new TextEditingController();
  TextEditingController CD_contactNo= new TextEditingController();
  TextEditingController CD_address= new TextEditingController();
  TextEditingController CD_city= new TextEditingController();
  TextEditingController CD_state= new TextEditingController();
  TextEditingController CD_zipcode= new TextEditingController();
  TextEditingController CD_gstno= new TextEditingController();
  TextEditingController CD_Panno= new TextEditingController();
  TextEditingController CD_Cinno= new TextEditingController();
  TextEditingController CD_email= new TextEditingController();
  TextEditingController CD_website= new TextEditingController();

  var CompanyLogo;
  var CompanyLogoFolder;

  GetQuarryDetailDbhit(BuildContext context) async {
    updateInsertCompanyLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getCompanyDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);
          print(parsed);

          var t1=parsed['Table'] as List;

          CD_quarryname.text= t1[0]['CompanyName'];
          CD_contactNo.text= t1[0]['CompanyContactNumber'];
          CD_address.text= t1[0]['CompanyAddress'];
          CD_city.text= t1[0]['CompanyCity'];
          CD_state.text= t1[0]['CompanyState'];
          CD_zipcode.text= t1[0]['CompanyZipCode'];
          CD_gstno.text= t1[0]['CompanyGSTNumber'];
          CD_Panno.text= t1[0]['CompanyPANNumber'];
          CD_Cinno.text= t1[0]['CompanyCINNumber'];
          CD_email.text= t1[0]['CompanyEmail'];
          CD_website.text= t1[0]['CompanyWebsite'];
          CompanyLogo= t1[0]['CompanyLogo'];
          CompanyLogoFolder= t1[0]['CompanyLogoFolderName']??"";
        }

        updateInsertCompanyLoader(false);

      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.dropDownValues}" , e.toString());
    }
  }

  UpdateQuarryDetailDbhit(BuildContext context) async {
    print("USERID-$UserId");
    print("DataBaseName-$DataBaseName");
    updateInsertCompanyLoader(true);

    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updateCompanyDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "CompanyName",
          "Type": "String",
          "Value": CD_quarryname.text
        },
        {
          "Key": "CompanyAddress",
          "Type": "String",
          "Value": CD_address.text
        },
        {
          "Key": "CompanyCity",
          "Type": "String",
          "Value": CD_city.text
        },
        {
          "Key": "CompanyState",
          "Type": "String",
          "Value": CD_state.text
        },
        {
          "Key": "CompanyZipCode",
          "Type": "String",
          "Value": CD_zipcode.text
        },
        {
          "Key": "CompanyContactNumber",
          "Type": "String",
          "Value": CD_contactNo.text
        },
        {
          "Key": "CompanyEmail",
          "Type": "String",
          "Value": CD_email.text
        },
        {
          "Key": "CompanyWebsite",
          "Type": "String",
          "Value": CD_website.text
        },
        {
          "Key": "CompanyGSTNumber",
          "Type": "String",
          "Value": CD_gstno.text
        },
        {
          "Key": "CompanyPANNumber",
          "Type": "String",
          "Value": CD_Panno.text
        },
        {
          "Key": "CompanyCINNumber",
          "Type": "String",
          "Value": CD_Cinno.text
        },
        {
          "Key": "CompanyLogoFileName",
          "Type": "String",
          "Value": CompanyLogo
        },
        {
          "Key": "CompanyLogoFolderName",
          "Type": "String",
          "Value": CompanyLogoFolder
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          print(parsed);
          updateInsertCompanyLoader(false);
        }



      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateCompanyDetail}" , e.toString());
    }
  }





  //**********************************************    plant Details  *********************************************************//

  List<PlantTypeModel> plantTypeList=[];
  PlantDropDownValues(BuildContext context) async {
    updateInsertCompanyLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.MasterdropDown}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "TypeName",
          "Type": "String",
          "Value": "PlantType"
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        },
      ]
    };
    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
       if(value!=null){
         var parsed=json.decode(value);
         var t=parsed['Table'] as List;
         plantTypeList=t.map((e) => PlantTypeModel.fromJson(e)).toList();
       }

        updateInsertCompanyLoader(false);
      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.MasterdropDown}" , e.toString());
    }
  }

  List<PlantGridModel> plantGridList=[];

  GetplantDetailDbhit(BuildContext context,int plantId) async {
    updateInsertCompanyLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getPlantDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": plantId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        if(value!=null){
          var parsed=json.decode(value);
          print(parsed);
          var t=parsed['Table'] as List;


          if(plantId!=null){
            var t1=parsed['Table1'] as List;
            PD_plantTypeId=t[0]['PlantTypeId'];
            PD_plantTypeName=t[0]['PlantTypeName'];
            editPlantId=t[0]['PlantId'];

            PD_quarryname.text=t[0]['PlantName'];
            PD_contactNo.text=t[0]['PlantContactNumber'];
            PD_address.text=t[0]['PlantAddress'];
            PD_city.text=t[0]['PlantCity'];
            PD_state.text=t[0]['PlantState'];
            PD_country.text=t[0]['PlantCountry'];
            PD_zipcode.text=t[0]['PlantZipCode'];

            PD_email.text=t[0]['PlantEmail'];
            PD_website.text=t[0]['PlantWebsite'];
            PD_ContactPersonName.text=t[0]['PlantContactPersonName'];
            PD_Designation.text=t[0]['PlantContactPersonDesignation'];

            PO_PlantLicenseList=t1.map((e) => PlantLicenseModel.fromJson(e)).toList();
            updatePlantDetailEdit(true);
          }
          else{
            plantGridList=t.map((e) => PlantGridModel.fromJson(e)).toList();
          }

        }

        updateInsertCompanyLoader(false);

      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getPlantDetail}" , e.toString());
    }
  }

  TextEditingController PD_quarryname= new TextEditingController();
  TextEditingController PD_contactNo= new TextEditingController();
  TextEditingController PD_address= new TextEditingController();
  TextEditingController PD_city= new TextEditingController();
  TextEditingController PD_state= new TextEditingController();
  TextEditingController PD_country= new TextEditingController();
  TextEditingController PD_zipcode= new TextEditingController();
  TextEditingController PD_gstno= new TextEditingController();
  TextEditingController PD_Panno= new TextEditingController();
  TextEditingController PD_Cinno= new TextEditingController();
  TextEditingController PD_email= new TextEditingController();
  TextEditingController PD_website= new TextEditingController();
  TextEditingController PD_ContactPersonName= new TextEditingController();
  TextEditingController PD_Designation= new TextEditingController();


  TextEditingController PD_LicenseNo= new TextEditingController();
  TextEditingController PD_LicenseDesc= new TextEditingController();
 DateTime PD_fromDate;
 DateTime PD_toDate;

  int PD_plantTypeId=null;
  String PD_plantTypeName=null;

  int editPlantId=null;

  List<PlantLicenseModel> PO_PlantLicenseList=[];


  InsertPlantDetailDbhit(BuildContext context) async {
    updateInsertCompanyLoader(true);
    List js=[];
    js=PO_PlantLicenseList.map((e) => e.toJson()).toList();
    print(js);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": isPlantDetailsEdit?"${Sp.updatePlantDetail}":"${Sp.insertPlantDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "PlantId",
          "Type": "int",
          "Value": editPlantId
        },
        {
          "Key": "PlantName",
          "Type": "String",
          "Value": PD_quarryname.text
        },
        {
          "Key": "PlantAddress",
          "Type": "String",
          "Value": PD_address.text
        },
        {
          "Key": "PlantCity",
          "Type": "String",
          "Value": PD_city.text
        },
        {
          "Key": "PlantState",
          "Type": "String",
          "Value": PD_state.text
        },
        {
          "Key": "PlantCountry",
          "Type": "String",
          "Value": PD_country.text
        },
        {
          "Key": "PlantZipCode",
          "Type": "String",
          "Value": PD_zipcode.text
        },
        {
          "Key": "PlantContactNumber",
          "Type": "String",
          "Value": PD_contactNo.text
        },
        {
          "Key": "PlantEmail",
          "Type": "String",
          "Value": PD_email.text
        },
        {
          "Key": "PlantWebsite",
          "Type": "String",
          "Value": PD_website.text
        },
        {
          "Key": "PlantTypeId",
          "Type": "int",
          "Value": PD_plantTypeId
        },
        {
          "Key": "PlantContactPersonName",
          "Type": "String",
          "Value": PD_ContactPersonName.text
        },
        {
          "Key": "PlantContactPersonDesignation",
          "Type": "String",
          "Value": PD_Designation.text
        },
        {
          "Key": "PlantLicenseList",
          "Type": "datatable",
          "Value": js
        },

        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          print(parsed);

          clearPlantForm();
          Navigator.pop(context);
          GetplantDetailDbhit(context, null);
        }

        updateInsertCompanyLoader(false);

      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateCompanyDetail}" , e.toString());
    }
  }



 clearPlantLicenseForm(){
   PD_fromDate=DateTime.now();
   PD_toDate=DateTime.now();
   PD_LicenseNo.clear();
   PD_LicenseDesc.clear();
   notifyListeners();
 }

 clearPlantForm(){
    PD_plantTypeId=null;
    PD_plantTypeName=null;
    editPlantId=null;
    PO_PlantLicenseList.clear();
    PD_quarryname.clear();
    PD_contactNo.clear();
    PD_address.clear();
    PD_city.clear();
    PD_state.clear();
    PD_country.clear();
    PD_zipcode.clear();
    PD_gstno.clear();
    PD_Panno.clear();
    PD_Cinno.clear();
    PD_email.clear();
    PD_website.clear();
    PD_ContactPersonName.clear();
    PD_Designation.clear();
 }








  bool isPlantDetailsEdit=false;
  updatePlantDetailEdit(bool value){
    isPlantDetailsEdit=value;
    notifyListeners();
  }

  ///****************************************************     CUSTOMER DETAIL     ****************************************************************/

  TextEditingController customerName=new TextEditingController();
  TextEditingController customerAddress=new TextEditingController();
  TextEditingController customerCity=new TextEditingController();
  TextEditingController customerState=new TextEditingController();
  TextEditingController customerCountry=new TextEditingController();
  TextEditingController customerZipcode=new TextEditingController();
  TextEditingController customerContactNumber=new TextEditingController();
  TextEditingController customerEmail=new TextEditingController();
  TextEditingController customerGstNumber=new TextEditingController();


  int SS_selectCustomerId=null;
  String SS_CustomerName;
  List<CustomerDetails> customersList=[];
  List<String> customerNameList=[];
  List<String> customerGridCol=["Name","Contact No","Email","GST No"];

  updateSelectCustomerFromAddNew(int customerId,String customerName){
    SS_selectCustomerId=customerId;
    SS_selectedCustomerName=customerName;
    sale_customerList.add(CustomerModel(
      customerId: SS_selectCustomerId,
      customerName: SS_selectedCustomerName
    ));
    notifyListeners();
  }

  GetCustomerDetailDbhit(BuildContext context) async {
    updatecustomerLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": null
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        customerNameList.clear();
        var parsed=json.decode(value);
        var t=parsed['Table'] as List;

        customersList=t.map((e) => CustomerDetails.fromJson(e)).toList();
        customersList.forEach((element) {
          customerNameList.add(element.CustomerName);
        });

        updatecustomerLoader(false);
        notifyListeners();
      });
    }
    catch(e){
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getCompanyDetail}" , e.toString());
    }
  }

  Future<dynamic> InsertCustomerDetailDbhit(BuildContext context) async {
    updatecustomerLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "CustomerName",
          "Type": "String",
          "Value": customerName.text
        },
        {
          "Key": "CustomerCode",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "CustomerAddress",
          "Type": "String",
          "Value": customerAddress.text
        },
        {
          "Key": "CustomerCity",
          "Type": "String",
          "Value": customerCity.text
        },
        {
          "Key": "CustomerState",
          "Type": "String",
          "Value": customerState.text
        },
        {
          "Key": "CustomerCountry",
          "Type": "String",
          "Value": customerCountry.text
        },
        {
          "Key": "CustomerZipCode",
          "Type": "String",
          "Value": customerZipcode.text
        },
        {
          "Key": "CustomerContactNumber",
          "Type": "String",
          "Value": customerContactNumber.text
        },
        {
          "Key": "CustomerEmail",
          "Type": "String",
          "Value": customerEmail.text
        },
        {
          "Key": "CustomerGSTNumber",
          "Type": "String",
          "Value": customerGstNumber.text
        },
        {
          "Key": "CustomerLogoFileName",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "CustomerLogoFolderName",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);
          SS_selectCustomerId=parsed['Table'][0]['CustomerId'];
          GetCustomerDetailDbhit(context);
        }

        updatecustomerLoader(false);
      });
    }
    catch(e){
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertCustomerDetail}" , e.toString());
    }
  }

  Future<dynamic> UpdateCustomerDetailDbhit(BuildContext context) async {
    print("UPDATE--$SS_selectCustomerId");
    updatecustomerLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.updateCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": SS_selectCustomerId
        },
        {
          "Key": "CustomerName",
          "Type": "String",
          "Value": customerName.text
        },
        {
          "Key": "CustomerCode",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "CustomerAddress",
          "Type": "String",
          "Value": customerAddress.text
        },
        {
          "Key": "CustomerCity",
          "Type": "String",
          "Value": customerCity.text
        },
        {
          "Key": "CustomerState",
          "Type": "String",
          "Value": customerState.text
        },
        {
          "Key": "CustomerCountry",
          "Type": "String",
          "Value": customerCountry.text
        },
        {
          "Key": "CustomerZipCode",
          "Type": "String",
          "Value": customerZipcode.text
        },
        {
          "Key": "CustomerContactNumber",
          "Type": "String",
          "Value": customerContactNumber.text
        },
        {
          "Key": "CustomerEmail",
          "Type": "String",
          "Value": customerEmail.text
        },
        {
          "Key": "CustomerGSTNumber",
          "Type": "String",
          "Value": customerGstNumber.text
        },
        {
          "Key": "CustomerLogoFileName",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "CustomerLogoFolderName",
          "Type": "String",
          "Value": null
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        print(value);
        if(value!=null){
          var parsed=json.decode(value);
          print(parsed);
          GetCustomerDetailDbhit(context);
        }

        //notifyListeners();

        updatecustomerLoader(false);

      });
    }
    catch(e){
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.updateCustomerDetail}" , e.toString());
    }
  }

  DeleteCustomerDetailDbhit(BuildContext context,int CustomerId) async {
    updatecustomerLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.deleteCustomerDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": CustomerId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {


        print(value);
        GetCustomerDetailDbhit(context);
        updatecustomerLoader(false);
        CustomAlert().billSuccessAlert(context, "", "Successfully Deleted", "", "");
        notifyListeners();
      });
    }
    catch(e){
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.deleteCustomerDetail}" , e.toString());
    }
  }



  bool isCustomerEdit=false;
  updateCustomerEdit(bool value){
    isCustomerEdit=value;
    notifyListeners();
  }



  clearCustomerDetails(){
     customerName.clear();
     customerAddress.clear();
     customerCity.clear();
     customerState.clear();
     customerCountry.clear();
     customerZipcode.clear();
     customerContactNumber.clear();
     customerEmail.clear();
     customerGstNumber.clear();
     SS_selectCustomerId=null;

  }



  ///****************************************************     MATERIAL DETAIL     ****************************************************************/
   TextEditingController materialName=new TextEditingController();
   TextEditingController materialDesc=new TextEditingController();
   TextEditingController materialCode=new TextEditingController();
   TextEditingController materialUnitPrice=new TextEditingController();
   TextEditingController materialHSNCode=new TextEditingController();
   TextEditingController materialGST=new TextEditingController();

   int MM_selectMaterialUnitId=null;
   String MM_selectMaterialUnitName;

   List<TaxDetails> selectTaxList=[];


  List<String> materialProcessGridCol=["Material Name","Unit","Price","GST"];
   List<MaterialDetailGridModel> materialGridList=[];

  GetMaterialDetailDbhit(BuildContext context) async {
    updatemasterLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.getMaterialDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "MaterialId",
          "Type": "int",
          "Value": null
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {

        var parsed=json.decode(value);
        var t=parsed['Table'] as List;

        materialGridList=t.map((e) => MaterialDetailGridModel.fromJson(e)).toList();
        updatemasterLoader(false);
        notifyListeners();
      });
    }
    catch(e){
      updatemasterLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.getMaterialDetail}" , e.toString());
    }
  }


  Future<dynamic> InsertMaterialDetailDbhit(BuildContext context) async {

    List<dynamic> js= selectTaxList.map((e) => e.toJson()).toList();
    print(js);


    updatemasterLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.insertMaterialDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "MaterialName",
          "Type": "String",
          "Value": materialName.text
        },
        {
          "Key": "MaterialDescription",
          "Type": "String",
          "Value": materialDesc.text
        },
        {
          "Key": "MaterialCode",
          "Type": "String",
          "Value": materialCode.text
        },
        {
          "Key": "MaterialUnitId",
          "Type": "int",
          "Value": MM_selectMaterialUnitId
        },
        {
          "Key": "MaterialUnitPrice",
          "Type": "String",
          "Value": materialUnitPrice.text
        },
        {
          "Key": "MaterialHSNCode",
          "Type": "String",
          "Value": materialHSNCode.text
        },
        {
          "Key": "MaterialTaxValue",
          "Type": "String",
          "Value": materialGST.text
        },
        {
          "Key": "MaterialTaxMappingList",
          "Type": "datatable",
          "Value": js
        },

        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {
        if(value!=null){
          var parsed=json.decode(value);

          print(parsed);
          //notifyListeners();
           GetMaterialDetailDbhit(context);
          clearMaterialForm();

          Navigator.pop(context);
        }

        updatemasterLoader(false);
      });
    }
    catch(e){
      updatemasterLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertMaterialDetail}" , e.toString());
    }
  }


  DeleteMasterDetailDbhit(BuildContext context,int MaterialId) async {
    print("$MaterialId");
    updatemasterLoader(true);
    var body={
      "Fields": [
        {
          "Key": "SpName",
          "Type": "String",
          "Value": "${Sp.deleteMaterialDetail}"
        },
        {
          "Key": "LoginUserId",
          "Type": "int",
          "Value": UserId
        },
        {
          "Key": "MaterialId",
          "Type": "int",
          "Value": MaterialId
        },
        {
          "Key": "database",
          "Type": "String",
          "Value": DataBaseName
        }
      ]
    };

    try{
      await call.ApiCallGetInvoke(body,context).then((value) {


        print(value);
        if(value!=null){
          GetMaterialDetailDbhit(context);
          CustomAlert().billSuccessAlert(context, "", "Successfully Deleted", "", "");
        }
        updatemasterLoader(false);
        notifyListeners();
      });
    }
    catch(e){
      updatemasterLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.deleteCustomerDetail}" , e.toString());
    }
  }



  clearMaterialForm(){
    materialName.clear();
    materialDesc.clear();
    materialCode.clear();
    MM_selectMaterialUnitId=null;
    MM_selectMaterialUnitName='';

     materialUnitPrice.clear();
     materialHSNCode.clear();
     materialGST.clear();
    selectTaxList.clear();


  }














  ///////////////////////LOADERS //////////////////////////////////////
  bool dropDownLoader=false;
  void updatedropDownLoader(bool value){
    dropDownLoader=value;
    notifyListeners();
  }


  bool insertCompanyLoader=false;
  void updateInsertCompanyLoader(bool value){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertCompanyLoader=value;
      notifyListeners();

    });

  }

  bool insertSaleLoader=false;
  void updateInsertSaleLoader(bool value){
    insertSaleLoader=value;
    notifyListeners();
  }


  bool customerLoader=false;
  void updatecustomerLoader(bool value){
    customerLoader=value;
    notifyListeners();
  }

  bool masterLoader=false;
  void updatemasterLoader(bool value){
    masterLoader=value;
    notifyListeners();
  }

}

class SelectTaxMapping{
  int TaxId;
  String TaxName;
  SelectTaxMapping({this.TaxId,this.TaxName});
}