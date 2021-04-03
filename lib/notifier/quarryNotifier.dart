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
import 'package:quarry/model/quarryLocModel.dart';
import 'package:quarry/model/saleModel.dart';
import 'package:quarry/model/vendorModel.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/alertDialog.dart';
import 'package:quarry/widgets/decimal.dart';
import 'package:quarry/widgets/printerService/printer/enums.dart';
import 'package:quarry/widgets/printerService/printer/network_printer.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/capability_profile.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/enums.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/pos_column.dart';
import 'package:quarry/widgets/printerService/printer/utils/src/pos_styles.dart';

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


  List<VehicleType> vehicleList=[];
  List<MaterialTypelist> sale_materialList=[];
  List<PaymentType> sale_paymentList=[];
  List<TaxDetails> material_TaxList=[];
  List<UnitDetails> material_UnitsList=[];

  initUserDetail(int userid,String name, String dbname,BuildContext context){
    UserId=userid;
    Name=name;
    DataBaseName=dbname;
    initDropDownValues(context);
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

  TextEditingController SS_vehicleNo= new TextEditingController();
  int SS_selectedVehicleTypeId;
  TextEditingController SS_emptyVehicleWeight= new TextEditingController();
  int SS_selectedMaterialTypeId=null;
  TextEditingController SS_customerNeedWeight= new TextEditingController(text: "0");
  TextEditingController SS_amount= new TextEditingController(text: '0.00');
  int SS_selectedPaymentTypeId=null;

  weightToAmount(){
    String materialPrice;
    if(SS_selectedMaterialTypeId!=null){

      if(SS_customerNeedWeight.text.isEmpty){
        SS_amount.text="0.00";
      }else{
        materialPrice=sale_materialList.where((element) => element.MaterialId==SS_selectedMaterialTypeId).toList()[0].MaterialUnitPrice.toString();
        SS_amount.text=(Decimal.parse(SS_customerNeedWeight.text)*Decimal.parse((materialPrice))).toString();
      }


      notifyListeners();
    }
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
    SS_emptyVehicleWeight.clear();
    SS_customerNeedWeight.clear();
    SS_Empty_ReqQtyUnit="";
    SS_amount.clear();
  }

  InsertSaleDetailDbhit(BuildContext context) async {

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
          "Key": "RequiredMaterialQty",
          "Type": "String",
          "Value": SS_customerNeedWeight.text
        },
        {
          "Key": "Amount",
          "Type": "String",
          "Value": SS_amount.text
        },

        {
          "Key": "RequiredQtyAmount",
          "Type": "String",
          "Value": SS_amount.text
        },
        {
          "Key": "PaymentCategoryId",
          "Type": "int",
          "Value": SS_selectedPaymentTypeId
        },
        {
          "Key": "DriverName",
          "Type": "String",
          "Value": ""
        },
        {
          "Key": "DriverContactNumber",
          "Type": "String",
          "Value":""
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
        CustomAlert().billSuccessAlert(context,"","Inward Receipt Successfully Saved","","");
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSaleDetail}" , e.toString());
    }
  }
  UpdateSaleDetailDbhit(BuildContext context) async {
    print("UPDATE SALE-$SS_selectCustomerId");
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
          "Key": "VehicleNumber",
          "Type": "String",
          "Value": SS_LoadedVehicleNo
        },
        {
          "Key": "VehicleTypeId",
          "Type": "int",
          "Value": SS_VehicleTypeId
        },
        {
          "Key": "SaleNumber",
          "Type": "int",
          "Value": SS_UpdateSaleNo
        },
        {
          "Key": "SaleId",
          "Type": "int",
          "Value": SS_UpdateSaleId
        },
        {
          "Key": "EmptyWeightOfVehicle",
          "Type": "String",
          "Value": SS_EmptyWeightOfVehicle
        },
        {
          "Key": "LoadWeightOfVehicle",
          "Type": "String",
          "Value": SS_DifferWeightController.text
        },
        {
          "Key": "MaterialId",
          "Type": "String",
          "Value": SS_MaterialTypeId
        },
        {
          "Key": "RequiredMaterialQty",
          "Type": "String",
          "Value": SS_RequiredMaterialQty
        },
        {
          "Key": "Amount",
          "Type": "String",
          "Value": SS_Amount
        },
        {
          "Key": "RequiredQtyAmount",
          "Type": "String",
          "Value":SS_Amount
        },
        {
          "Key": "OutputMaterialQty",
          "Type": "String",
          "Value": SS_UpdatecustomerNeedWeight
        },
        {
          "Key": "OutputQtyAmount",
          "Type": "String",
          "Value": SS_UpdateAmount
        },

        {
          "Key": "PaymentCategoryId",
          "Type": "int",
          "Value": SS_PaymentTypeId
        },
        {
          "Key": "DriverName",
          "Type": "String",
          "Value": ""
        },
        {
          "Key": "DriverContactNumber",
          "Type": "String",
          "Value":""
        },
        {
          "Key": "CustomerId",
          "Type": "int",
          "Value": SS_selectCustomerId
        },
        {
          "Key": "IsOutUpdate",
          "Type": "int",
          "Value": 1
        },
        {
          "Key": "SaleStatus",
          "Type": "String",
          "Value": "Closed"
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
        GetSaleDetailDbhit(context);
        CustomAlert().billSuccessAlert(context,"","Outward Receipt Successfully Saved","","");
      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.insertSaleDetail}" , e.toString());
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



    for(int i=0;i<printerList.length;i++){
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
          PosColumn(text: ' Sale No: ${sales[0]['SaleNumber']??""}', width: 6, styles: PosStyles(align: PosAlign.left,bold: true)),
          PosColumn(text: '${sales[0]['DateTime']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
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
        printer.row([
          PosColumn(text: 'Material Received: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(text: isEnter?'No / Yes':'Yes', width: 6, styles: PosStyles(align: PosAlign.right)),
        ]);

        printer.emptyLines(1);

        if(!isEnter){
          printer.row([
            PosColumn(text: 'SubTotal: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${sales[0]['OutputQtyAmount']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'GST (${sales[0]['TaxPercentage']??""}%): ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: '${sales[0]['TaxAmount']??""}', width: 6, styles: PosStyles(align: PosAlign.right)),
          ]);
          printer.emptyLines(1);
          printer.row([
            PosColumn(text: '', width: 1),
            // PosColumn(text: 'Total: ', width: 6, styles: PosStyles(align: PosAlign.right,bold: true)),
            PosColumn(text: 'Total: ${sales[0]['TotalAmount']??""}', width: 11,
                styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2)),
          ]);
          printer.emptyLines(1);
        }

        if(customer.isNotEmpty){
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Customer Details', width: 11, styles: PosStyles(align: PosAlign.center,bold: true,)),
          ]);
          printer.emptyLines(1);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Name: ${customer[0]['CustomerName']??""}', width: 11, styles: PosStyles(align: PosAlign.center)),

          ]);

          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Phone No: ${customer[0]['CustomerContactNumber']??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'Email: ${customer[0]['CustomerEmail']??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

          ]);
          Customervalues.forEach((key, value) {
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: '${value}', width: 11,styles: PosStyles(align: PosAlign.center)),

            ]);
          });
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: '${customer[0]['CustomerCity']??""} - ${customer[0]['CustomerZipCode']??""}', width: 11, styles: PosStyles(align: PosAlign.center,)),

          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: '${customer[0]['CustomerState']??""}.', width: 11, styles: PosStyles(align: PosAlign.center,)),

          ]);
          printer.row([
            PosColumn(text: '', width: 1),
            PosColumn(text: 'GST No: ${customer[0]['CustomerGSTNumber']??""}.', width: 11, styles: PosStyles(align: PosAlign.center,)),

          ]);
        }

        printer.feed(1);

        printer.cut();
        printer.disconnect();
        // CustomAlert().show(context, "Printed Successfully", 300);
      }
      else{
        // CustomAlert().show(context, "Printer Not Connected", 300);
      }
    }


  }



  List<SaleDetails> saleDetails=[];
  List<SaleDetails> saleDetailsGrid=[];
  List<String> saleVehicleNumberList=[];
  List<String> saleDetailsGridCol=['Vehicle Number','Material Type','Required Qty','Output Material Qty','Amount','Status'];
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

  String SS_DifferWeight;

  double SS_MaterialUnitPrice;
  String SS_UpdatecustomerNeedWeight;
  String SS_UpdateAmount;
  String msg="";
  String returnMoney="";

  Color returnColor;

  differWeight(){
    print("Fdf-$SS_MaterialUnitPrice");

    if(SS_DifferWeightController.text.isEmpty){
      print("EMPTY");
      msg="";
      returnMoney="";
      SS_UpdatecustomerNeedWeight=SS_RequiredMaterialQty;
      SS_UpdateAmount=SS_Amount.toString();
    }

   else if(double.parse(SS_TotalWeight)>double.parse(SS_DifferWeightController.text.toString())){
      SS_DifferWeight=(Decimal.parse(SS_TotalWeight)-Decimal.parse((SS_DifferWeightController.text))).toString();
      msg="Material Low ${SS_DifferWeight}. So You need to Return";
      returnMoney=(Decimal.parse(SS_MaterialUnitPrice.toString()??"0")*Decimal.parse((SS_DifferWeight))).toString();
      SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)-Decimal.parse(SS_DifferWeight)).toString();
      SS_UpdateAmount=(Decimal.parse(SS_Amount.toString())-Decimal.parse(returnMoney)).toString();
      returnColor=Colors.red;
      print("__________${double.parse(returnMoney.toString()) > SS_Amount}");
      notifyListeners();
    }
    else if(double.parse(SS_TotalWeight)<double.parse(SS_DifferWeightController.text.toString())){
      SS_DifferWeight=(Decimal.parse(SS_DifferWeightController.text)-Decimal.parse((SS_TotalWeight))).toString();
      msg="Material High ${SS_DifferWeight}. So Customer Need To Pay";
      returnMoney=(Decimal.parse(SS_MaterialUnitPrice.toString()??"0")*Decimal.parse((SS_DifferWeight))).toString();
      SS_UpdatecustomerNeedWeight=(Decimal.parse(SS_RequiredMaterialQty)+Decimal.parse(SS_DifferWeight)).toString();
      SS_UpdateAmount=(Decimal.parse(SS_Amount.toString())+Decimal.parse(returnMoney)).toString();
      returnColor=Colors.green;
      notifyListeners();
    }
    else{
      msg="";
      returnMoney="";
      SS_UpdatecustomerNeedWeight=SS_RequiredMaterialQty;
      SS_UpdateAmount=SS_Amount.toString();
    }
    print("UA-$SS_UpdateAmount");
    print("UQ-$SS_UpdatecustomerNeedWeight");
    notifyListeners();
  }


  GetSaleDetailDbhit(BuildContext context) async {
    print("GETSA");

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
        print(parsed);
        var t=parsed['Table'] as List;
        saleDetailsGrid=t.map((e) => SaleDetails.fromJson(e)).toList();
        saleDetails=saleDetailsGrid.where((element) => element.SaleStatus=='Open').toList();
        saleDetails.forEach((element) {
          saleVehicleNumberList.add(element.VehicleNumber);
        });
       print("SALE LEn-${saleDetailsGrid.length}");
       print("SALE LE-${saleDetails.length}");
       print("SALE LE-${saleVehicleNumberList.length}");
        //notifyListeners();
        clearLoaderForm();
        clearEmptyForm();
        updateInsertSaleLoader(false);

      });
    }
    catch(e){
      updateInsertSaleLoader(false);
      CustomAlert().commonErrorAlert(context, "USP_GetSaleDetail" , e.toString());
    }
  }


 clearLoaderForm(){

   SS_UpdateAmount="";
   SS_UpdatecustomerNeedWeight="";
   searchVehicleNo.clear();
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
    SS_Amount=0;

    SS_DifferWeight;

    SS_MaterialUnitPrice=0;

    msg="";
    returnMoney="";
  notifyListeners();
 }

  TabController tabController;
  initTabController(TickerProviderStateMixin tickerProviderStateMixin,BuildContext context){
    tabController=new TabController(length: 2, vsync: tickerProviderStateMixin);
    tabController.addListener(() {
      if(tabController.index==1){
       GetSaleDetailDbhit(context);


      }else if(tabController.index==0){
        GetCustomerDetailDbhit(context);
      }

    });
  }



  ///****************************************************      QUARRY DETAIL   / Company Detail    ****************************************************************/

  TextEditingController CD_quarryname= new TextEditingController();
  TextEditingController CD_contactNo= new TextEditingController();
  TextEditingController CD_address= new TextEditingController();
  TextEditingController CD_city= new TextEditingController();
  TextEditingController CD_state= new TextEditingController();
  TextEditingController CD_zipcode= new TextEditingController();
  TextEditingController CD_gstno= new TextEditingController();
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
        var parsed=json.decode(value);

        var t1=parsed['Table'] as List;

        CD_quarryname.text= t1[0]['CompanyName'];
        CD_contactNo.text= t1[0]['CompanyContactNumber'];
        CD_address.text= t1[0]['CompanyAddress'];
        CD_city.text= t1[0]['CompanyCity'];
        CD_state.text= t1[0]['CompanyState'];
        CD_zipcode.text= t1[0]['CompanyZipCode'];
        CD_gstno.text= t1[0]['CompanyGSTNumber'];
        CD_email.text= t1[0]['CompanyEmail'];
        CD_website.text= t1[0]['CompanyWebsite'];
        CompanyLogo= t1[0]['CompanyLogo'];
        CompanyLogoFolder= t1[0]['CompanyLogoFolderName']??"";
        //notifyListeners();

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
        var parsed=json.decode(value);

        print(parsed);
        //notifyListeners();

        updateInsertCompanyLoader(false);

      });
    }
    catch(e){
      updateInsertCompanyLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.dropDownValues}" , e.toString());
    }
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
        var parsed=json.decode(value);

        print(parsed);
        //notifyListeners();
        GetCustomerDetailDbhit(context);
        updatecustomerLoader(false);

      });
    }
    catch(e){
      updatecustomerLoader(false);
      CustomAlert().commonErrorAlert(context, "${Sp.dropDownValues}" , e.toString());
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