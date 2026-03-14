import 'package:flutter/material.dart';

import '../models/app_models.dart';

const menuItems = [
  MenuItem(
    id: 'grilled-chicken-bowl',
    name: '炙烤鸡胸能量碗',
    description: '高蛋白、低负担，适合工作日午餐和训练后补充。',
    kcal: '428 kcal',
    price: '¥39',
    category: '能量碗',
    tags: ['高蛋白', '适合午餐', '饱腹感强'],
    icon: Icons.rice_bowl_outlined,
    color: Color(0xFF84A14C),
    badge: '招牌单品',
    badgeColor: Color(0xFFE3EDD2),
    ingredients: ['低温鸡胸', '藜麦', '西兰花', '南瓜', '油醋汁'],
    nutrition: [
      NutritionStat(label: '蛋白质', value: '32g', progress: 0.82),
      NutritionStat(label: '膳食纤维', value: '9g', progress: 0.64),
      NutritionStat(label: '脂肪', value: '12g', progress: 0.38),
    ],
    scenes: ['工作日午餐', '运动后补充', '控卡期主餐'],
  ),
  MenuItem(
    id: 'avocado-shrimp-salad',
    name: '牛油果鲜虾沙拉',
    description: '清爽但不单薄，适合想控卡又想吃得有层次的人。',
    kcal: '362 kcal',
    price: '¥42',
    category: '轻沙拉',
    tags: ['轻负担', '鲜蔬', '清爽口感'],
    icon: Icons.spa_outlined,
    color: Color(0xFF4E8B72),
    badge: '新品推荐',
    badgeColor: Color(0xFFDCEBEB),
    ingredients: ['鲜虾', '牛油果', '生菜', '紫甘蓝', '柠檬黑胡椒汁'],
    nutrition: [
      NutritionStat(label: '蛋白质', value: '24g', progress: 0.68),
      NutritionStat(label: '膳食纤维', value: '11g', progress: 0.8),
      NutritionStat(label: '脂肪', value: '15g', progress: 0.46),
    ],
    scenes: ['减脂晚餐', '轻盈午餐', '高温天气食欲低'],
  ),
  MenuItem(
    id: 'pumpkin-quinoa-bowl',
    name: '南瓜藜麦轻能量餐',
    description: '复合碳水搭配更多纤维，下午状态更稳定。',
    kcal: '396 kcal',
    price: '¥36',
    category: '能量碗',
    tags: ['复合碳水', '饱腹感', '办公室友好'],
    icon: Icons.emoji_food_beverage_outlined,
    color: Color(0xFFE39A51),
    badge: '入门友好',
    badgeColor: Color(0xFFF7E1CA),
    ingredients: ['南瓜', '藜麦', '鹰嘴豆', '羽衣甘蓝', '香草酸奶酱'],
    nutrition: [
      NutritionStat(label: '蛋白质', value: '18g', progress: 0.52),
      NutritionStat(label: '膳食纤维', value: '12g', progress: 0.84),
      NutritionStat(label: '脂肪', value: '10g', progress: 0.32),
    ],
    scenes: ['下午会议多', '低压工作日', '轻断食恢复餐'],
  ),
  MenuItem(
    id: 'berry-yogurt-cup',
    name: '莓果酸奶杯',
    description: '轻甜不腻，适合早餐、加餐和训练前补能。',
    kcal: '214 kcal',
    price: '¥22',
    category: '低卡小食',
    tags: ['加餐', '轻甜', '早餐友好'],
    icon: Icons.icecream_outlined,
    color: Color(0xFFD26874),
    badge: '低卡加餐',
    badgeColor: Color(0xFFF4D8DE),
    ingredients: ['希腊酸奶', '莓果', '燕麦脆', '奇亚籽', '蜂蜜'],
    nutrition: [
      NutritionStat(label: '蛋白质', value: '12g', progress: 0.38),
      NutritionStat(label: '膳食纤维', value: '6g', progress: 0.42),
      NutritionStat(label: '脂肪', value: '7g', progress: 0.24),
    ],
    scenes: ['健身前补能', '早餐替代', '午后加餐'],
  ),
  MenuItem(
    id: 'lime-sparkling',
    name: '青柠气泡轻饮',
    description: '清爽解腻，适合搭配主餐或午后提神。',
    kcal: '96 kcal',
    price: '¥16',
    category: '轻饮品',
    tags: ['轻饮', '解腻', '午后提神'],
    icon: Icons.local_drink_outlined,
    color: Color(0xFF5AB1A2),
    badge: '限定特调',
    badgeColor: Color(0xFFD9F0EB),
    ingredients: ['青柠', '气泡水', '薄荷', '低糖糖浆'],
    nutrition: [
      NutritionStat(label: '糖分', value: '8g', progress: 0.22),
      NutritionStat(label: '清爽值', value: '高', progress: 0.78),
      NutritionStat(label: '搭配度', value: '强', progress: 0.88),
    ],
    scenes: ['搭配主餐', '下午提神', '社交分享'],
  ),
  MenuItem(
    id: 'cold-brew-oat',
    name: '燕麦冷萃轻饮',
    description: '咖啡感更明显，适合午后提神或替换套餐里的轻饮位。',
    kcal: '108 kcal',
    price: '楼18',
    category: '杞婚ギ鍝?',
    tags: ['轻饮', '提神', '替换友好'],
    icon: Icons.coffee_outlined,
    color: Color(0xFF8A6B57),
    badge: '新品轻饮',
    badgeColor: Color(0xFFE8DDD4),
    ingredients: ['冷萃咖啡', '燕麦奶', '低糖糖浆'],
    nutrition: [
      NutritionStat(label: '糖分', value: '7g', progress: 0.18),
      NutritionStat(label: '提神值', value: '高', progress: 0.86),
      NutritionStat(label: '搭配度', value: '强', progress: 0.84),
    ],
    scenes: ['午后提神', '搭配主餐', '训练后恢复'],
  ),
  MenuItem(
    id: 'cocoa-energy-bites',
    name: '可可坚果能量球',
    description: '体量小但补能快，适合把套餐里的加餐替换成更有咀嚼感的选项。',
    kcal: '226 kcal',
    price: '楼24',
    category: '浣庡崱灏忛',
    tags: ['加餐', '轻甜', '便携'],
    icon: Icons.cookie_outlined,
    color: Color(0xFFB56E50),
    badge: '加餐替换',
    badgeColor: Color(0xFFF1DDD3),
    ingredients: ['可可', '腰果', '燕麦', '红枣'],
    nutrition: [
      NutritionStat(label: '蛋白质', value: '8g', progress: 0.28),
      NutritionStat(label: '膳食纤维', value: '5g', progress: 0.36),
      NutritionStat(label: '便携度', value: '高', progress: 0.9),
    ],
    scenes: ['午后加餐', '训练前补能', '通勤携带'],
  ),
];

const articles = [
  ArticleItem(
    title: '为什么工作日更适合吃轻食',
    summary: '对忙碌的上班族来说，稳定的能量供给比短暂的饱腹更重要，清晰搭配会让午后状态更轻盈。',
    tag: '午餐建议',
    icon: Icons.work_outline,
    color: Color(0xFF6D8F68),
  ),
  ArticleItem(
    title: '减脂期怎么吃，才更容易坚持',
    summary: '真正容易坚持的饮食不是极端克制，而是能兼顾口感、营养和日常节奏。',
    tag: '减脂',
    icon: Icons.directions_run_outlined,
    color: Color(0xFFDD9154),
  ),
  ArticleItem(
    title: '高蛋白、低 GI、轻负担到底是什么意思',
    summary: '把这些概念放回一日三餐的场景里看，才会更容易理解，也更容易执行。',
    tag: '营养基础',
    icon: Icons.auto_graph_outlined,
    color: Color(0xFF5A7DB5),
  ),
];

const tips = [
  '高蛋白不等于高负担，关键在于烹饪方式和搭配结构。',
  '轻食也需要碳水，选对比例比完全不吃更重要。',
  '长期坚持比短期极端更重要，先从一顿午餐开始改变。',
];

const actions = [
  ActionItem(
    title: '预约试吃',
    subtitle: '留下信息，优先获取首批试吃资格。',
    icon: Icons.event_available_outlined,
    color: Color(0xFF7AA258),
  ),
  ActionItem(
    title: '领取 7 天轻食建议',
    subtitle: '用最简单的方式体验更轻松的饮食安排。',
    icon: Icons.library_books_outlined,
    color: Color(0xFFE79D50),
  ),
  ActionItem(
    title: '加入会员社群',
    subtitle: '获取新品预告、轻食知识和门店动态。',
    icon: Icons.groups_outlined,
    color: Color(0xFF658C7F),
  ),
];

const onboardingGoalOptions = [
  PreferenceOption(
    id: 'steady',
    title: '轻负担稳定状态',
    subtitle: '适合工作日午餐和需要保持节奏的日常安排。',
    icon: Icons.fitness_center_outlined,
  ),
  PreferenceOption(
    id: 'protein',
    title: '高蛋白更有饱腹感',
    subtitle: '优先看蛋白质更强、适合训练后补充的组合。',
    icon: Icons.schedule_outlined,
  ),
  PreferenceOption(
    id: 'shape',
    title: '控卡也想吃得舒服',
    subtitle: '把热量和满足感平衡在一个更容易坚持的范围里。',
    icon: Icons.local_cafe_outlined,
  ),
];

const onboardingTasteOptions = [
  PreferenceOption(
    id: 'fresh',
    title: '清爽鲜感',
    subtitle: '更偏好轻沙拉、轻饮这类干净利落的口感。',
    icon: Icons.eco_outlined,
  ),
  PreferenceOption(
    id: 'warm',
    title: '温热饱腹',
    subtitle: '更偏好能量碗和复合碳水带来的稳定感。',
    icon: Icons.soup_kitchen_outlined,
  ),
  PreferenceOption(
    id: 'sweet',
    title: '轻甜解馋',
    subtitle: '更愿意从酸奶杯、轻甜加餐开始建立习惯。',
    icon: Icons.icecream_outlined,
  ),
];

const onboardingMealtimeOptions = [
  PreferenceOption(
    id: 'lunch',
    title: '工作日午餐',
    subtitle: '优先给你更适合办公室节奏的主餐推荐。',
    icon: Icons.work_outline,
  ),
  PreferenceOption(
    id: 'snack',
    title: '午后加餐',
    subtitle: '优先看体量轻一点、补能更快的组合。',
    icon: Icons.coffee_outlined,
  ),
  PreferenceOption(
    id: 'training',
    title: '训练后补充',
    subtitle: '优先看蛋白质更高、恢复感更强的搭配。',
    icon: Icons.sports_gymnastics_outlined,
  ),
];

OnboardingPreferences get defaultOnboardingPreferences => OnboardingPreferences(
      goal: onboardingGoalOptions.first,
      taste: onboardingTasteOptions.first,
      mealtime: onboardingMealtimeOptions.first,
    );

OnboardingPreferences onboardingPreferencesFromIds(Map<String, String>? ids) {
  if (ids == null) {
    return defaultOnboardingPreferences;
  }
  PreferenceOption resolve(
    List<PreferenceOption> options,
    String? id,
  ) {
    return options.firstWhere(
      (option) => option.id == id,
      orElse: () => options.first,
    );
  }

  return OnboardingPreferences(
    goal: resolve(onboardingGoalOptions, ids['goal']),
    taste: resolve(onboardingTasteOptions, ids['taste']),
    mealtime: resolve(onboardingMealtimeOptions, ids['mealtime']),
  );
}

MenuItem preferredPrimaryItem(OnboardingPreferences preferences) {
  final preferred = menuItems.where(
    (item) => item.category == preferences.preferredCategory,
  );
  if (preferred.isNotEmpty) {
    return preferred.first;
  }
  return menuItems.first;
}

MenuItem preferredSnackItem(OnboardingPreferences preferences) {
  if (preferences.taste.id == 'sweet') {
    return menuItems.firstWhere(
      (item) => item.category == '低卡小食',
      orElse: () => menuItems[3],
    );
  }
  return menuItems.firstWhere(
    (item) => item.category == '低卡小食' || item.category == '轻饮品',
    orElse: () => menuItems[3],
  );
}

MenuItem preferredDrinkItem() {
  return menuItems.firstWhere(
    (item) => item.category == '轻饮品',
    orElse: () => menuItems.last,
  );
}

const orderRecords = [
  OrderRecord(
    id: 'order-0313-noon',
    title: '工作日午餐预约',
    status: '待配送',
    schedule: '2026-03-13 12:10 - 12:30',
    totalPrice: '¥45',
    summary: '适合办公室午餐场景，已备注无需餐具。',
    items: ['炙烤鸡胸能量碗 x1', '青柠气泡轻饮 x1'],
    badgeColor: Color(0xFFDDE8CB),
    bundleTitle: '工作日午餐稳态组合',
    bundleReason: '围绕稳定状态和午餐场景组合主餐与轻饮，降低中午决策成本。',
    deliveryAddress: '上海市静安区轻植路 88 号 18F',
    paymentMethod: '企业午餐券 / 微信支付',
    note: '无需餐具，优先低温保鲜袋',
    timeline: [
      OrderProgressEvent(
        time: '11:42',
        title: '订单已确认',
        description: '门店已收到午餐预约，开始准备主餐和轻饮。',
      ),
      OrderProgressEvent(
        time: '11:55',
        title: '餐品制作中',
        description: '炙烤鸡胸能量碗和青柠气泡轻饮正在打包。',
      ),
      OrderProgressEvent(
        time: '12:08',
        title: '骑手待取餐',
        description: '预计在 12:10 - 12:30 之间送达办公室。',
        completed: false,
      ),
    ],
  ),
  OrderRecord(
    id: 'order-0312-fitness',
    title: '训练后补充套餐',
    status: '已完成',
    schedule: '2026-03-12 18:20 - 18:40',
    totalPrice: '¥58',
    summary: '高蛋白组合，用户反馈饱腹感和清爽感平衡得更好。',
    items: ['炙烤鸡胸能量碗 x1', '莓果酸奶杯 x1'],
    badgeColor: Color(0xFFF4E1C7),
    bundleTitle: '训练后恢复组合',
    bundleReason: '先补蛋白和恢复感，再用加餐把整组体感拉满。',
    deliveryAddress: '上海市静安区轻植路 88 号 B1 健身区',
    paymentMethod: '微信支付',
    note: '训练后 20 分钟内送达',
    timeline: [
      OrderProgressEvent(
        time: '18:02',
        title: '订单已确认',
        description: '训练后补充套餐已进入门店排产。',
      ),
      OrderProgressEvent(
        time: '18:15',
        title: '餐品已完成',
        description: '门店已完成打包并交给配送。',
      ),
      OrderProgressEvent(
        time: '18:34',
        title: '订单已送达',
        description: '用户已签收，并完成口味与饱腹感反馈。',
      ),
    ],
  ),
  OrderRecord(
    id: 'order-0310-trial',
    title: '品牌试吃预约',
    status: '已评价',
    schedule: '2026-03-10 12:00 - 12:20',
    totalPrice: '¥39',
    summary: '首轮试吃记录已归档，可作为后续接后端后的订单详情原型。',
    items: ['南瓜藜麦轻能量餐 x1'],
    badgeColor: Color(0xFFDCEBEB),
    deliveryAddress: '上海市静安区轻植路 88 号 1F 快闪店',
    paymentMethod: '试吃活动免单',
    note: '品牌试吃场次已结束',
    timeline: [
      OrderProgressEvent(
        time: '11:30',
        title: '试吃登记完成',
        description: '品牌试吃预约信息已创建。',
      ),
      OrderProgressEvent(
        time: '12:00',
        title: '到店体验',
        description: '用户到店领取试吃餐并完成体验。',
      ),
      OrderProgressEvent(
        time: '12:25',
        title: '反馈已归档',
        description: '本次记录已沉淀为后续产品化订单原型。',
      ),
    ],
  ),
];
