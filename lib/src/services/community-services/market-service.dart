import 'dart:convert';
import 'package:flutter/services.dart';

import '../services.dart';

class MarketService {
  // Fetches the list of businesses from a JSON file or database
  Future<List<Business>> getBusinesses() async {
    final String response =
        await rootBundle.loadString('assets/data/market-businesses-data.json');
    final data = await json.decode(response);
    return (data as List).map((i) => Business.fromJson(i)).toList();
  }

  // Fetches the list of businesses from a JSON file or database
  Future<List<Business>> getFeaturedBusinesses() async {
    final String response = await rootBundle
        .loadString('assets/data/market-featured-businesses-data.json');
    final data = await json.decode(response);
    return (data as List).map((i) => Business.fromJson(i)).toList();
  }

  // Fetches the list of businesses from a JSON file or database
  Future<List<Business>> getUserBusinesses(User user) async {
    final String response =
        await rootBundle.loadString('assets/data/market-businesses-data.json');
    final data = await json.decode(response);
    return (data as List)
        .map((i) => Business.fromJson(i))
        .where((element) => element.ownerId == user.id)
        .toList();
  }

// Fetches the products for a specific business
  Future<List<Product>> getProducts(int businessId) async {
    final String response =
        await rootBundle.loadString('assets/data/market-products-data.json');
    final data = await json.decode(response);

    // Fetch the business first
    Business business = await MarketService().getProductBusiness(businessId);

    // Create product instances with the business object
    List<Product> products = (data as List)
        .map((i) =>
            Product.fromJson(i, business: business)) // Pass the business object
        .where((product) => product.businessId == businessId)
        .toList();

    return products;
  }

  // Fetches the business for a product
  Future<Business> getProductBusiness(int businessId) async {
    final String response =
        await rootBundle.loadString('assets/data/market-businesses-data.json');
    final data = await json.decode(response);
    Business products = (data as List)
        .map((i) => Business.fromJson(i))
        .firstWhere((business) => business.id == businessId);
    return products;
  }

  Future<List<Product>> getLikedProducts(User user) async {
    // Load user likes
    final String userLikesString =
        await rootBundle.loadString('assets/data/market-user-likes-data.json');
    final List userLikesData = json.decode(userLikesString);
    final likedProductIds = userLikesData.firstWhere(
        (like) => like['userId'] == user.id,
        orElse: () => {"likedProductIds": []})['likedProductIds'] as List;

    // Load all products and filter by liked IDs
    final String productsString =
        await rootBundle.loadString('assets/data/market-products-data.json');
    final List productsData = json.decode(productsString);
    List<Product> likedProducts = [];

    for (var productId in likedProductIds) {
      var productJson =
          productsData.firstWhere((product) => product['id'] == productId);
      Business business = await getProductBusiness(productJson['businessId']);
      Product product = Product.fromJson(productJson, business: business);
      likedProducts.add(product);
    }

    return likedProducts;
  }

// Fetch products by category and search query
  Future<List<Product>> getFilteredProducts(
      {String category = "All", String search = ""}) async {
    final String response =
        await rootBundle.loadString('assets/data/market-products-data.json');
    final List data = json.decode(response);

    List<Product> products = [];
    for (var productJson in data) {
      Business business = await getProductBusiness(productJson['businessId']);
      Product product = Product.fromJson(productJson, business: business);
      bool matchesCategory = category == "All" || product.category == category;
      bool matchesSearch = search.isEmpty ||
          product.name.toLowerCase().contains(search.toLowerCase());
      if (matchesCategory && matchesSearch) {
        products.add(product);
      }
    }

    return products;
  }

// Fetch businesses by category and search query
  Future<List<Business>> getFilteredBusinesses(
      {String category = "All", String search = ""}) async {
    final String response =
        await rootBundle.loadString('assets/data/market-businesses-data.json');
    final List data = json.decode(response);

    return data.map((i) => Business.fromJson(i)).where((business) {
      bool matchesCategory =
          business.categories.contains(category) || category == "All";
      bool matchesSearch = search.isEmpty ||
          business.name.toLowerCase().contains(search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}

class Business {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String ownerId;
  final List<String> categories;

  Business({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.ownerId,
    required this.categories,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      ownerId: json['ownerId'],
      categories: List<String>.from(json['categories']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final int businessId;
  final String category;
  final String image;
  final Business business;
  final bool featured;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.businessId,
      required this.category,
      required this.image,
      required this.business,
      required this.featured});

  factory Product.fromJson(Map<String, dynamic> json,
      {required Business business}) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        businessId: json['businessId'],
        category: json['category'],
        image: json['image'],
        business: business, // Use the passed business object
        featured: json['featured']);
  }
}
