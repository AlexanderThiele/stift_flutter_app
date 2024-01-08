abstract class BillingRepository {
  Future<bool> init();

  bool get hasPremium;
}
