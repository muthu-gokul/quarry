
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/login.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/employeeAttendanceNotifier.dart';
import 'package:quarry/notifier/employeeNotifier.dart';
import 'package:quarry/notifier/employeeSalaryNotifier.dart';
import 'package:quarry/notifier/enployeeAdvanceLoanNotifier.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:quarry/notifier/machineManagementNotifier.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/reportNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/employee/employeeAttendance/employeeAttendanceGrid.dart';
import 'package:quarry/pages/goodsReceived/goodsReceivedGrid.dart';
import 'package:quarry/pages/invoice/invoiceGrid.dart';
import 'package:quarry/pages/invoicePayment/paymentGrid.dart';
import 'package:quarry/pages/productionDetails/productionDetailsGrid.dart';
import 'package:quarry/pages/purchaseDetails/purchaseGrid.dart';
import 'package:quarry/pages/supplierDetail/supplierGrid.dart';
import 'package:quarry/pages/users/profile.dart';
import 'package:quarry/pages/vehicleDetail/vehicleDetailsGrid.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:quarry/widgets/animation/fadeanimation.dart';
import '../styles/size.dart';
import 'customerDetails/customerGrid.dart';
import 'dashboard/dashboardHome.dart';
import 'dieselManagement/dieselGrid.dart';
import 'employee/employeeAdvanceLoan/employeeAdvanceLoanGrid.dart';
import 'employee/employeeMaster/employeeMasterGrid.dart';
import 'employee/employeeSalary/employeeSalaryGrid.dart';
import 'machineDetails/machineDetailsGrid.dart';
import 'machineManagement/machineManagementGrid.dart';
import 'materialDetails/materialDetailsGrid.dart';
import 'quarryMaster/quarryLocationAddNew.dart';
import 'reports/reportGrid.dart';
import 'sale/saleGrid.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  var inn;




  bool isSettingsOpen=false;


  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    inn=Provider.of<QuarryNotifier>(context,listen: false);
    SizeConfig().init(context);
    return Consumer<DrawerNotifier>(
      builder:(context,drawer,i)=> Scaffold(
          key: scaffoldkey,
          drawer: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Drawer(

              child:Container(
                decoration: BoxDecoration(
                    color:Color(0xff3B3B3D),
                  image: DecorationImage(
                    image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                    fit: BoxFit.cover
                  )
                ),


                child: Column(
                  children: [
                    Consumer<ProfileNotifier>(
                      builder: (context,pn,child)=> Container(
                        width: double.infinity,
                        height: 210,
                     //   margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                                  onPressed: (){
                                    scaffoldkey.currentState.openEndDrawer();
                                  }),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  drawer.menuSelected=10;
                                  scaffoldkey.currentState.openEndDrawer();
                                });
                                Provider.of<ProfileNotifier>(context, listen: false).GetUserDetailDbHit(context,Provider.of<QuarryNotifier>(context,listen: false).UserId);
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.yellowColor,

                                ),
                                child: Center(
                                  child: Image.asset("assets/svg/drawer/avatar.png"),
                                ),

                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("${pn.selectedSalutation}.${pn.firstName.text}${pn.lastName.text}",
                              style: AppTheme.TSWhite16,
                            ),
                            SizedBox(height: 6,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppTheme.yellowColor
                              ),
                              child: Text("${pn.UserGroupName}",
                                style: TextStyle(fontFamily: 'RR',color: AppTheme.bgColor,fontSize: 12),
                              ),
                            ),
                            /*  Container(
                              child: Row(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Image.asset("assets/drawerImages/close-btn.png",width: 50,height: 50,),
                                  // ),
                                  SizedBox(width: SizeConfig.width20,),
                                  SvgPicture.asset("assets/images/slide-logo.svg",height: 50,width: 250,)
                                ],
                              ),
                              //  decoration: BoxDecoration
                              //    shape: BoxShape.
                              // ),
                            ),*/
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: SizeConfig.screenHeight-210,
                      child: Column(
                        children: [
                          Container(
                            height: (SizeConfig.screenHeight-255),
                            child: ListView(
                              children: [
                                SizedBox(height: 20,),
                                DrawerContent(
                                  delay: 0.1,
                                  height: 50,
                                  image: "assets/svg/drawer/dashboard.svg",
                                  title: 'Dashboard',
                                  tag: 'Dashboard',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=22;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                  },
                                ),
                                DrawerContent(
                                  delay:1,
                                  height: 50,
                                  image: "assets/svg/drawer/sales-form.svg",
                                  title: 'Sales',
                                  tag: 'SaleDetail',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    Navigator.pop(context);
                                    setState(() {
                                      drawer.menuSelected=4;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });


                                    // Provider.of<QuarryNotifier>(context,listen: false).initDropDownValues(context);
                                    Provider.of<QuarryNotifier>(context,listen: false).GetCustomerDetailDbhit(context);
                                    Provider.of<QuarryNotifier>(context,listen: false).GetSaleDetailDbhit(context);
                                    Provider.of<QuarryNotifier>(context,listen: false).SalesDropDownValues(context);
                                  },
                                ),
                                DrawerContent(
                                  delay: 1.5,
                                  height: 50,
                                  image:  "assets/svg/drawer/purchase.svg",
                                  title: 'Purchase',
                                  tag: 'PurchaseDetail',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=9;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                    Provider.of<PurchaseNotifier>(context, listen: false).UserDropDownValues(context);
                                    Provider.of<PurchaseNotifier>(context, listen: false).GetPurchaseDbHit(context,null);

                                  },
                                ),
                                DrawerContent(
                                  delay: 2,
                                  height: 50,
                                  image:  "assets/svg/drawer/goodsReceived.svg",
                                  title: 'Goods Received',
                                  tag: 'GoodsReceived',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=11;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                    Provider.of<GoodsReceivedNotifier>(context, listen: false).GetGoodsDbHit(context,null,null,false,this);

                                  },
                                ),
                                DrawerContent(
                                  delay: 2.5,
                                  height: 50,
                                  image:  "assets/svg/drawer/production.svg",
                                  title: 'Production',
                                  tag: 'ProductionDetail',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=12;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });

                                    Provider.of<ProductionNotifier>(context, listen: false).GetProductionDbHit(context,null,this);
                                  },
                                ),


                                DrawerContent(
                                  delay: 3,
                                  height: 50,
                                  image: "assets/svg/drawer/diesel-mangement.svg",
                                  title: 'Diesel Management',
                                  tag: 'DieselManagement',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=13;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                    Provider.of<DieselNotifier>(context, listen: false).GetDieselPurchaseDbHit(context,null);

                                  },
                                ),
                                DrawerContent(
                                  delay: 3.5,
                                  height: 50,
                                  image:  "assets/svg/drawer/employee/employeeDetail.svg",
                                  title: 'Employee Details',
                                  tag: "EmployeeDetails",
                                  titleColor: AppTheme.yellowColor,
                                  isRightArrow: true,
                                  callback: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeDetails(voidCallback: (){
                                      scaffoldkey.currentState.openEndDrawer();
                                   },)));
                                  },
                                ),
                                DrawerContent(
                                  delay: 3.5,
                                  height: 50,
                                  image:  "assets/svg/drawer/machineManagement.svg",
                                  title: 'Machine Management',
                                  tag: "MachineManagement",
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=21;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                    Provider.of<MachineManagementNotifier>(context, listen: false).GetMachineManagementDbHit(context,null,null);
                                  },
                                ),

                                DrawerContent(
                                  delay: 3.5,
                                  height: 50,
                                  image:  "assets/svg/drawer/accounts.svg",
                                  title: 'Accounts',
                                  tag: "Accounts",
                                  isRightArrow: true,
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountsPage(voidCallback: (){
                                      scaffoldkey.currentState.openEndDrawer();
                                    },)));
                                  },
                                ),
                                DrawerContent(
                                  delay:4,
                                  height: 50,
                                  image:  "assets/svg/drawer/reports.svg",
                                  title: 'Reports',
                                  tag: "Reports",
                                  isRightArrow: true,
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportsPage(voidCallback: (){
                                      scaffoldkey.currentState.openEndDrawer();
                                    },)));
                                  },
                                ),

                                DrawerContent(
                                  delay: 4.5,
                                  height: 50,
                                  image: "assets/svg/drawer/settings-icon.svg",
                                  title: 'Settings',
                                  tag: "Settings",
                                  isRightArrow: true,
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage(voidCallback: (){
                                      scaffoldkey.currentState.openEndDrawer();
                                    },)));
                                  },

                                ),



                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.only(bottom: 45,top: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.yellowColor
                              ),
                              child: SvgPicture.asset("assets/svg/drawer/logout.svg",width: 20,height: 20,),
                            ),
                          )





                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          body: drawer.menuSelected==1?QuaryAddNew(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==2?MaterialDetailsGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==4?SaleGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==5?CustomerMaster(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==6?MachineDetailsGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==7?VehicleDetailsGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==8?SupplierDetailsGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==9?PurchaseDetailsGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==10?ProfileScreen(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==11?GoodsReceivedGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==12?ProductionGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==13?DieselGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==14?InvoiceGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==15?PaymentGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==16?ReportGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==17?EmployeeMasterGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==18?EmployeeAttendanceGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==19?EmployeeAdvanceLoanGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==20?EmployeeSalaryGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==21?MachineManagementGrid(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          drawer.menuSelected==22?DashBoardHome(drawerCallback: (){
            scaffoldkey.currentState.openDrawer();
          },):
          Container()
      ),
    );
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0,0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}

class DrawerContent extends StatelessWidget {

  VoidCallback callback;
  String image;
  String title;
  String tag;
  double height;
  Color titleColor;
  double delay;
  bool isRightArrow;

  DrawerContent({this.callback,this.title,this.image,this.height,this.titleColor,this.delay,this.tag,this.isRightArrow=false});

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay, GestureDetector(
      onTap: callback,
      child: Container(
        height: height,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          width: 230,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(

                  tag: tag,
                  child: SvgPicture.asset(image,width: 30,)),
              SizedBox(width: 10,),
              Container(
                height: 20,
                width: 190,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(title, style: TextStyle(fontSize: 16,color:titleColor, fontFamily:'RR'),)
                    ),
                    SizedBox(width: isRightArrow? 5:0,),
                    isRightArrow?Icon(Icons.arrow_forward_ios_rounded,color: AppTheme.yellowColor,size: 15,):Container()
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    ),
    );
  }
}


class DrawerNotifier extends ChangeNotifier{
  int menuSelected=1;
  Future<dynamic> changeMenu(int index) async{
    menuSelected=index;
    notifyListeners();
  }
}

class EmployeeDetails extends StatefulWidget {

  VoidCallback voidCallback;
  EmployeeDetails({this.voidCallback});

  @override
  EmployeeDetailsState createState() => EmployeeDetailsState();
}
class EmployeeDetailsState extends State<EmployeeDetails> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                fit: BoxFit.cover
            )
        ),
        child:  Column(
          children: [

            Container(
              height: SizeConfig.screenHeight-45,
              width: SizeConfig.screenWidth,


              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                        onPressed: (){
                          Navigator.pop(context);
                        }),
                  ),

                  Hero(
                    transitionOnUserGestures: true,
                    tag: "EmployeeDetails",
                    child:SvgPicture.asset("assets/svg/drawer/employee/employeeDetail.svg",width: 100,height: 100,),
                  ),

                  SizedBox(height: 20,),

                  DrawerContent(
                    delay: 0.1,
                    height: 50,
                    image: "assets/svg/drawer/myprofile.svg",
                    title: 'Employee Master',
                    tag: 'EmployeeMaster',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(17);
                      Provider.of<EmployeeNotifier>(context, listen: false).GetEmployeeIssueDbHit(context,null);
                    },
                  ),

                  DrawerContent(
                    delay:1,
                    height: 50,
                    image: "assets/svg/drawer/employee/employeeAttendance.svg",
                    title: 'Employee Attendance',
                    tag: 'EmployeeAttendance',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(18);
                      Provider.of<EmployeeAttendanceNotifier>(context, listen: false).GetEmployeeAttendanceIssueDbHit(context,null);


                    },
                  ),

                  DrawerContent(
                    delay: 1.5,
                    height: 50,
                    image: "assets/svg/drawer/employee/employeeAdvance.svg",
                    title: 'Employee Advance',
                    tag: 'EmployeeAdvance',
                    titleColor: AppTheme.yellowColor,
                    callback: (){

                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(19);
                      Provider.of<EmployeeAdvanceLoanNotifier>(context, listen: false).GetEmployeeAttendanceLoanDbHit(context,null);


                    },
                  ),
                  DrawerContent(
                    delay: 2,
                    height: 50,
                    image: "assets/svg/drawer/employee/employeeSalary.svg",
                    title: 'Employee Salary',
                    tag: 'EmployeeSalary',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(20);

                        Provider.of<EmployeeSalaryNotifier>(context,listen: false).GetEmployeeSalaryDbHit(context,null);
                      ///  Provider.of<ReportsNotifier>(context,listen: false).ReportsDbHit(context,"CustomerSaleReport");

                    },
                  ),


                ],
              ),
            ),




            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.only(bottom: 45,top: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.yellowColor
                  ),
                  child:SvgPicture.asset("assets/svg/drawer/back-icon.svg",color: Colors.black,width: 20,height: 20,)
              ),
            )
          ],
        ),
      ),


    );
  }
}

class AccountsPage extends StatefulWidget {

  VoidCallback voidCallback;
  AccountsPage({this.voidCallback});

  @override
  AccountsPageState createState() => AccountsPageState();
}
class AccountsPageState extends State<AccountsPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                fit: BoxFit.cover
            )
        ),
        child:  Column(
          children: [

            Container(
              height: SizeConfig.screenHeight-45,
              width: SizeConfig.screenWidth,

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                        onPressed: (){
                          Navigator.pop(context);
                        }),
                  ),

                  Hero(
                    transitionOnUserGestures: true,
                    tag: "Accounts",
                    child:SvgPicture.asset("assets/svg/drawer/accounts.svg",width: 100,height: 100,),
                  ),

                  SizedBox(height: 20,),
                  DrawerContent(
                    delay: 1,
                    height: 50,
                    image: "assets/svg/drawer/invoice.svg",
                    title: 'Invoice',
                    tag: 'Invoice',
                    titleColor: AppTheme.yellowColor,
                    callback: (){

                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(14);
                      Provider.of<InvoiceNotifier>(context, listen: false).GetInvoiceDbHit(context,null);
                    },
                  ),
                  DrawerContent(
                    delay: 1.5,
                    height: 50,
                    image: "assets/svg/drawer/payment.svg",
                    title: 'Payment',
                    tag: 'Payment',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(15);
                      Provider.of<PaymentNotifier>(context, listen: false).updatePaymentReceivable(true);
                      Provider.of<PaymentNotifier>(context, listen: false).GetPaymentDbHit(context,null,this);
                    },
                  ),




                ],
              ),
            ),




            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.only(bottom: 45,top: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.yellowColor
                  ),
                  child:SvgPicture.asset("assets/svg/drawer/back-icon.svg",color: Colors.black,width: 20,height: 20,)
              ),
            )
          ],
        ),
      ),


    );
  }
}

class ReportsPage extends StatefulWidget {

  VoidCallback voidCallback;
  ReportsPage({this.voidCallback});

  @override
  ReportsPageState createState() => ReportsPageState();
}
class ReportsPageState extends State<ReportsPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                fit: BoxFit.cover
            )
        ),
        child:  Column(
          children: [



            Container(
              height: SizeConfig.screenHeight-45,
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                          onPressed: (){
                            Navigator.pop(context);
                          }),
                    ),

                    Hero(
                      transitionOnUserGestures: true,
                      tag: "Reports",
                      child:SvgPicture.asset("assets/svg/drawer/reports.svg",width: 100,height: 100,),
                    ),

                    SizedBox(height: 20,),

                    DrawerContent(
                      delay: 0.1,
                      height: 50,
                      image: "assets/svg/drawer/sales-form.svg",
                      title: 'Sales Report',
                      tag: 'SalesReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){

                        Navigator.pop(context);
                        widget.voidCallback();


                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16).then((value){

                        });
                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"SaleReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"SaleReport");
                        });

                      },
                    ),

                    DrawerContent(
                      delay: 0.1,
                      height: 50,
                      image: "assets/svg/drawer/sales-form.svg",
                      title: 'Stock Report',
                      tag: 'StockReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);
                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"StockReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"StockReport");
                        });

                      },
                    ),

                    DrawerContent(
                      delay:1,
                      height: 50,
                      image: "assets/svg/drawer/purchase.svg",
                      title: 'Purchase Report',
                      tag: 'PurchaseReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"PurchaseReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"PurchaseReport");
                        });


                      },
                    ),

                    DrawerContent(
                      delay: 1.5,
                      height: 50,
                      image: "assets/svg/drawer/settings/customer.svg",
                      title: 'Customer Sale Report',
                      tag: 'CustomerSalesReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"CustomerSaleReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"CustomerSaleReport");
                        });


                      },
                    ),
                    DrawerContent(
                      delay: 1.5,
                      height: 50,
                      image: "assets/svg/drawer/settings/supplier.svg",
                      title: 'Supplier Purchase Report',
                      tag: 'SupplierPurchaseReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"SupplierPurchaseReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"SupplierPurchaseReport");
                        });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/production.svg",
                      title: 'Production Report',
                      tag: 'ProductionReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"ProductionReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"ProductionReport");
                        });


                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/invoice.svg",
                      title: 'Invoice Report',
                      tag: 'InvoiceReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                           Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                          Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"InvoiceReport").then((value) {
                            Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"InvoiceReport");
                          });


                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/receivablePayment.svg",
                      title: 'Receivable Payment Report',
                      tag: 'ReceivablePaymentReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                       Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);
                       Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"ReceivablePaymentReport").then((value) {
                         Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"ReceivablePaymentReport");
                       });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/payablePayment.svg",
                      title: 'Payable Payment Report',
                      tag: 'PayablePaymentReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);
                         Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"PayablePaymentReport").then((value){
                           Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"PayablePaymentReport");
                         });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/employee/employeeDetail.svg",
                      title: 'Employee Report',
                      tag: 'EmployeeReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);
                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"EmployeeReport").then((value){
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"EmployeeReport");
                        });


                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/employee/employeeAttendance.svg",
                      title: 'Attendance Report',
                      tag: 'AttendanceReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();
                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);
                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"AttendanceReport").then((value){
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"AttendanceReport");
                        });
                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/dieselIn.svg",
                      title: 'Diesel In Report',
                      tag: 'DieselInReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                         Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"DieselPurchaseReport").then((value) {
                           Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"DieselPurchaseReport");

                         });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/dieselOut.svg",
                      title: 'Diesel Out Report',
                      tag: 'DieselOutReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"DieselIssueReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"DieselIssueReport");

                        });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/vehicleMonitoring.svg",
                      title: 'Vehicle Monitoring Report',
                      tag: 'VehicleMonitoringReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                        Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"VehicleMonitoringReport").then((value) {
                          Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"VehicleMonitoringReport");

                        });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/machineManagement.svg",
                      title: 'Machine Maintenance Report',
                      tag: 'MachineMaintenanceReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                         Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"MachineManagementReport").then((value){
                           Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"MachineManagementReport");
                         });


                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/saleAudit.svg",
                      title: 'Sales Audit Report',
                      tag: 'SalesAuditReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                        Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                         Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"SaleAuditReport").then((value) {
                           Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"SaleAuditReport");

                         });

                      },
                    ),
                    DrawerContent(
                      delay: 2,
                      height: 50,
                      image: "assets/svg/drawer/reports/purchaseAudit.svg",
                      title: 'Purchase Audit Report',
                      tag: 'PurchaseAuditReport',
                      titleColor: AppTheme.yellowColor,
                      callback: (){
                        Navigator.pop(context);
                        widget.voidCallback();

                       Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                      Provider.of<ReportNotifier>(context,listen: false).ReportsDropDownValues(context,"PurchaseAuditReport").then((value){
                        Provider.of<ReportNotifier>(context,listen: false).ReportsDbHit(context,"PurchaseAuditReport");

                      });

                      },
                    ),


                  ],
                ),
              ),
            ),


            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 80,
                width: 80,
               padding: EdgeInsets.only(bottom: 45,top: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellowColor
                ),
                child:SvgPicture.asset("assets/svg/drawer/back-icon.svg",color: Colors.black,width: 20,height: 20,)
              ),
            )
          ],
        ),
      ),


    );
  }
}

class SettingsPage extends StatefulWidget {

  VoidCallback voidCallback;
  SettingsPage({this.voidCallback});

  @override
  SettingsPageState createState() => SettingsPageState();
}
class SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
                fit: BoxFit.cover
            )
        ),
        alignment: Alignment.center,
        child:  Column(
          children: [

            Container(
              height: SizeConfig.screenHeight-45,
              width: SizeConfig.screenWidth,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                        onPressed: (){
                          Navigator.pop(context);
                        }),
                  ),

                  Hero(
                    transitionOnUserGestures: true,
                    tag: "Settings",
                    child:SvgPicture.asset("assets/svg/drawer/settings-icon.svg",width: 100,height: 100,),
                  ),
                  SizedBox(height: 20,),
                  DrawerContent(
                    delay: 0.1,
                    height: 50,
                    image: "assets/svg/drawer/settings/company.svg",
                    title: 'Company Detail',
                    tag: 'Company',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(1);
                      Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);
                      Provider.of<QuarryNotifier>(context,listen: false).GetplantDetailDbhit(context,null,this);
                    },
                  ),


                  DrawerContent(
                    delay: 1.5,
                    height: 50,
                    image: "assets/svg/drawer/settings/customer.svg",
                    title: 'Customer Detail',
                    tag: 'CustomeDetail',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(5);

                      Provider.of<CustomerNotifier>(context,listen: false).GetCustomerDetailDbhit(context,null);

                    },
                  ),

                  DrawerContent(
                    delay: 2,
                    height: 50,
                    image: "assets/svg/drawer/settings/material.svg",
                    title: 'Material Detail',
                    tag: 'Material',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(2);

                      Provider.of<MaterialNotifier>(context,listen: false).GetMaterialDbHit(context,null);
                    },
                  ),
                  DrawerContent(
                    delay: 2.5,
                    height: 50,
                    image: "assets/svg/drawer/machineManagement.svg",
                    title: 'Machine Detail',
                    tag: 'Machine',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(6);

                      Provider.of<MachineNotifier>(context,listen: false).GetMachineDbHit(context,null);

                    },
                  ),
                  DrawerContent(
                    delay: 3,
                    height: 50,
                    image: "assets/svg/drawer/settings/vehicle.svg",
                    title: 'Vehicle Detail',
                    tag: 'Vehicle',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(7);

                      Provider.of<VehicleNotifier>(context, listen: false).GetVehicleDbHit(context,null);

                    },
                  ),
                  DrawerContent(
                    delay: 3.5,
                    height: 50,
                    image: "assets/svg/drawer/settings/supplier.svg",
                    title: 'Supplier Detail',
                    tag: 'Supplier',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();
                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(8);

                      Provider.of<SupplierNotifier>(context, listen: false).GetSupplierDbHit(context,null,this);
                    },
                  ),
                ],
              ),
            ),




            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.only(bottom: 45,top: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.yellowColor
                  ),
                  child:SvgPicture.asset("assets/svg/drawer/back-icon.svg",color: Colors.black,width: 20,height: 20,)
              ),
            )
          ],
        ),
      ),


    );
  }
}








class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}