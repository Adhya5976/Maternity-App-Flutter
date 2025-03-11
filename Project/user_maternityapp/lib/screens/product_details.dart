import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_maternityapp/service/cart_service.dart';
//import 'package:user/screen/cart.dart';

class ProductPage extends StatefulWidget {
  final int productId; // Pass only product ID

  const ProductPage({super.key, required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? product;
  int? remaining;
  bool isLoading = true;

  final cartService = CartService(Supabase.instance.client);

  void addItemToCart(BuildContext context, int itemId) {
    cartService.addToCart(context, itemId);
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final stock = await supabase
          .from('tbl_stock')
          .select('stock_quantity')
          .eq('product_id', widget.productId);

      int totalStock =
          stock.fold(0, (sum, item) => sum + (item['stock_quantity'] as int));
      final cart = await supabase
          .from('tbl_cart')
          .select('cart_qty')
          .eq('product_id', widget.productId);

      int totalCartQty =
          cart.fold(0, (sum, item) => sum + (item['cart_qty'] as int));
      final response = await supabase
          .from('tbl_product')
          .select()
          .eq('product_id', widget.productId)
          .single(); // Fetch single product  

      int remainingStock = totalStock - totalCartQty;

      print("Total Stock: $totalStock");
      print("Total Cart Qty: $totalCartQty");
      print("Remaining Stock: $remainingStock");

      setState(() {
        remaining = remainingStock;
        product = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product?['product_name'] ?? "Loading...")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : product == null
              ? Center(child: Text("Product not found"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product?['product_image'] ??
                            'https://via.placeholder.com/250',
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 250),
                      ),
                      SizedBox(height: 16),
                      Text(product?['product_name'] ?? 'Unknown product',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                          product?['product_description'] ??
                              'No details available',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text("Price: ₹${product?['product_price'] ?? 'N/A'}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      remaining! <= 0
                          ? Text('Out of Stock')
                          : ElevatedButton(
                              onPressed: () {
                                addItemToCart(context, product?['product_id']);
                                // addToCart(product?['product_id']);
                              },
                              child: Text("Add to Cart"),
                            ),
                    ],
                  ),
                ),
    );
  }
}
