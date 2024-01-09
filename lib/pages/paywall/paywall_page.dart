import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';

class PaywallPage extends ConsumerWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Stack(children: [
              Card(
                margin: const EdgeInsets.only(left: 16, top: 22, right: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.premiumLifeTimeTitle, style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          Text("€", style: Theme.of(context).textTheme.titleMedium),
                          Text("6", style: Theme.of(context).textTheme.displayMedium),
                          Text(",99", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                            context.l10n.premiumLifeTimeBullet1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(context.l10n.premiumLifeTimeBullet2)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: () {}, child: Text(context.l10n.premiumPurchaseButton)))
                    ],
                  ),
                ),
              ),
              Center(
                  child: Card(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.l10n.premiumDiscount("66%"),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ))
            ])
          ],
        ));
  }
}
