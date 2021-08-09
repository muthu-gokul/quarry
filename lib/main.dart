import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quarry/login.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/dashboardNotifier.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/employeeAttendanceNotifier.dart';
import 'package:quarry/notifier/employeeNotifier.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:quarry/notifier/loginNotifier.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/homePage.dart';
import 'package:quarry/styles/app_theme.dart';

import 'notifier/employeeSalaryNotifier.dart';
import 'notifier/enployeeAdvanceLoanNotifier.dart';
import 'notifier/goodsReceivedNotifier.dart';
import 'notifier/machineManagementNotifier.dart';
import 'notifier/manageUsersNotifier.dart';
import 'notifier/paymentNotifier.dart';
import 'notifier/reportNotifier.dart';
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
        ChangeNotifierProvider<ReportNotifier>(create:(_)=>ReportNotifier()),
        ChangeNotifierProvider<EmployeeNotifier>(create:(_)=>EmployeeNotifier()),
        ChangeNotifierProvider<EmployeeAttendanceNotifier>(create:(_)=>EmployeeAttendanceNotifier()),
        ChangeNotifierProvider<EmployeeAdvanceLoanNotifier>(create:(_)=>EmployeeAdvanceLoanNotifier()),
        ChangeNotifierProvider<EmployeeSalaryNotifier>(create:(_)=>EmployeeSalaryNotifier()),
        ChangeNotifierProvider<MachineManagementNotifier>(create:(_)=>MachineManagementNotifier()),
        ChangeNotifierProvider<DashboardNotifier>(create:(_)=>DashboardNotifier()),
      ],
      child: MaterialApp(
        title: 'Quarry Management',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        // home: MyHomePage(),
      ),
    );
  }
}





/*import 'package:flutter/material.dart';

import 'widgets/circleBar@.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Animated Circle Progress"),
      ),
      body: Center(
        child: ProgressCard(),
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  double progressPercent = 0;

  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.red;

    if (progressPercent >= 0.8) {
      foreground = Colors.green;
    } else if (progressPercent >= 0.4) {
      foreground = Colors.orange;
    }

    Color background = foreground.withOpacity(0.2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CircleProgressBar(
                backgroundColor: background,
                foregroundColor: foreground,
                value: this.progressPercent,
              ),
              onTap: () {
                final updated = ((this.progressPercent + 0.1).clamp(0.0, 1.0) *
                    100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
              onDoubleTap: () {
                final updated = ((this.progressPercent - 0.1).clamp(0.0, 1.0) *
                    100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
            ),
          ),
        ),
        Text("${this.progressPercent * 100}%"),
      ],
    );
  }
}*/




