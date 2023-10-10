import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloctutorial_prj/data/cart_item.dart';
import 'package:bloctutorial_prj/features/home/models/home_product_data_model.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(cartInitialEvent);
    on<CartRemoveFromCartEvent>(cartRemoveFromCartEvent);
  }

  FutureOr<void> cartInitialEvent(
      CartInitialEvent event, Emitter<CartState> emit) {
    emit(CartSuccessState(cartItems: cartItems));
  }

  FutureOr<void> cartRemoveFromCartEvent(
      CartRemoveFromCartEvent event, Emitter<CartState> emit) {
    cartItems.remove(event.productDataModel);
    emit(CartRemovedActionState());
    emit(CartSuccessState(
        cartItems:
            cartItems)); //we emit CartSuccessState because it will rebuild the page and the productmodel will be removed
  } //listenwhen and build when rebuilds on CartSuccessState
}
