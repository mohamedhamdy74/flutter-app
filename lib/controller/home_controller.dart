import 'package:get/get.dart';
import 'package:routing/api/api-client.dart';
import 'package:routing/api/constant-urls.dart';
import 'package:routing/models/product-model.dart';

import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  var products = <Product>[].obs;
  var categories = <String>[].obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var isLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCategories();
    getProducts();
  }

  void getCategories() async {
    final response = await _apiClient.getData(
      BaseUrls.categoriesUrl,
      headers: {},
      query: {},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      categories.value = ['All', ...data.map((e) => e['name'].toString())];
      update();
    } else {
      Get.snackbar('Error', 'Failed to load categories');
    }
  }

  void getProducts() async {
    isLoading.value = true;
    update();
    String url;
    if (searchQuery.value.isNotEmpty) {
      url = "${BaseUrls.productsUrl}/search?q=${searchQuery.value}";
    } else if (selectedCategory.value != "All") {
      url = "${BaseUrls.productsUrl}/category/${selectedCategory.value}";
    } else {
      url = BaseUrls.productsUrl;
    }
    final response = await _apiClient.getData(url, headers: {}, query: {});
    if (response.statusCode == 200) {
      ProductsModel productsModel = ProductsModel.fromJson(response.data);
      products.value = productsModel.products;
      update();
    } else {
      Get.snackbar('Error', 'Failed to load products');
    }
    isLoading.value = false;
    update();
  }

  void onSearchChanged(String val) {
    searchQuery.value = val;
    getProducts();
    update();
  }

  void onCategorySelected(int index) {
    selectedCategory.value = categories[index];
    getProducts();
    update();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update(ids, condition);
  }
}
