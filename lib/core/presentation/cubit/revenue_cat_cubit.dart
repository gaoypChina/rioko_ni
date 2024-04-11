import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'revenue_cat_state.dart';
part 'revenue_cat_cubit.freezed.dart';

class RevenueCatCubit extends Cubit<RevenueCatState> {
  RevenueCatCubit() : super(const RevenueCatState.initial());

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    String key = const String.fromEnvironment('revenue_cat_public_key_android');
    if (Platform.isIOS || Platform.isMacOS) {
      key = const String.fromEnvironment('revenue_cat_public_key_ios');
    }
    await Purchases.configure(PurchasesConfiguration(key));
  }

  StoreProduct? riokoPremium;

  Future<void> fetchProduct() async {
    try {
      List<StoreProduct> products = await Purchases.getProducts(
        ['rioko_premium'],
        productCategory: ProductCategory.nonSubscription,
      );
      if (products.isNotEmpty) {
        riokoPremium = products.first;
      }
    } on PlatformException catch (e, stack) {
      debugPrint('$e\n$stack');
      emit(RevenueCatState.error(e.message ?? ''));
    }
  }

  bool isPremium = false;

  Future<void> purchasePremium() async {
    if (riokoPremium == null) {
      return emit(RevenueCatState.error(tr('core.errors.productFetch')));
    }
    try {
      CustomerInfo customerInfo =
          await Purchases.purchaseStoreProduct(riokoPremium!);
      if (customerInfo.entitlements.all["premium"]?.isActive ?? false) {
        isPremium = true;
        emit(RevenueCatState.purchasedPremium(customerInfo));
      }
    } on PlatformException catch (e, stack) {
      debugPrint(stack.toString());
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        emit(RevenueCatState.error(tr('core.errors.purchaseNotAllowed')));
      } else if (errorCode == PurchasesErrorCode.purchaseInvalidError) {
        emit(RevenueCatState.error(tr('core.errors.purchaseInvalid')));
      }
    }
  }

  Future<void> fetchCustomerInfo() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all['premium']?.isActive ?? false) {
        isPremium = true;
        emit(RevenueCatState.fetchedCustomerInfo(customerInfo));
      }
    } on PlatformException catch (e, stack) {
      debugPrint(stack.toString());
      emit(RevenueCatState.error(e.message ?? ''));
    }
  }
}
