import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersRepo {


  Future<List<dynamic>> fetchOrders(String cat) async {

    final CollectionReference _orderCollection =
    FirebaseFirestore.instance.collection("dealer").doc(cat).collection("users");
    try {
      QuerySnapshot querySnapshot = await _orderCollection.get();
      List<dynamic> orders = [];
      List<String> uid=[];
      querySnapshot.docs.forEach((doc) {
        uid.add(doc.id);
        orders.add(doc.data());
      });
      return [orders,uid];
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchDetails()  async{
    final CollectionReference _orderDelivered =
    FirebaseFirestore.instance.collection("dealer").doc("delivered").collection("users");
    final CollectionReference _orderRecieved =
    FirebaseFirestore.instance.collection("dealer").doc("received").collection("users");
    try {
      QuerySnapshot querySnapshot = await _orderDelivered.get();
      List<String> clients = [];
      int price = 0;
      int received = 0;
      int delivered = 0;
      querySnapshot.docs.forEach((doc) {
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        for(String mem in data.keys){
          clients.add(mem);
        }
        for(var orderData in data.values){
          delivered+= orderData.length as int;
          for(int i = 0;i<orderData.length;i++){
            price+= int.parse(orderData[i]["prod_price"] )as int;
          }
        }
      });
      QuerySnapshot querySnapshot1 = await _orderRecieved.get();
      querySnapshot1.docs.forEach((doc) {
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        for(var orderData in data.values){
          received+= orderData.length as int;
          for(int i = 0;i<orderData.length;i++){
            price+= int.parse(orderData[i]["prod_price"] )as int;
          }
        }
      });
      print(price);
      print(received);
      print(delivered);
      print(clients);
      return [price,received,delivered,clients];
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<String> makeDelivery(Map<String,dynamic> item,String id,String key,int index) async{
    final CollectionReference _orderCollection =
    FirebaseFirestore.instance.collection("dealer").doc("delivered").collection("users");
    try {
      await _orderCollection.doc(id).update({key:FieldValue.arrayUnion([item])});
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("dealer").doc("received").collection("users").doc(id).get();

      final data = userDoc.data() as Map<String, dynamic>;
      List<dynamic> cartList = List<Map<String, dynamic>>.from(data[key] ?? []);
      cartList.removeAt(index);
      await FirebaseFirestore.instance.collection("dealer").doc("received").collection("users").
      doc(id).update({key:cartList});
      return "Success";
    } on Exception catch (e) {
      return e.toString();
    }
  }

}
