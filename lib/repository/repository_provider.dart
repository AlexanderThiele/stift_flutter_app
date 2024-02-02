import 'package:billing/billing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/repository/analytics/firebase_analytics_repository.dart';
import 'package:pencalendar/repository/auth/auth_repository.dart';
import 'package:pencalendar/repository/auth/firebase_auth_repository.dart';
import 'package:pencalendar/repository/drawings/drawings_repository.dart';
import 'package:pencalendar/repository/drawings/hive_drawings_repository.dart';
import 'package:pencalendar/repository/shared_pref_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => FirebaseAuthRepository(ref));

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) => FirebaseAnalyticsRepository());

final drawingsRepositoryProvider = Provider<DrawingsRepository>((ref) => HiveDrawingsRepository(ref));

final sharedPrefUtilityProvider =
Provider<SharedPrefRepository>((ref) => SharedPrefRepository(ref.watch(sharedPrefInstanceProvider)));

final billingRepositoryProvider = Provider<BillingRepository>((ref) => ActiveBillingRepository());
