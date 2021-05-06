import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quarry/model/goodsReceivedModel/goodsReceivedGridModel.dart';
import 'package:quarry/notifier/customerNotifier.dart';
import 'package:quarry/notifier/dieselNotifier.dart';
import 'package:quarry/notifier/goodsReceivedNotifier.dart';
import 'package:quarry/notifier/invoiceNotifier.dart';
import 'package:quarry/notifier/machineNotifier.dart';
import 'package:quarry/notifier/materialNotifier.dart';
import 'package:quarry/notifier/paymentNotifier.dart';
import 'package:quarry/notifier/productionNotifier.dart';
import 'package:quarry/notifier/profileNotifier.dart';
import 'package:quarry/notifier/purchaseNotifier.dart';
import 'package:quarry/notifier/quarryNotifier.dart';
import 'package:quarry/notifier/reportsNotifier.dart';
import 'package:quarry/notifier/supplierNotifier.dart';
import 'package:quarry/notifier/vehicleNotifier.dart';
import 'package:quarry/pages/goodsReceived/goodsReceivedGrid.dart';
import 'package:quarry/pages/invoice/invoiceGrid.dart';
import 'package:quarry/pages/invoicePayment/paymentGrid.dart';
import 'package:quarry/pages/productionDetails/productionDetailsGrid.dart';
import 'package:quarry/pages/purchaseDetails/purchaseGrid.dart';
import 'package:quarry/pages/quarryMaster/quarryMaster.dart';
import 'package:quarry/pages/sale/salesDetail.dart';
import 'package:quarry/pages/supplierDetail/supplierGrid.dart';
import 'package:quarry/pages/users/profile.dart';
import 'package:quarry/pages/vehicleDetail/vehicleDetailsGrid.dart';
import 'package:quarry/pages/vendor/vendorMaster.dart';
import 'package:quarry/styles/app_theme.dart';
import 'package:quarry/styles/size.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quarry/widgets/animation/fadeanimation.dart';
import 'package:quarry/widgets/reportpdf.dart';
import '../styles/size.dart';
import 'customerDetails/customerGrid.dart';
import 'dieselManagement/dieselGrid.dart';
import 'machineDetails/machineDetailsAddNew.dart';
import 'machineDetails/machineDetailsGrid.dart';
import 'material/MaterialMasterGrid.dart';
import 'material/processAddNew.dart';
import 'material/processMaterialsList.dart';
import 'material/processStoneList.dart';
import 'materialDetails/materialDetailsGrid.dart';
import 'productionDetails/productionDetailsAddNew.dart';
import 'qLocMaterials.dart';
import 'qLocPAyment.dart';
import 'quarryMaster/quarryLocationAddNew.dart';
import 'reports/salesReport/salesReportGrid.dart';
import 'sale/saleAddNew.dart';
import 'sale/saleGrid.dart';
import 'vendor/vendorLocAddNew.dart';



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
                color:Color(0xff3B3B3D),

                child: Column(
                  children: [
                    Consumer<ProfileNotifier>(
                      builder: (context,pn,child)=> Container(
                        width: double.infinity,
                        height: 210,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(icon: Icon(Icons.clear_outlined,size: 25,color: AppTheme.yellowColor,),
                                  onPressed: (){
                                    scaffoldkey.currentState.openEndDrawer();
                                  }),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yellowColor,

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
                                DrawerContent(
                                  delay: 0.1,
                                  height: 50,
                                  image: "assets/drawerImages/dashboard.png",
                                  title: 'My Profile',
                                  tag: 'MyProfile',
                                  titleColor: AppTheme.yellowColor,
                                  callback: (){
                                    setState(() {
                                      drawer.menuSelected=10;
                                      scaffoldkey.currentState.openEndDrawer();
                                    });
                                    Provider.of<ProfileNotifier>(context, listen: false).GetUserDetailDbHit(context,Provider.of<QuarryNotifier>(context,listen: false).UserId);
                                  },
                                ),
                                DrawerContent(
                                  delay:1,
                                  height: 50,
                                  image: "assets/drawerImages/dashboard.png",
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
                                  image: "assets/drawerImages/dashboard.png",
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
                                  image: "assets/drawerImages/dashboard.png",
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
                                  delay: 2.5,
                                  height: 50,
                                  image: "assets/drawerImages/dashboard.png",
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
                                  delay: 3,
                                  height: 50,
                                  image: "assets/drawerImages/dashboard.png",
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
                                  image: "assets/drawerImages/dashboard.png",
                                  title: 'Accounts',
                                  tag: "Accounts",
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
                                  image: "assets/drawerImages/dashboard.png",
                                  title: 'Reports',
                                  tag: "Reports",
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
                                  image: "assets/drawerImages/dashboard.png",
                                  title: 'Settings',
                                  tag: "Settings",
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

                          Container(
                            height: 80,
                            width: 80,
                            padding: EdgeInsets.only(bottom: 40),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yellowColor
                            ),
                            child: Icon(Icons.power_settings_new_outlined,color: AppTheme.bgColor,),
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
          drawer.menuSelected==3?VendorMaster(drawerCallback: (){
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

          drawer.menuSelected==16?SalesReportGrid(drawerCallback: (){
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

  DrawerContent({this.callback,this.title,this.image,this.height,this.titleColor,this.delay,this.tag});

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
          width: 210,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(

                  tag: tag,
                  child: SvgPicture.asset("assets/svg/settings-icon.svg",width: 30)),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(fontSize: 16,color:titleColor, fontFamily:'RR'),),
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
  changeMenu(int index){
    menuSelected=index;
    notifyListeners();
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
        color: AppTheme.bgColor,
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
                    child:SvgPicture.asset("assets/svg/settings-icon.svg",width: 100,height: 100,),
                  ),

                  DrawerContent(
                    delay: 0.1,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
                    title: 'Company Detail',
                    tag: 'Company',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(1);
                      Provider.of<QuarryNotifier>(context,listen: false).GetQuarryDetailDbhit(context);
                      Provider.of<QuarryNotifier>(context,listen: false).GetplantDetailDbhit(context,null);
                    },
                  ),


                  DrawerContent(
                    delay: 1.5,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
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
                    image: "assets/drawerImages/dashboard.png",
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
                    image: "assets/drawerImages/dashboard.png",
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
                    image: "assets/drawerImages/dashboard.png",
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
                    image: "assets/drawerImages/dashboard.png",
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
                padding: EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellowColor
                ),
                child: Icon(Icons.arrow_back,color: AppTheme.bgColor,),
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
        color: AppTheme.bgColor,
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
                    tag: "Reports",
                    child:SvgPicture.asset("assets/svg/settings-icon.svg",width: 100,height: 100,),
                  ),

                  DrawerContent(
                    delay: 0.1,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
                    title: 'Sales Report',
                    tag: 'SalesReport',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                      Provider.of<DrawerNotifier>(context,listen: false).changeMenu(16);

                      Provider.of<ReportsNotifier>(context,listen: false).ReportsDropDownValues(context,"SaleReport");
                      //Provider.of<QuarryNotifier>(context,listen: false).GetplantDetailDbhit(context,null);
                    },
                  ),

                  DrawerContent(
                    delay:1,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
                    title: 'Purchase Report',
                    tag: 'PurchaseReport',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();

                    },
                  ),

                  DrawerContent(
                    delay: 1.5,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
                    title: 'Customer Sales Report',
                    tag: 'CustomerSalesReport',
                    titleColor: AppTheme.yellowColor,
                    callback: (){
                      Navigator.pop(context);
                      widget.voidCallback();


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
                padding: EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellowColor
                ),
                child: Icon(Icons.arrow_back,color: AppTheme.bgColor,),
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
        color: AppTheme.bgColor,
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
                    child:SvgPicture.asset("assets/svg/settings-icon.svg",width: 100,height: 100,),
                  ),


                  DrawerContent(
                    delay: 1,
                    height: 50,
                    image: "assets/drawerImages/dashboard.png",
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
                    image: "assets/drawerImages/dashboard.png",
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
                padding: EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.yellowColor
                ),
                child: Icon(Icons.arrow_back,color: AppTheme.bgColor,),
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