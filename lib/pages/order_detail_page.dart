import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    required this.orderId,
    super.key,
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final order = state.orderById(orderId);
    if (order == null) {
      return Scaffold(
        body: AppBackdrop(
          child: SafeArea(
            child: Center(
              child: SurfaceCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '订单不存在',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    const Text('当前订单可能已被移除或状态未同步。'),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('返回'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final canAdvance = state.canAdvanceOrderProgress(orderId);
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
                  const Expanded(
                    child: Text(
                      '订单详情',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Tag(
                          label: order.displayStatus,
                          color: order.displayBadgeColor,
                        ),
                        const Spacer(),
                        Text(
                          order.totalPrice,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      order.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(order.summary, style: const TextStyle(height: 1.5)),
                    if (order.currentProgress != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        '当前状态：${order.currentProgress!.title}',
                        key: const Key('order-current-progress-title'),
                        style: const TextStyle(
                          color: Color(0xFF446146),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    InfoRow(label: '配送时间', value: order.schedule),
                    if (order.deliveryAddress != null) ...[
                      const SizedBox(height: 8),
                      InfoRow(label: '配送地址', value: order.deliveryAddress!),
                    ],
                    if (order.paymentMethod != null) ...[
                      const SizedBox(height: 8),
                      InfoRow(label: '支付方式', value: order.paymentMethod!),
                    ],
                    if (order.note != null) ...[
                      const SizedBox(height: 8),
                      InfoRow(label: '订单备注', value: order.note!),
                    ],
                    if (canAdvance) ...[
                      const SizedBox(height: 16),
                      FilledButton.tonalIcon(
                        key: const Key('advance-order-progress-button'),
                        onPressed: () {
                          state.advanceOrderProgress(orderId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已推进到下一个履约节点'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text('模拟推进下一节点'),
                      ),
                    ],
                  ],
                ),
              ),
              if (order.bundleTitle != null) ...[
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CardSectionHeader(title: '套餐来源'),
                      const SizedBox(height: 12),
                      Text(
                        order.bundleTitle!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (order.bundleReason != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          order.bundleReason!,
                          style: const TextStyle(height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (order.timeline.isNotEmpty) ...[
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CardSectionHeader(title: '配送进度'),
                      const SizedBox(height: 12),
                      ...order.timeline.asMap().entries.map(
                            (entry) => Padding(
                              padding: EdgeInsets.only(
                                bottom: entry.key == order.timeline.length - 1
                                    ? 0
                                    : 14,
                              ),
                              child: _OrderTimelineRow(
                                event: entry.value,
                                isCurrent: identical(
                                  entry.value,
                                  order.currentProgress,
                                ),
                                isLast: entry.key == order.timeline.length - 1,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CardSectionHeader(title: '商品清单'),
                    const SizedBox(height: 12),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Color(0xFF506D49),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTimelineRow extends StatelessWidget {
  const _OrderTimelineRow({
    required this.event,
    required this.isCurrent,
    required this.isLast,
  });

  final OrderProgressEvent event;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = isCurrent
        ? const Color(0xFFB48A4D)
        : event.completed
            ? const Color(0xFF4E704C)
            : const Color(0xFFB48A4D);
    final titleStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: isCurrent ? const Color(0xFF7A5D2F) : null,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 42,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xFFE5DDCF),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.time,
                style: const TextStyle(
                  color: Color(0xFF617263),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(event.title, style: titleStyle),
              const SizedBox(height: 4),
              Text(
                event.description,
                style: const TextStyle(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
