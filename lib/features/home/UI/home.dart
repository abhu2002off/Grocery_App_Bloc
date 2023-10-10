import 'package:bloctutorial_prj/features/home/UI/product_tile_widget.dart';
import 'package:bloctutorial_prj/features/wishlist/ui/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:bloctutorial_prj/features/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctutorial_prj/features/cart/ui/cart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is HomeNavigateToWishlistPageActionState) {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const Wishlist())));
        } else if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => const Cart())));
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Item is carted")));
        } else if (state is HomeProductItemWishlistedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item is wishlisted")));
        }
      },
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));

          case HomeLoadedSuccessState:
            final successState = state
                as HomeLoadedSuccessState; //you can access List of Products from HomeLoadedSuccessState
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal,
                title: const Text("Abhay Grocery App"),
                actions: [
                  IconButton(
                      onPressed: () {
                        homeBloc.add(HomeWishlistButtonNavigateEvent());
                      },
                      icon: const Icon(Icons.favorite)),
                  IconButton(
                      onPressed: () {
                        homeBloc.add(HomeCartButtonNavigateEvent());
                      },
                      icon: const Icon(Icons.shopping_bag_outlined))
                ],
              ),
              body: ListView.builder(
                  itemCount: successState.products.length,
                  itemBuilder: (context, index) {
                    return ProductTileWidget(
                        homeBloc: homeBloc,
                        productDataModel: successState.products[index]);
                  }),
            );

          case HomeErrorState:
            return const Scaffold(body: Text("Error"));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
