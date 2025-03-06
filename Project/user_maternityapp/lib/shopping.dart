import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // Updated mock data with more details
  final List<Map<String, dynamic>> shoppingItems = [
    {
      'name': 'Prenatal Vitamins',
      'price': 20.0,
      'description': 'Essential vitamins for a healthy pregnancy.',
      'category': 'Vitamins',
      'imageUrl': 'https://via.placeholder.com/150?text=Prenatal+Vitamins',
    },
    {
      'name': 'Maternity Dress',
      'price': 50.0,
      'description': 'Comfortable and stylish dress for expecting moms.',
      'category': 'Clothes',
      'imageUrl': 'https://via.placeholder.com/150?text=Maternity+Dress',
    },
    {
      'name': 'Baby Stroller',
      'price': 150.0,
      'description': 'Lightweight stroller with safety features.',
      'category': 'Baby Gear',
      'imageUrl': 'https://via.placeholder.com/150?text=Baby+Stroller',
    },
    {
      'name': 'Nursing Pillow',
      'price': 30.0,
      'description': 'Ergonomic pillow for breastfeeding support.',
      'category': 'Baby Gear',
      'imageUrl': 'https://via.placeholder.com/150?text=Nursing+Pillow',
    },
    {
      'name': 'Maternity Leggings',
      'price': 35.0,
      'description': 'Stretchy leggings for all-day comfort.',
      'category': 'Clothes',
      'imageUrl': 'https://via.placeholder.com/150?text=Maternity+Leggings',
    },
  ];

  final List<String> categories = ['All', 'Vitamins', 'Clothes', 'Baby Gear'];
  String selectedCategory = 'All';
  String searchQuery = '';
  int cartItemCount = 0;

  // Filter items based on category and search query
  List<Map<String, dynamic>> get filteredItems {
    return shoppingItems.where((item) {
      final matchesCategory = selectedCategory == 'All' || item['category'] == selectedCategory;
      final matchesSearch = item['name'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maternity Shopping',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate(shoppingItems));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          // Product List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imageUrl'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${item['price'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              cartItemCount++;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${item['name']} added to cart!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.add_shopping_cart, size: 16),
                                          label: Text('Add'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue[400],
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for cart page navigation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cart contains $cartItemCount items')),
          );
        },
        backgroundColor: Colors.blue[400],
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$cartItemCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Search Delegate for product search
class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> shoppingItems;

  ProductSearchDelegate(this.shoppingItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = shoppingItems.where((item) =>
        item['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item['imageUrl']),
          ),
          title: Text(item['name']),
          subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
          onTap: () {
            close(context, item['name']);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = shoppingItems.where((item) =>
        item['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item['imageUrl']),
          ),
          title: Text(item['name']),
          subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
          onTap: () {
            query = item['name'];
            showResults(context);
          },
        );
      },
    );
  }
}