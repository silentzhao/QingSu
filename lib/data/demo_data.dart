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

const preferenceOptions = [
  PreferenceOption(
    title: '高蛋白优先',
    subtitle: '适合训练后和需要稳定状态的工作日。',
    icon: Icons.fitness_center_outlined,
  ),
  PreferenceOption(
    title: '午餐 30 分钟内可决策',
    subtitle: '首页和推荐页优先展示组合型套餐。',
    icon: Icons.schedule_outlined,
  ),
  PreferenceOption(
    title: '减少高糖饮品',
    subtitle: '购物袋自动推荐低糖轻饮替代。',
    icon: Icons.local_cafe_outlined,
  ),
];

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
  ),
];
