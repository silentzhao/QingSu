import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  PreferenceOption? _selectedGoal;
  PreferenceOption? _selectedTaste;
  PreferenceOption? _selectedMealtime;

  bool get _canContinue {
    if (_step == 0) {
      return true;
    }
    if (_step == 1) {
      return _selectedGoal != null &&
          _selectedTaste != null &&
          _selectedMealtime != null;
    }
    return true;
  }

  OnboardingPreferences get _preferences => OnboardingPreferences(
        goal: _selectedGoal ?? onboardingGoalOptions.first,
        taste: _selectedTaste ?? onboardingTasteOptions.first,
        mealtime: _selectedMealtime ?? onboardingMealtimeOptions.first,
      );

  Future<void> _handlePrimaryAction() async {
    if (!_canContinue) {
      return;
    }
    if (_step == 2) {
      await AppStateScope.read(context).completeOnboarding(_preferences);
      return;
    }
    setState(() {
      _step += 1;
    });
  }

  void _handleBack() {
    if (_step == 0) {
      return;
    }
    setState(() {
      _step -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final preferences = _preferences;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OnboardingHeader(
                step: _step, onBack: _step == 0 ? null : _handleBack),
            const SizedBox(height: 18),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: switch (_step) {
                  0 => const _BrandStoryStep(key: ValueKey('brand-step')),
                  1 => _PreferenceSelectionStep(
                      key: const ValueKey('preference-step'),
                      selectedGoal: _selectedGoal,
                      selectedTaste: _selectedTaste,
                      selectedMealtime: _selectedMealtime,
                      onGoalSelected: (value) =>
                          setState(() => _selectedGoal = value),
                      onTasteSelected: (value) =>
                          setState(() => _selectedTaste = value),
                      onMealtimeSelected: (value) =>
                          setState(() => _selectedMealtime = value),
                    ),
                  _ => _SummaryStep(
                      key: const ValueKey('summary-step'),
                      preferences: preferences,
                    ),
                },
              ),
            ),
            const SizedBox(height: 18),
            Reveal(
              delay: const Duration(milliseconds: 120),
              child: PressableScale(
                child: FilledButton(
                  key: const Key('onboarding-primary-button'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF263C2A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(58),
                    disabledBackgroundColor:
                        const Color(0xFF263C2A).withValues(alpha: 0.28),
                  ),
                  onPressed: _canContinue ? _handlePrimaryAction : null,
                  child: Text(
                    switch (_step) {
                      0 => '开始定制我的轻食路线',
                      1 => '生成今日推荐',
                      _ => '进入首页',
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.step,
    required this.onBack,
  });

  final int step;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack == null)
          const SizedBox(width: 48)
        else
          IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
        const Spacer(),
        Text(
          'STEP ${step + 1} / 3',
          style: const TextStyle(
            color: Color(0xFF5C6A5D),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _BrandStoryStep extends StatelessWidget {
  const _BrandStoryStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('onboarding-brand-step'),
      children: [
        Reveal(
          delay: const Duration(milliseconds: 40),
          child: GradientFeatureCard(
            colors: const [
              Color(0xFF2C4D35),
              Color(0xFF6C9653),
              Color(0xFFD5E5AA)
            ],
            padding: const EdgeInsets.all(26),
            radius: 34,
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrandBadge(dark: true),
                      SizedBox(height: 18),
                      Text(
                        '轻植日常',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '吃得轻一点，状态好很多。',
                        style: TextStyle(color: Colors.white, height: 1.55),
                      ),
                      SizedBox(height: 18),
                      Text(
                        '先用一次完整的首次进入体验，把品牌认知、偏好选择和推荐方向连起来。',
                        style: TextStyle(color: Colors.white, height: 1.6),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 112,
                  child: FloatingBob(
                    amplitude: 8,
                    child: FoodThumb(
                      color: menuItems.first.color,
                      icon: menuItems.first.icon,
                      width: 108,
                      height: 108,
                      radius: 28,
                      heroTag: menuItems.first.heroTag,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Reveal(
          delay: Duration(milliseconds: 140),
          child: SurfaceCard(
            child: _StoryPanel(
              title: '更像产品，不止是演示',
              body: '这次引导不再只做品牌开场，而是把选择结果直接带入首页和推荐页。',
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Reveal(
          delay: Duration(milliseconds: 220),
          child: SurfaceCard(
            child: _StoryPanel(
              title: '先把静态承接做好',
              body: '仍然不接后端，只在本地完成首次进入、偏好收集和首页个性化承接。',
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceSelectionStep extends StatelessWidget {
  const _PreferenceSelectionStep({
    required this.selectedGoal,
    required this.selectedTaste,
    required this.selectedMealtime,
    required this.onGoalSelected,
    required this.onTasteSelected,
    required this.onMealtimeSelected,
    super.key,
  });

  final PreferenceOption? selectedGoal;
  final PreferenceOption? selectedTaste;
  final PreferenceOption? selectedMealtime;
  final ValueChanged<PreferenceOption> onGoalSelected;
  final ValueChanged<PreferenceOption> onTasteSelected;
  final ValueChanged<PreferenceOption> onMealtimeSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('onboarding-preference-step'),
      children: [
        const Reveal(
          delay: Duration(milliseconds: 40),
          child: Text(
            '先告诉我们，你更想把哪一顿吃对',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 8),
        const Reveal(
          delay: Duration(milliseconds: 90),
          child: Text(
            '选一个目标、一个口味和一个场景，后面的推荐会直接按这个方向承接。',
            style: TextStyle(height: 1.5),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: const Duration(milliseconds: 150),
          child: _OptionGroup(
            title: '你的目标',
            options: onboardingGoalOptions,
            selected: selectedGoal,
            onSelected: onGoalSelected,
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 220),
          child: _OptionGroup(
            title: '喜欢的口感',
            options: onboardingTasteOptions,
            selected: selectedTaste,
            onSelected: onTasteSelected,
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 290),
          child: _OptionGroup(
            title: '最常见的场景',
            options: onboardingMealtimeOptions,
            selected: selectedMealtime,
            onSelected: onMealtimeSelected,
          ),
        ),
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep({
    required this.preferences,
    super.key,
  });

  final OnboardingPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('onboarding-summary-step'),
      children: [
        Reveal(
          delay: const Duration(milliseconds: 40),
          child: SurfaceCard(
            radius: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '你的今日轻食路线',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                Text(
                  preferences.homeTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263C2A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  preferences.summary,
                  style: const TextStyle(height: 1.6),
                ),
                const SizedBox(height: 18),
                ...preferences.storyTags.map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Tag(label: tag, color: const Color(0xFFF3EDE2)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Reveal(
          delay: Duration(milliseconds: 120),
          child: SurfaceCard(
            child: _StoryPanel(
              title: '接下来会发生什么',
              body: '首页会换成更贴近你目标的导语，推荐页会默认聚焦更适合你的分类，我的页面也会显示本次偏好。',
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<PreferenceOption> options;
  final PreferenceOption? selected;
  final ValueChanged<PreferenceOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableOptionCard(
              option: option,
              selected: selected?.id == option.id,
              onTap: () => onSelected(option),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectableOptionCard extends StatelessWidget {
  const _SelectableOptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final PreferenceOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('onboarding-option-${option.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDDE8CB) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  selected ? const Color(0xFF789B56) : const Color(0xFFE6E0D5),
              width: selected ? 1.6 : 1,
            ),
            boxShadow: [
              if (selected)
                const BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDE2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(option.icon, color: const Color(0xFF456243)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(option.subtitle, style: const TextStyle(height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? const Color(0xFF263C2A)
                    : const Color(0xFF95A196),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(body, style: const TextStyle(height: 1.6)),
      ],
    );
  }
}
