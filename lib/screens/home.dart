import 'package:flutter/material.dart';
import 'package:routing/api/api-client.dart';
import 'package:routing/api/constant-urls.dart';
import 'package:routing/models/product-model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiClient _apiClient = ApiClient();
  List<Product> _products = [];
  List<String> _categories = [];
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getProducts(); // load all by default
  }

  Future<void> _getCategories() async {
    final response = await _apiClient.getData(
      BaseUrls.categoriesUrl,
      headers: {},
      query: {},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      setState(() {
        _categories = ["All", ...data.map((e) => e["name"].toString())];
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> _getProducts() async {
    String url;

    if (_searchQuery.isNotEmpty) {
      // البحث
      url = "${BaseUrls.productsUrl}/search?q=$_searchQuery";
    } else if (_selectedCategory != "All") {
      // الفلترة بالكاتيجوري
      url = "${BaseUrls.productsUrl}/category/$_selectedCategory";
    } else {
      // كل المنتجات
      url = BaseUrls.productsUrl;
    }

    final response = await _apiClient.getData(url, headers: {}, query: {});
    if (response.statusCode == 200) {
      ProductsModel productsModel = ProductsModel.fromJson(response.data);
      setState(() {
        _products = productsModel.products;
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.isEmpty ? 1 : _categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // search field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _getProducts();
                    },
                  ),
                ),
                // tabs
                _categories.isEmpty
                    ? const SizedBox()
                    : TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
                        onTap: (index) {
                          _selectedCategory = _categories[index];
                          _getProducts();
                        },
                      ),
              ],
            ),
          ),
        ),
        body: _products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        product.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.title),
                      subtitle: Text("\$${product.price}"),
                    ),
                  );
                },
              ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepOrange),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(leading: Icon(Icons.home), title: Text('Home')),
              ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text('Contact Us'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
