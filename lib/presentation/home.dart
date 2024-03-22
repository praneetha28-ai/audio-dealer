import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dealer/presentation/deliveredOrders.dart';
import 'package:dealer/presentation/receivedOrders.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eraser/eraser.dart';
import '../main.dart';
import '../orders_bloc/orders_bloc.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  NotchBottomBarController controller = NotchBottomBarController(index: 1);

  @override
  void initState(){
    super.initState();
    BlocProvider.of<OrdersBloc>(context).add(SummaryRequest());
    FirebaseMessaging.instance
        .subscribeToTopic("dealer")
        .whenComplete(() => print("Subscription successful"));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
        BlocProvider.of<OrdersBloc>(context).add(OrdersRequested("received"));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Eraser.clearAllAppNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc,OrdersState>(
        builder: (context,state){
          if(state is SummaryFetchSuccess){
            return Scaffold(
              backgroundColor: Color(0xffF6F6F6),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png",width:20,height:20),
                    SizedBox(width: 10,),
                    Text("Audio",style:
                                  GoogleFonts.montserrat(textStyle:TextStyle(
                      color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700)),),
                  ],
                ),),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          color: Color(0xff0ACF83),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                        height: 130,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment:MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Earnings",style: GoogleFonts.dmSans(
                                  textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20)),),
                              Text("\$ ${state.stats[0]}",style: GoogleFonts.dmSans(
                                  textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 24)))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Order Summary",style: GoogleFonts.dmSans(
                        textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w600)
                      ),),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xffBABABA)
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Recieved Orders",style: GoogleFonts.dmSans(
                                      textStyle:TextStyle(fontSize: 14,fontWeight: FontWeight.w600))),
                                  Text("${state.stats[1]}",style: GoogleFonts.dmSans(
                                      textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w600)))
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delivered Orders",style: GoogleFonts.dmSans(
                                      textStyle:TextStyle(fontSize: 14,fontWeight: FontWeight.w600))),
                                  Text("${state.stats[2]}",style: GoogleFonts.dmSans(
                                      textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w600)))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text("Top Clients",style: GoogleFonts.dmSans(
                          textStyle:TextStyle(fontSize: 22,fontWeight: FontWeight.w600))),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context,index){
                                return Container(
                            height: 75,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Color(0xff0ACF83))
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(state.stats[3][index]),
                                      Text((index+1).toString())
                                    ],
                                  ),
                                );
                                },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: AnimatedNotchBottomBar(
                color: Color(0xff0ACF83),
                onTap: (index){
                  print(index);
                  controller.jumpTo(index);
                  switch(index){
                    case 0: {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Received(title: "Received")));}
                    case 1:{Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage())); }
                    case 2:{Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Delivered(title: "Delivered"))); }
                  }
                },
                showTopRadius: true,
                showBottomRadius: true,
                bottomBarItems:[
                  BottomBarItem(
                    inActiveItem: Image.asset("assets/received.png",color: Colors.white,),
                    activeItem: Image.asset("assets/receivedPro.png"),),
                  BottomBarItem(inActiveItem: Icon(Icons.home_outlined,color: Colors.white,),
                      activeItem: Icon(Icons.home_filled,color: Color(0xff0ACF83),)),
                  BottomBarItem(
                    inActiveItem:Image.asset("assets/deliveredPro.png",color: Colors.white,),
                    activeItem: Image.asset("assets/delivered.png"),),
                ],
                notchBottomBarController: controller,
                kIconSize: 25,
                kBottomRadius: 10,
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(color: Color(0xff0ACF83),));
          }
        }

    );

  }
}
