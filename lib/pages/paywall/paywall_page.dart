import 'dart:math';
import 'dart:ui';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkfive_purchases/models/linkfive_products.dart';
import 'package:linkfive_purchases/models/product_type.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/controller/premium_purchase_notifier.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaywallPage extends ConsumerStatefulWidget {
  const PaywallPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaywallPageState();
}

class _PaywallPageState extends ConsumerState<PaywallPage> {
  @override
  void initState() {
    ref.read(premiumOfferProvider.notifier).fetchOffering();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final premiumStatus = ref.watch(premiumPurchaseProvider);

    if (premiumStatus == true) {
      return _AlreadyPurchasedPaywall();
    }

    return _PurchasePaywall();
  }
}

class _AlreadyPurchasedPaywall extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.premiumAlreadyPurchasedTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text("⭐️⭐️⭐️⭐️⭐️", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(context.l10n.premiumAlreadyPurchasedText, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const IncludedFeaturesCard(),
        ],
      ),
    );
  }
}

class _PurchasePaywall extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LinkFiveProducts? premiumOffer = ref.watch(premiumOfferProvider);
    final purchaseInProgress = ref.watch(premiumPurchaseInProgressProvider);

    if (premiumOffer == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: const [
            Card(
              margin: EdgeInsets.only(left: 16, top: 22, right: 16),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16), child: CircularProgressIndicator())
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            ListView(
              children: [
                const IncludedFeaturesCard(),
                for (final offer in premiumOffer.productDetailList)
                  switch (offer.productType) {
                    LinkFiveProductType.OneTimePurchase => Stack(children: [
                        LayoutBuilder(builder: (context, constraint) {
                          return Center(
                            child: SizedBox(
                              width: min(Metrics.boxMaxWidth, constraint.maxWidth),
                              child: Card(
                                margin: const EdgeInsets.only(left: 16, top: 22, right: 16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(context.l10n.premiumLifeTimeTitle,
                                              style: Theme.of(context).textTheme.titleLarge),
                                          const Spacer(),
                                          Text(offer.oneTimePurchasePrice.priceCurrencySymbol,
                                              style: Theme.of(context).textTheme.titleMedium),
                                          Text("${offer.oneTimePurchasePrice.priceAmountMicros ~/ 1000000}",
                                              style: Theme.of(context).textTheme.displayMedium),
                                          Text(",${offer.oneTimePurchasePrice.priceAmountMicros % 1000000 ~/ 10000}",
                                              style: Theme.of(context).textTheme.titleMedium),
                                        ],
                                      ),
                                      const DsGutter.column(),
                                      DsBulletPoint.check(context.l10n.premiumLifeTimeBullet1),
                                      const DsGutter.column(),
                                      Row(
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              size: 16, color: Theme.of(context).colorScheme.secondary),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(context.l10n.premiumLifeTimeBullet2)),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                ref.read(premiumOfferProvider.notifier).purchase(offer);
                                              },
                                              child: Text(context.l10n.premiumPurchaseButton)))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Card(
                              color: Theme.of(context).colorScheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context.l10n.premiumDiscount("46%"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),
                            ))
                      ]),
                    _ => const SizedBox()
                  },
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      ref.read(premiumOfferProvider.notifier).restore();
                    },
                    child: Text(context.l10n.restore)),
                const SizedBox(height: 16),
                _PrivacyTosRow(),
              ],
            ),
            if (purchaseInProgress)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(context.l10n.purchaseInProgressSnackbarText)));
                },
                child: SizedBox(
                  height: 100000,
                  width: 100000,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}

class _PrivacyTosRow extends StatelessWidget {
  final tosWebsite = "https://tnx.app/mica-terms-clean.html";
  final privacyWebsite = "https://tnx.app/mica-pp-clean.html";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: GestureDetector(
            onTap: () async {
              launchUrlString(tosWebsite);
            },
            child: Text(
              context.l10n.termsOfServiceTitle,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).textTheme.labelLarge?.color ?? Theme.of(context).primaryColor,
                  fontStyle: Theme.of(context).textTheme.bodySmall!.fontStyle),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: GestureDetector(
            onTap: () async {
              launchUrlString(privacyWebsite);
            },
            child: Text(
              context.l10n.privacyPolicyTitle,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).textTheme.labelLarge?.color ?? Theme.of(context).primaryColor,
                  fontStyle: Theme.of(context).textTheme.bodySmall!.fontStyle),
            ),
          ),
        )
      ],
    );
  }
}

class IncludedFeaturesCard extends StatelessWidget {
  const IncludedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Center(
        child: SizedBox(
          width: min(Metrics.boxMaxWidth, constraint.maxWidth),
          child: Card(
            margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Premium Features", style: Theme.of(context).textTheme.titleLarge),
                  const DsGutter.column(),
                  DsBulletPoint.round(context.l10n.premiumFeature1),
                  const DsGutter.column(),
                  DsBulletPoint.round(context.l10n.premiumFeature2),
                  const DsGutter.column(),
                  DsBulletPoint.round(context.l10n.premiumFeature3),
                  const DsGutter.column(),
                  DsBulletPoint.round(context.l10n.premiumFeatureMore),
                  const DsGutter.column(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
