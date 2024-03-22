part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersFetched extends OrdersState{
  final List<dynamic> data;
  final List<dynamic> uid;
  OrdersFetched(this.data,this.uid);
  @override
  List<Object> get props => [data,uid];
}

class DeliveryComplete extends OrdersState{
  final String msg ;
  DeliveryComplete(this.msg);
  @override
  List<Object> get props => [msg];
}

class SummaryFetchSuccess extends OrdersState{
   final List<dynamic> stats;
   SummaryFetchSuccess(this.stats);
   @override
   List<Object> get props => [stats];
}