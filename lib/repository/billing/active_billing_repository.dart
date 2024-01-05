import 'package:billing/billing.dart';
import 'package:pencalendar/repository/billing/billing_repository.dart';

class ActiveBillingRepository extends BillingRepository {
  final StiftBilling _billing = StiftBilling();

  @override
  void init() {
    _billing.load();
  }
}