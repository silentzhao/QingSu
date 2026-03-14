import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class PreferenceEditPage extends StatefulWidget {
  const PreferenceEditPage({super.key});

  @override
  State<PreferenceEditPage> createState() => _PreferenceEditPageState();
}

class _PreferenceEditPageState extends State<PreferenceEditPage> {
  late PreferenceOption _goal;
  late PreferenceOption _taste;
  late PreferenceOption _mealtime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final current = AppStateScope.of(context).effectivePreferences;
    _goal = current.goal;
    _taste = current.taste;
    _mealtime = current.mealtime;
  }

  Future<void> _save() async {
    final preferences = OnboardingPreferences(
      goal: _goal,
      taste: _taste,
      mealtime: _mealtime,
    );
    await AppStateScope.read(context).updatePreferences(preferences);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('饮食偏好已更新')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewPreferences = OnboardingPreferences(
      goal: _goal,
      taste: _taste,
      mealtime: _mealtime,
    );
    final previewBundles = buildBundleRecommendations(previewPreferences);
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
                      '编辑饮食偏好',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '这里不重新走完整 onboarding，只调整偏好本身。购物袋推荐、首页文案和推荐页默认分类都会同步更新。',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 22),
              _EditOptionGroup(
                title: '当前目标',
                options: onboardingGoalOptions,
                selected: _goal,
                onSelected: (value) => setState(() => _goal = value),
              ),
              const SizedBox(height: 18),
              _EditOptionGroup(
                title: '口味方向',
                options: onboardingTasteOptions,
                selected: _taste,
                onSelected: (value) => setState(() => _taste = value),
              ),
              const SizedBox(height: 18),
              _EditOptionGroup(
                title: '优先场景',
                options: onboardingMealtimeOptions,
                selected: _mealtime,
                onSelected: (value) => setState(() => _mealtime = value),
              ),
              const SizedBox(height: 18),
              _PreferencePreviewCard(
                preferences: previewPreferences,
                bundles: previewBundles,
              ),
              const SizedBox(height: 24),
              PressableScale(
                child: FilledButton(
                  key: const Key('preference-edit-save'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF263C2A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: _save,
                  child: const Text('保存偏好'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencePreviewCard extends StatelessWidget {
  const _PreferencePreviewCard({
    required this.preferences,
    required this.bundles,
  });

  final OnboardingPreferences preferences;
  final List<BundleRecommendation> bundles;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '保存后会这样变化',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          InfoRow(label: '首页导语', value: preferences.homeTitle),
          const SizedBox(height: 8),
          InfoRow(label: '推荐页', value: preferences.recommendationTitle),
          const SizedBox(height: 8),
          InfoRow(label: '默认分类', value: preferences.preferredCategory),
          if (bundles.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              '购物袋套餐预览',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3F5841).withValues(alpha: 0.92),
              ),
            ),
            const SizedBox(height: 10),
            ...bundles.map(
              (bundle) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F4EC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bundle.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(bundle.subtitle),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        bundle.totalPriceLabel,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditOptionGroup extends StatelessWidget {
  const _EditOptionGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<PreferenceOption> options;
  final PreferenceOption selected;
  final ValueChanged<PreferenceOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          ...options.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == options.length - 1 ? 0 : 10,
                  ),
                  child: InkWell(
                    key: Key('preference-edit-$title-${entry.value.id}'),
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => onSelected(entry.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected.id == entry.value.id
                            ? const Color(0xFFDDE8CB)
                            : const Color(0xFFF8F4EC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected.id == entry.value.id
                              ? const Color(0xFF789B56)
                              : const Color(0xFFE7DECF),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(entry.value.icon,
                              color: const Color(0xFF456243)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.value.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(entry.value.subtitle),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            selected.id == entry.value.id
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: const Color(0xFF405F40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
