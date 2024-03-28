// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:circularmallbc/Providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'รายการที่ฉันถูกใจ',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<Cart>().clearCart();
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: context.watch<WishList>().getWishItem.isNotEmpty
          ? WishListItems()
          : CartEmpty(),
    );
  }
}

class CartEmpty extends StatelessWidget {
  const CartEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'คุณไม่มีรายการที่ถูกใจ',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItem[index];
              return Card(
                child: SizedBox(
                  height: 100,
                  child: Row(children: [
                    SizedBox(
                      height: 100,
                      width: 120,
                      child: Image.network(
                          wish.getWishItem[index].imagesUrl.first.toString()),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              wish.getWishItem[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text('ราคา : '
                              ,style: TextStyle(fontSize: 18),),
                              Text(
                                product.price.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text('\tบาท',style: TextStyle(fontSize: 18),),
                              Row( mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<WishList>()
                                          .removeItem(product);
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add_shopping_cart,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              );
            });
      },
    );
  }
}

class CyanButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressed;
  const CyanButton({
    required this.buttonTitle,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50)),
      onPressed: onPressed,
      child: Text(
        buttonTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}
