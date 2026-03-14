import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/list_items.dart';
import 'order_detail_page.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = AppStateScope.of(context).orders;
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  const Text('预约记录',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 10),
              const Text('先把历史订单、状态标签和记录摘要建好，后续可以直接替换成接口数据。'),
              const SizedBox(height: 18),
              ...orders.asMap().entries.map(
                    (entry) => Reveal(
                      delay: Duration(milliseconds: 60 + (entry.key * 70)),
                      child: OrderRecordCard(
                        key: Key('order-history-card-${entry.value.id}'),
                        order: entry.value,
                        canAdvance: AppStateScope.of(context)
                            .canAdvanceOrderProgress(entry.value.id),
                        advanceButtonKey:
                            Key('order-history-advance-${entry.value.id}'),
                        onAdvance: () {
                          AppStateScope.read(context)
                              .advanceOrderProgress(entry.value.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${entry.value.title} 已推进到下一个节点'),
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  OrderDetailPage(orderId: entry.value.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
