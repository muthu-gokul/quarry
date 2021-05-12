import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/login.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/employeeNotifier.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:quarry/notifier/loginNotifier.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/reportsNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/homePage.dart';
import 'package:quarry/styles/app_theme.dart';

import 'notifier/goodsReceivedNotifier.dart';
import 'notifier/manageUsersNotifier.dart';
import 'notifier/paymentNotifier.dart';
import 'references/bottomNavi.dart';
import 'testing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuarryNotifier>(create:(_)=>QuarryNotifier()),
        ChangeNotifierProvider<LoginNotifier>(create:(_)=>LoginNotifier()),
        ChangeNotifierProvider<MaterialNotifier>(create:(_)=>MaterialNotifier()),
        ChangeNotifierProvider<VehicleNotifier>(create:(_)=>VehicleNotifier()),
        ChangeNotifierProvider<MachineNotifier>(create:(_)=>MachineNotifier()),
        ChangeNotifierProvider<CustomerNotifier>(create:(_)=>CustomerNotifier()),
        ChangeNotifierProvider<SupplierNotifier>(create:(_)=>SupplierNotifier()),
        ChangeNotifierProvider<PurchaseNotifier>(create:(_)=>PurchaseNotifier()),
        ChangeNotifierProvider<ProfileNotifier>(create:(_)=>ProfileNotifier()),
        ChangeNotifierProvider<ManageUsersNotifier>(create:(_)=>ManageUsersNotifier()),
        ChangeNotifierProvider<GoodsReceivedNotifier>(create:(_)=>GoodsReceivedNotifier()),
        ChangeNotifierProvider<ProductionNotifier>(create:(_)=>ProductionNotifier()),
        ChangeNotifierProvider<DieselNotifier>(create:(_)=>DieselNotifier()),
        ChangeNotifierProvider<DrawerNotifier>(create:(_)=>DrawerNotifier()),
        ChangeNotifierProvider<InvoiceNotifier>(create:(_)=>InvoiceNotifier()),
        ChangeNotifierProvider<PaymentNotifier>(create:(_)=>PaymentNotifier()),
        ChangeNotifierProvider<ReportsNotifier>(create:(_)=>ReportsNotifier()),
        ChangeNotifierProvider<EmployeeNotifier>(create:(_)=>EmployeeNotifier()),
      ],
      child: MaterialApp(
        title: 'Quarry Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        // home: MyHomePage(),
      ),
    );
  }
}

