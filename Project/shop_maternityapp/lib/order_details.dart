import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_maternityapp/main.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';  // Add this import for PdfColors
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final int bid;
  const OrderDetailsPage({super.key, required this.bid});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<Map<String, dynamic>> orderItems = [];
  Map<String, dynamic>? userDetails;
  bool isLoadingUserDetails = true;

  Future<void> fetchItems() async {
    try {
      final response = await supabase.from('tbl_cart').select("*,tbl_product(*)").eq('booking_id', widget.bid);
      List<Map<String, dynamic>> items = [];
      for (var item in response) {
        int total = item['tbl_product']['product_price'] * item['cart_qty'];
        items.add({
          'id': item['id'],
          'pid': item['tbl_product']['product_id'],
          'product': item['tbl_product']['product_name'],
          'image': item['tbl_product']['product_image'],
          'qty': item['cart_qty'],
          'price': item['tbl_product']['product_price'],
          'total': total,
          'status': item['cart_status']
        });
      }
      setState(() {
        orderItems = items;
      });
      print(items);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final bookingData = await supabase
          .from('tbl_booking')
          .select('user_id')
          .eq('id', widget.bid)
          .single();

      final userData = await supabase
          .from('tbl_user')
          .select('*')
          .eq('id', bookingData['user_id'])
          .single();

      setState(() {
        userDetails = userData;
        isLoadingUserDetails = false;
      });
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() {
        isLoadingUserDetails = false;
      });
    }
  }

  Map<String, String> getShopDetails() {
    return {
      'name': 'Maternity Care Shop',
      'address': '123 Maternal Avenue, Health District',
      'city': 'Wellness City',
      'state': 'Care State',
      'zip': '54321',
      'phone': '+1 (555) 123-4567',
      'email': 'shop@maternitycare.com'
    };
  }

  Future<void> update(int id, int status) async {
    try {
      await supabase.from('tbl_cart').update({'cart_status': status + 1}).eq('id', id);
      fetchItems();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _generateAndDownloadBill(Map<String, dynamic> item) async {
    final pdf = pw.Document();
    final shopDetails = await supabase.from('tbl_product').select('shop_id,tbl_shop(*)').eq('product_id', item['pid']).single();
    String shopName = shopDetails['tbl_shop']['shop_name'];
    String shopAddress = shopDetails['tbl_shop']['shop_address'];
    String shopContact = shopDetails['tbl_shop']['shop_contact'];
    String shopEmail = shopDetails['tbl_shop']['shop_email'];
    final orderDate = DateTime.now();
    final formattedDate = DateFormat('MMMM dd, yyyy').format(orderDate);
    final formattedTime = DateFormat('hh:mm a').format(orderDate);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(shopName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text(shopAddress),
                    pw.Text("Phone: $shopContact"),
                    pw.Text("Email: $shopEmail"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Order #${widget.bid}"),
                    pw.Text("Date: $formattedDate"),
                    pw.Text("Time: $formattedTime"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1, color: PdfColor(0.9, 0.9, 0.9)), // Fix PdfColors reference
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("BILL TO:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text(userDetails != null ? "${userDetails!['user_name']}" : "Customer"),
                  pw.Text(userDetails != null ? "${userDetails!['user_address'] ?? 'Address not available'}" : "Address not available"),
                  pw.Text(userDetails != null ? "Phone: ${userDetails!['user_phone'] ?? 'Not available'}" : "Phone: Not available"),
                  pw.Text(userDetails != null ? "Email: ${userDetails!['user_email'] ?? 'Not available'}" : "Email: Not available"),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Order Status: ${_getStatusText(item['status'])}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColor(0.9, 0.9, 0.9)), // Fix PdfColors reference
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColor(0.95, 0.95, 0.95)), // Fix PdfColors reference
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Product", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Quantity", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Unit Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(item['product']),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("${item['qty']}"),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Rs.${item['price'].toStringAsFixed(2)}"),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text("Rs.${item['total'].toStringAsFixed(2)}"),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 200,
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Subtotal:"),
                        pw.Text("Rs.${item['total'].toStringAsFixed(2)}"),
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("TOTAL:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("Rs.${item['total'].toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 40),
            pw.Center(
              child: pw.Text("Thank you for your business!", style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
            ),
          ],
        ),
      ),
    );

    final Uint8List pdfBytes = await pdf.save();

    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Order_${widget.bid}_${item['id']}_Bill.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bill downloaded successfully")),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Confirmed';
      case 2:
        return 'Order Packed';
      case 3:
        return 'Order Complete';
      default:
        return 'Unknown';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 250),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Details",
              style: GoogleFonts.sanchez(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: orderItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No items in this order",
                              style: GoogleFonts.sanchez(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          final item = orderItems[index];
                          return _buildOrderItemCard(item);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(Map<String, dynamic> item) {
    Color statusColor;
    String status = "";
    String btn = "";
    switch (item['status']) {
      case 1:
        statusColor = Colors.blue;
        status = "Confirmed";
        btn = "Order Packed";
        break;
      case 2:
        statusColor = Colors.orange;
        status = "Order Packed";
        btn = "Order Completed";
        break;
      case 3:
        statusColor = Colors.green;
        status = "Order Complete";
        break;
      case 4:
        statusColor = Colors.red;
        status = "Order Cancelled";
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['product'],
                    style: GoogleFonts.sanchez(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Qty: ${item['qty']}",
                        style: GoogleFonts.sanchez(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Price: Rs.${item['price'].toStringAsFixed(2)}",
                        style: GoogleFonts.sanchez(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total: Rs.${item['total'].toStringAsFixed(2)}",
                    style: GoogleFonts.sanchez(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                item['status'] != 3
                    ? SizedBox(
                        height: 40,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            update(item['id'], item['status']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 198, 176, 249),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            btn,
                            style: GoogleFonts.sanchez(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
               item['status'] == 3 ? SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => _generateAndDownloadBill(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Download Bill",
                      style: GoogleFonts.sanchez(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}