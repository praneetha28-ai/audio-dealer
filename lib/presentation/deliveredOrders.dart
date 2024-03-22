import 'package:dealer/presentation/receivedOrders.dart';
import 'package:flutter/material.dart';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import '../main.dart';
import '../orders_bloc/orders_bloc.dart';

class Delivered extends StatefulWidget {
  const Delivered({super.key, required this.title});
  final String title;

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  NotchBottomBarController controller = NotchBottomBarController(index: 2);
  @override
  void initState(){
    super.initState();
    BlocProvider.of<OrdersBloc>(context).add(OrdersRequested("delivered"));
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
        ),
      ),
      body:BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if(state is OrdersFetched ) {
            print(state.data);
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
                          // color: Color(0xffF6F6F6),
                          height: 250,
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
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: state.data[index][key].length,
                                  itemBuilder: (context, subIndex) {
                                    var details = state.data[index][key][subIndex];
                                    return Container(
                                      height: 100,
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      margin: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${details["prod_name"]}",
                                            style: GoogleFonts.dmSans(textStyle:TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400)),),
                                          Text("Price   ${details["prod_price"]}",
                                            style: GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff0ACF83),fontSize: 18,fontWeight: FontWeight.w700)),),
                                          // SizedBox(height: 10),
                                          Text("Status   Delivered",
                                            style: GoogleFonts.dmSans(textStyle:TextStyle(color: Color(0xff0ACF83),fontSize: 18,fontWeight: FontWeight.w700)),),
                                          // ElevatedButton(onPressed: (){}, child: Text("Click to Deliver"))
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
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Image.asset("assets/received.png",color: Colors.white,),
            activeItem: Image.asset("assets/receivedPro.png"),),
          BottomBarItem(inActiveItem: Icon(Icons.home_outlined,color: Colors.white,),
              activeItem: Icon(Icons.home_filled,color: Color(0xff0ACF83),)),
          BottomBarItem(inActiveItem:Image.asset("assets/deliveredPro.png",color: Colors.white,),
            activeItem: Image.asset("assets/delivered.png"),),
        ],
        notchBottomBarController: controller,
        kIconSize: 25,
        kBottomRadius: 10,
      ),

    );
  }
}
