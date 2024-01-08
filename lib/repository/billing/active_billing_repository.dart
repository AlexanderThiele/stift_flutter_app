import 'package:billing/billing.dart';
import 'package:pencalendar/repository/billing/billing_repository.dart';

class ActiveBillingRepository extends BillingRepository {
  final StiftBilling _billing = StiftBilling();

  @override
  Future<bool> init() async {
    // _billing.load();
    return true;
  }

  @override
  bool get hasPremium {
    return true;
  }
}
