import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notifier/employeeSalaryNotifier.dart';
import 'notifier/enployeeAdvanceLoanNotifier.dart';
import 'notifier/goodsReceivedNotifier.dart';
import 'notifier/machineManagementNotifier.dart';
import 'notifier/manageUsersNotifier.dart';
import 'notifier/paymentNotifier.dart';
import 'notifier/reportNotifier.dart';
import 'notifier/userAccessNotifier.dart';
import 'references/bottomNavi.dart';
import 'testing.dart';
/*

void main() {
  runApp(MyApp());
}
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false
  );
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);

    //GetUiNotifier().errorLog(error.toString(), stackTrace.toString());
  });
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
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
        ChangeNotifierProvider<UserAccessNotifier>(create:(_)=>UserAccessNotifier()),
      ],
      child: GetMaterialApp(
        title: 'Quarry Management',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
       // home: Sp(),

      ),
    );
  }
}



class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  init() async{
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await initializeFirebase();
    Get.off(LoginScreen());
  }


  Future<AndroidDeviceInfo?> _getDeviceInfoAndroid() async {
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo;
  }
  Future<IosDeviceInfo?> _getDeviceInfoIos() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo;
    }
  }

  deviceDetail() async{

    SharedPreferences sp=await SharedPreferences.getInstance();
    String deviceId=sp.getString("deviceId")??"";
    AndroidDeviceInfo? androidDeviceInfo;
   // bool isLoggedIn=sp.getBool(ISLOGGEDINKEY)??false;
    if(deviceId.isEmpty /*&& !isLoggedIn*/){
      if (Platform.isIOS){

      }
      else{
        androidDeviceInfo=await _getDeviceInfoAndroid();
      }
      deviceId = androidDeviceInfo!.androidId??"";
      sp.setString("deviceId", deviceId);
      sp.setString("deviceInfo", "${androidDeviceInfo.device}//${androidDeviceInfo.brand}//${androidDeviceInfo.id}//${androidDeviceInfo.version.toMap().toString()}");
    }
  }

  @override
  void initState() {
    init();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    deviceDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg',),
          fit: BoxFit.cover
        )
      ),


    );
  }
}









