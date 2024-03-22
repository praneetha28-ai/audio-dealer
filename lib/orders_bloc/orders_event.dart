part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class OrdersRequested extends OrdersEvent{
  final String cat;
  OrdersRequested(this.cat);
  @override
  List<Object?> get props => [cat];
}

class DeliveryInitiated extends OrdersEvent{
  final Map<String,dynamic> item;
  final String key;
  final String id;
  final int index;
  DeliveryInitiated(this.item,this.key,this.id,this.index);
  @override
  List<Object?> get props => [item,key,id,index];
}

class SummaryRequest extends OrdersEvent{
  @override
  List<Object?> get props => [];
}