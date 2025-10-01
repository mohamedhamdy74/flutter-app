import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routing/controller/home_controller.dart';
// ...existing code...

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return DefaultTabController(
          length: controller.categories.isEmpty
              ? 1
              : controller.categories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Home", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.deepOrange,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children: [
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
                          controller.onSearchChanged(val);
                        },
                      ),
                    ),
                    controller.categories.isEmpty
                        ? const SizedBox()
                        : TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.white,
                            tabs: controller.categories
                                .map((cat) => Tab(text: cat))
                                .toList(),
                            onTap: (index) {
                              controller.onCategorySelected(index);
                            },
                          ),
                  ],
                ),
              ),
            ),
            body: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
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
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_mail),
                    title: Text('Contact Us'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
