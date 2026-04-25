import '../models/user_profile.dart';
import '../models/subscription_plan.dart';
import '../models/payment_method.dart';
import '../models/purchase_record.dart';

abstract class ProfileRepository {
  UserProfile get currentProfile;
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<List<SubscriptionPlan>> getSubscriptionPlans();
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<List<PurchaseRecord>> getPurchaseHistory();
  Future<void> upgradePlan(String planId);
}
