import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../repo/orders_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepo ordersRepo;
  OrdersBloc({required this.ordersRepo}) : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<OrdersRequested>((event,emit)async{
      final List<dynamic> data  = await ordersRepo.fetchOrders(event.cat);
      print(data);
      emit(OrdersFetched(data[0],data[1]));
    });
    on<DeliveryInitiated>((event,emit)async{
      final String msg = await ordersRepo.makeDelivery(event.item,event.id,event.key,event.index);
      // emit(DeliveryComplete(msg));
    });
    on<SummaryRequest>((event,emit)async{
     final List<dynamic> stats = await ordersRepo.fetchDetails();
     emit(SummaryFetchSuccess(stats));
      // emit(DeliveryComplete(msg));
    });
  }
}
