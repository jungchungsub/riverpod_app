import 'package:data_app/controller/product_controller.dart';
import 'package:data_app/domain/product/product.dart';
import 'package:data_app/domain/product/product_http_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListViewStore =
    StateNotifierProvider<ProductListViewStore, List<Product>>((ref) {
  return ProductListViewStore([], ref)..initViewModel();
});

class ProductListViewStore extends StateNotifier<List<Product>> {
  Ref _ref;
  ProductListViewStore(super.state, this._ref);

  void initViewModel() async {
    List<Product> products = await _ref.read(productHttpRepository).findAll();
    state = products;
  }

  void PageRefresh(List<Product> products) {
    state = products;
  }

  void onRefresh(List<Product> products) {
    state = products; //새로운값을 넣은것
  }

  void addProduct(Product productRespDto) {
    state = [...state, productRespDto];
  }

  void removeProduct(int id) {
    state = state.where((product) => product.id != id).toList();
  }

  void updateProduct(Product productRespDto) {
    state = state.map((product) {
      if (product.id == productRespDto.id) {
        return productRespDto;
      } else {
        return product;
      }
    }).toList();
  }

  // void addProduct(Product product) {
  //   state = [...state, product];
  // }
  //
  // void removeProduct(int id) {
  //   state = state.where((element) => element.id != id).toList();
  // }
}
