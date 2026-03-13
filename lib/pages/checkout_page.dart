import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
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
                  const Text('预约/下单',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 18),
              const Reveal(
                  delay: Duration(milliseconds: 60),
                  child: _CheckoutStepCard(index: '01', title: '配送信息', lines: [
                    '上海市静安区轻植路 88 号 18F',
                    '联系人：轻植体验用户',
                    '送达时间：今天 12:10 - 12:30'
                  ])),
              const SizedBox(height: 14),
              const Reveal(
                  delay: Duration(milliseconds: 140),
                  child: _CheckoutStepCard(
                      index: '02',
                      title: '支付方式',
                      lines: ['企业午餐券', '备用方式：微信支付', '备注：无需餐具，优先低温保鲜袋'])),
              const SizedBox(height: 14),
              Reveal(
                delay: const Duration(milliseconds: 220),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CardSectionHeader(title: '订单明细'),
                      const SizedBox(height: 12),
                      ...state.bag.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InfoRow(
                                label: '${entry.item.name} x${entry.quantity}',
                                value: '¥${entry.subtotal}'),
                          )),
                      const SizedBox(height: 8),
                      InfoRow(label: '配送费', value: '¥${state.deliveryFee}'),
                      const SizedBox(height: 8),
                      InfoRow(label: '需支付', value: '¥${state.total}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Reveal(
                  delay: Duration(milliseconds: 300), child: _BrandInfoCard()),
              const SizedBox(height: 24),
              Reveal(
                delay: const Duration(milliseconds: 360),
                child: PressableScale(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF263C2A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(58),
                    ),
                    onPressed: () {
                      state.placeDemoOrder();
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('预约已提交'),
                          content: const Text(
                              '静态订单流程已走通。当前版本未接后端，页面会保留一份默认套餐单用于继续演示。'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                ..pop()
                                ..pop(),
                              child: const Text('知道了'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('确认预约并提交'),
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

class _CheckoutStepCard extends StatelessWidget {
  const _CheckoutStepCard({
    required this.index,
    required this.title,
    required this.lines,
  });

  final String index;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE8CB),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(index,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: Color(0xFF41623F))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                ...lines.map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(line),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandInfoCard extends StatelessWidget {
  const _BrandInfoCard();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('品牌信息',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 12),
          InfoRow(label: '门店计划', value: '城市白领商圈快闪店'),
          SizedBox(height: 8),
          InfoRow(label: '品牌邮箱', value: 'hello@lightdaily.demo'),
          SizedBox(height: 8),
          InfoRow(label: '品牌主张', value: '让每一餐都更轻松'),
        ],
      ),
    );
  }
}
