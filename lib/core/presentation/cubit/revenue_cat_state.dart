part of 'revenue_cat_cubit.dart';

@freezed
class RevenueCatState with _$RevenueCatState {
  const factory RevenueCatState.initial() = _Initial;
  const factory RevenueCatState.error(String message) = _Error;
  const factory RevenueCatState.purchasedPremium(CustomerInfo info) =
      _PurchasedPremium;
  const factory RevenueCatState.fetchedCustomerInfo(CustomerInfo info) =
      _FetchedCustomerInfo;
}
