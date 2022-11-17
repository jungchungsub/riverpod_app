// VIEW -> Controller
import 'package:data_app/domain/product/product_http_repository.dart';
import 'package:data_app/main.dart';
import 'package:data_app/views/Components/my_alert_dialog.dart';
import 'package:data_app/views/product/list/product_list_view_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product/product.dart';

final productController = Provider<ProductController>((ref) {
  return ProductController(ref);
});

/*
* 컨트롤러:비즈니스 로직 담당
*
*
* */

class ProductController {
  final context = navigatorKey.currentContext!;
  final Ref _ref;

  ProductController(this._ref);

  void findAll() async {
    List<Product> productList =
        await _ref.read(productHttpRepository).findAll();
    _ref.read(productListViewStore.notifier).onRefresh(productList);
  }

  void insert(Product productReqDto) async {
    Product productRespDto =
        await _ref.read(productHttpRepository).insert(productReqDto);
    _ref.read(productListViewStore.notifier).addProduct(productRespDto);
  }

  void deleteById(int id) async {
    int code = await _ref.read(productHttpRepository).deleteById(id);
    if (code == 1) {
      _ref.read(productListViewStore.notifier).removeProduct(id);
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => MyAlertDialog(msg: "삭제실패"),
      );
    }
  }

  void updateById(int id, Product productReqDto) async {
    Product productRespDto =
        await _ref.read(productHttpRepository).updateById(id, productReqDto);
    _ref.read(productListViewStore.notifier).updateProduct(productRespDto);
  }
}
