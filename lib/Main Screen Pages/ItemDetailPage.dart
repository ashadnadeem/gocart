import 'package:flutter/material.dart';
import 'package:gocart/Main%20Screen%20Pages/Widgets/searchlist_builder_widget.dart';
import 'package:gocart/Main%20Screen%20Pages/wishlist_page.dart';
import 'package:gocart/Models/cart_provider.dart';
import 'package:gocart/Models/item_model.dart';
import 'package:gocart/Models/total_provider.dart';
import 'package:gocart/Models/wishlist_provider.dart';
import 'package:gocart/product_ar.dart';
import 'package:gocart/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({required this.product, Key? key}) : super(key: key);
  final Item product;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: const MyAppBar(implyLeading: true),
      body: Center(
        child: Stack(children: <Widget>[
          BackDrop(product: product),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.35),
                ProductDrawer(product: product),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class BackDrop extends StatelessWidget {
  const BackDrop({required this.product, Key? key}) : super(key: key);
  final Item product;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Image.network(product.image),
      width: double.infinity,
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(product.image), fit: BoxFit.cover),
      ),
    );
  }
}

class ProductDrawer extends StatelessWidget {
  const ProductDrawer({required this.product, Key? key}) : super(key: key);
  final Item product;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    Widget addToCartButon() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(screenHeight * 0.25, screenHeight * 0.07),
          primary: Colors.redAccent,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey.shade900,
        ),
        onPressed: () {
          context.read<CartProvider>().addToCart(product);
          context.read<TotalProvider>().add(product.price);
          context.read<CartProvider>().incCount(product);
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.add_shopping_cart),
            const SizedBox(width: 10),
            Text("Add to Cart",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        // Define size
        height: screenHeight,
        // Add radius
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand Name
              Text(product.name,
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.start),
              // Product Name And AR Camera
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.description,
                      style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  product.ar_link != null
                      ? ArCamButton(product: product)
                      : Container(),
                ],
              ),
              // Product Price
              Text(product.price.toString(),
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center),
              SizedBox(height: screenHeight * 0.02),
              // Product Description
              Text('RB3200-01',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center),
              // Color Selector from Filter
              // Size Selector from Filter
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // coolButton(
                  //   text: 'ADD TO CART',
                  //   functionToComply: () {
                  //     // Add in the cart

                  //     context.read<CartProvider>().addToCart(product);
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  addToCartButon(),
                  FavButton(
                    item: product,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavButton extends StatefulWidget {
  const FavButton({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  List<Item> wishlist = [];
  @override
  Widget build(BuildContext context) {
    wishlist = context.read<WishListProvider>().wishlist;
    return IconButton(
      onPressed: () {
        isInWishList()
            ? context.read<WishListProvider>().removeItem(widget.item)
            : context.read<WishListProvider>().addItem(widget.item);
        setState(() {});
      },
      icon: isInWishList()
          ? const Icon(
              Icons.favorite_rounded,
              color: Colors.red,
            )
          : const Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
    );
  }

  bool isInWishList() {
    bool flag = false;
    for (Item i in wishlist) {
      if (i.id == widget.item.id) {
        flag = true;
        break;
      }
    }
    return flag;
  }
}

class ArCamButton extends StatelessWidget {
  const ArCamButton({required this.product, Key? key}) : super(key: key);
  final Item product;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera),
      iconSize: MediaQuery.of(context).size.height * 0.05,
      color: Colors.redAccent,
      onPressed: () {
        // Navigate to the AR Camera
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FaceProductAR(link: product.ar_link!)));
      },
    );
  }
}
