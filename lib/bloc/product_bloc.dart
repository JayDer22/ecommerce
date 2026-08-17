import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/event/product_event.dart';
import 'package:ecommerce/model/product_data.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/State/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<ProductModel> allProducts = [];
  String currentQuery = '';
  String currentCategory = 'All';
  bool? lowToHigh;

  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_loadProducts);
    on<SearchProducts>(_searchProducts);
    on<FilterByCategory>(_filterByCategory);
    on<SortProducts>(_sortProducts);
  }

  void _loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) {
    emit(ProductLoading());

    try {
      allProducts = productData.map((json) => ProductModel.fromJson(json)).toList();
      _applyFilters(emit);
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }

  void _searchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) {
    currentQuery = event.query.toLowerCase().trim();
    _applyFilters(emit);
  }

  void _filterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) {
    currentCategory = event.category;
    _applyFilters(emit);
  }

  void _sortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) {
    lowToHigh = event.lowToHigh;
    _applyFilters(emit);
  }

  void _applyFilters(Emitter<ProductState> emit) {
    List<ProductModel> filtered = List.from(allProducts);

    // Filter by Search Query
    if (currentQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(currentQuery)).toList();
    }

    // Filter by Category
    if (currentCategory != 'All') {
      filtered = filtered.where((p) => p.category == currentCategory).toList();
    }

    // Sort by Price
    if (lowToHigh != null) {
      if (lowToHigh!) {
        filtered.sort((a, b) => a.price.compareTo(b.price));
      } else {
        filtered.sort((a, b) => b.price.compareTo(a.price));
      }
    }

    emit(ProductSuccess(filtered));
  }
}