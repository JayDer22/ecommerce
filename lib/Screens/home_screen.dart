import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/bloc/product_bloc.dart';
import 'package:ecommerce/event/product_event.dart';
import 'package:ecommerce/State/product_state.dart';
import 'package:ecommerce/widget/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String selectedSort = 'Default';

  final List<String> categories = [
    'All',
    'Electronics',
    'Shoes',
    'Clothing',
    'Accessories'
  ];

  final Map<String, bool?> sortOptions = {
    'Default': null,
    'Price: Low to High': true,
    'Price: High to Low': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecommerce'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextField(
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(value));
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // Dropdown Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                // Category Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                            context
                                .read<ProductBloc>()
                                .add(FilterByCategory(newValue));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Sort Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSort,
                        isExpanded: true,
                        items: sortOptions.keys.map((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(key, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSort = newValue;
                            });
                            context
                                .read<ProductBloc>()
                                .add(SortProducts(sortOptions[newValue]));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ProductError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: state.products[index],
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
