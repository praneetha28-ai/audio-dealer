import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dealer/presentation/deliveredOrders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'home.dart';
import '../main.dart';
import '../orders_bloc/orders_bloc.dart';

class Received extends StatefulWidget {
  const Received({super.key, required this.title});
  final String title;

  @override
  State<Received> createState() => _ReceivedState();
}

class _ReceivedState extends State<Received> {
  NotchBottomBarController controller = NotchBottomBarController(index: 0);
  @override
  void initState(){
    super.initState();
    BlocProvider.of<OrdersBloc>(context).add(OrdersRequested("received"));
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
    required String id,
  }) async {
    // await FirebaseMessaging.instance.subscribeToTopic(year).whenComplete(() => print("subscribed"));

    String dataNotifications = '{ '
        ' "to" : "/topics/$id" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
        )
      ),
      body:BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if(state is OrdersFetched) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                if (state.data.isEmpty) {
                  return Center(
                    child: Text("No data"),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var key in state.data[index].keys)
                        Container(
                          margin: EdgeInsets.all(8),
                          color: Color(0xffF6F6F6),
                          height: state.data[index][key].length==0?150:250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  key.toString(),
                                  style:GoogleFonts.dmSans(
                                      textStyle:TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16)
                                  )
                              ),
                              SizedBox(height: 10),
                              state.data[index][key].length==0?
                              Center(
                                child: Column(
                                  children: [
                                    Text("No orders left"),
                                    SizedBox(height: 15,),
                                    Image.asset("assets/done.png")
                                  ],
                                ),
                              ):
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: state.data[index][key].length,
                                  itemBuilder: (context, subIndex) {
                                    print(state.data[index][key].length);
                                    var details = state.data[index][key][subIndex];
                                    return
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white60,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.all(8),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width/2,
                                                child: Text("${details["prod_name"]}",
                                                  style: GoogleFonts.dmSans(textStyle:TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400)),),
                                              ),
                                              Text("Price   ${details["prod_price"]}",
                                                style: GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff0ACF83),fontSize: 18,fontWeight: FontWeight.w700)),),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0ACF83)),
                                                  onPressed: (){
                                                    Map<String,dynamic> item = {
                                                      "prod_name":details["prod_name"],
                                                      "prod_details":details["prod_details"],
                                                      "prod_image":details["prod_image"],
                                                      "prod_rating":details["prod_rating"],
                                                      "prod_price":details["prod_price"],
                                                      "prod_qty":details["prod_qty"],
                                                    };
                                                    BlocProvider.of<OrdersBloc>(context).add(DeliveryInitiated(item, key, state.uid[index], subIndex));
                                                    Future.delayed(Duration(seconds: 1),);
                                                    pushNotificationsAllUsers(title: "Your Order delivered!!", body: details["prod_name"], id: state.uid[index]);
                                                    // BlocProvider.of<OrdersBloc>(context).add(OrdersRequested("received"));
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Delivered(title: "title")));
                                                  },
                                                  child: Text("Click to Deliver",
                                                    style: GoogleFonts.dmSans(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),)
                                              )
                                            ],
                                          ),
                                          Image.asset(details["prod_image"],width: 70,height: 70,)
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }
              },
            );
          } else{
            return Center(child: CircularProgressIndicator(color: Color(0xff0ACF83),));
          }
        },
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        color: Color(0xff0ACF83),
        onTap: (index){
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
  }
}
