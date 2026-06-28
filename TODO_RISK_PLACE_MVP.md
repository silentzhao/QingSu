# 《还了么》消费高风险地点 MVP Todo List

## 目标

第一版做成纯本地 App，不依赖自有后端。用户可以添加“消费高风险地点”，设置提醒半径和提醒文案；当用户到达地点附近时，App 触发本地通知或语音提醒，帮助用户在高风险消费场景前保持冷静。

## 版本边界

### 第一版：纯本地闭环

- 地点数据保存在本机。
- 不需要登录。
- 不需要后端。
- 地点选择可以先用手动输入或模拟地点。
- 前台定位命中后触发提醒。
- 使用本地通知和本机 TTS 播放提醒文案。

### 后续版本

- 接入真实地图展示。
- 接入 POI 搜索，例如商场、门店、地标搜索。
- 支持后台围栏触发。
- 支持多设备同步、账号、云备份。

## 功能流程

1. 用户打开 App。
2. 点击“添加消费高风险地点”。
3. 搜索商场名，或在地图上点选位置。
4. 设置提醒半径，例如 100 米、200 米、500 米。
5. 输入提醒语音文案。
6. 保存。
7. App 注册地理围栏或启动位置监听。
8. 到达商场附近后，触发本地通知或语音提示。

## 技术拆分

### 1. 数据模型

- 新增 `lib/models/risk_place.dart`
- 定义 `RiskPlace` 模型。
- 字段建议：
  - `id`
  - `name`
  - `address`
  - `latitude`
  - `longitude`
  - `radiusMeters`
  - `reminderText`
  - `enabled`
  - `lastTriggeredAt`

### 2. 本地存储

- 新增 `lib/features/risk_places/data/risk_place_store.dart`
- 第一版使用 `SharedPreferences` 保存 JSON 列表。
- 后续数据量变大后再考虑 SQLite、Hive 或 Isar。

### 3. 状态管理

- 新增 `lib/features/risk_places/state/risk_place_state.dart`
- 负责：
  - 读取本地地点列表
  - 添加地点
  - 编辑地点
  - 删除地点
  - 启用或停用地点
  - 更新最近触发时间

### 4. 高风险地点列表页

- 新增 `lib/features/risk_places/pages/risk_place_list_page.dart`
- 展示已保存地点。
- 支持：
  - 查看地点名称、地址、半径、启用状态
  - 启用或停用
  - 删除
  - 进入编辑页
  - 添加新地点
- 空状态文案：
  - “还没有消费高风险地点”
  - “添加一个地点，让还了么在你靠近时提醒你冷静消费。”

### 5. 添加/编辑地点页

- 新增 `lib/features/risk_places/pages/risk_place_edit_page.dart`
- 支持：
  - 输入地点名称
  - 选择地点位置
  - 设置半径
  - 输入提醒文案
  - 保存
- 默认提醒文案示例：
  - “你已接近高风险消费地点，先确认这笔消费是否真的必要。”

### 6. 地点选择页

- 新增 `lib/features/risk_places/pages/place_picker_page.dart`
- 第一版可以先做模拟能力：
  - 输入地点名称
  - 选择内置模拟地点
  - 手动填写经纬度
- 后续再接：
  - MapKit
  - 高德地图
  - 百度地图
  - Google Maps
  - POI 搜索服务

注意：真实商场搜索、地图瓦片和 POI 地址检索通常依赖地图服务和网络。它不依赖自有后端，但不属于完全离线能力。

### 7. 定位服务

- 新增 `lib/services/location_service.dart`
- 负责：
  - 请求定位权限
  - 获取当前位置
  - 监听前台位置变化
  - 返回统一的位置数据结构

### 8. 围栏判断服务

- 新增 `lib/services/geofence_service.dart`
- 负责：
  - 根据当前位置和高风险地点坐标计算距离
  - 判断是否进入提醒半径
  - 做触发冷却，避免用户在边界附近反复收到提醒

建议冷却策略：

- 同一个地点 30 分钟内只提醒一次。
- 用户离开半径后再次进入，才允许下一次提醒。

### 9. 地理工具

- 新增 `lib/utils/geo_utils.dart`
- 负责：
  - 经纬度距离计算
  - 米制半径判断
  - 坐标格式化

### 10. 本地通知

- 新增 `lib/services/notification_service.dart`
- 使用 `flutter_local_notifications`。
- 负责：
  - 初始化通知
  - 请求通知权限
  - 触发本地通知

通知标题示例：

- “还了么提醒你冷静一下”

通知正文示例：

- 用户自定义的提醒文案。

### 11. 语音提醒

- 新增 `lib/services/voice_prompt_service.dart`
- 第一版可使用 `flutter_tts`。
- 负责播放用户设置的提醒文案。

注意：

- iOS 和 Android 对后台语音播放限制不同。
- 第一版建议先做前台或半前台场景。
- 后续再优化后台触发能力。

### 12. 平台权限

#### Android

- 修改 `android/app/src/main/AndroidManifest.xml`
- 可能需要：
  - `ACCESS_FINE_LOCATION`
  - `ACCESS_COARSE_LOCATION`
  - `ACCESS_BACKGROUND_LOCATION`
  - `POST_NOTIFICATIONS`
  - 前台服务相关声明

#### iOS

- 修改 `ios/Runner/Info.plist`
- 可能需要：
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocationAlwaysAndWhenInUseUsageDescription`
  - `NSUserNotificationUsageDescription`
  - 后台定位模式

当前项目暂未包含 iOS 目录，后续如果要打 iOS 包，需要补齐 iOS 工程。

### 13. 导航接入

- 在当前 App 中增加入口：
  - “消费高风险地点”
  - “添加高风险地点”
- 推荐接入位置：
  - “清单”页
  - 或“我的”页

## 推荐实施顺序

1. 新增 `RiskPlace` 模型。
2. 新增本地存储 `RiskPlaceStore`。
3. 新增 `RiskPlaceState`。
4. 新增高风险地点列表页。
5. 新增添加/编辑地点页。
6. 新增模拟地点选择页。
7. 接入现有导航。
8. 新增距离计算工具。
9. 新增前台位置监听。
10. 新增本地通知。
11. 新增 TTS 语音提醒。
12. 增加权限配置。
13. 增加测试。
14. 后续再升级真实地图和后台围栏。

## 主要风险

- 真实地图和商场搜索通常需要地图服务，不是完全离线。
- 后台定位触发在 iOS 和 Android 上都有系统限制。
- App 被杀后，普通 Flutter 前台监听无法可靠触发。
- Android 13+ 需要单独请求通知权限。
- iOS 后台语音播报限制更严格。
- 需要触发冷却，否则用户在围栏边缘移动时会反复收到提醒。

## 第一阶段验收标准

- 用户能添加一个消费高风险地点。
- 用户能设置地点半径。
- 用户能设置提醒文案。
- 地点能保存在本地。
- 重启 App 后地点仍存在。
- 用户能启用、停用、删除地点。
- 模拟当前位置进入半径后能触发提醒。
- 本地通知能展示提醒文案。
- 语音能播放提醒文案。

## 当前实现状态

- 已新增 `RiskPlace` 模型。
- 已新增基于 `SharedPreferences` 的本地存储。
- 已新增独立 `RiskPlaceState`。
- 已新增消费高风险地点列表页。
- 已新增添加/编辑地点页。
- 已新增模拟地点选择页。
- 已在“我的”页接入“消费高风险地点”入口。
- 已新增经纬度距离计算工具。
- 已新增前台定位服务封装。
- 已新增本地通知服务封装。
- 已新增 TTS 语音提醒服务封装。
- 已支持“检查当前位置”和“开始前台监听”。
- 已支持“模拟到达”用于本地验收。
- 已生成 iOS 工程目录。
- 已新增 `ios/Podfile`。
- 已执行 `pod install`，iOS 原生插件依赖安装成功。
- 已补 Android 定位、通知、前台服务权限。
- 已补 iOS 定位、后台定位、通知说明和后台定位模式。

## 当前验证结果

- `flutter analyze` 通过。
- `flutter test` 通过。
- `flutter build apk --debug` 通过，产物为 `build/app/outputs/flutter-apk/app-debug.apk`。
- `flutter build web` 通过，产物为 `build/web`。
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer flutter build ios --simulator --no-codesign` 通过，产物为 `build/ios/iphonesimulator/Runner.app`。
- `ios/Runner/Info.plist` 通过 `plutil -lint`。
- `pod install` 通过，安装了 5 个 iOS pods：
  - `Flutter`
  - `flutter_local_notifications`
  - `flutter_tts`
  - `geolocator_apple`
  - `shared_preferences_foundation`
- iOS 插件注册表已包含：
  - `flutter_local_notifications`
  - `flutter_tts`
  - `geolocator_apple`
  - `shared_preferences_foundation`

## iOS 真机/模拟器构建前置条件

当前机器的系统级 `xcode-select -p` 仍指向 `/Library/Developer/CommandLineTools`，直接运行 `flutter build ios` 会找不到 `xcodebuild`。但 `/Applications/Xcode.app` 已可用，使用 `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` 指定完整 Xcode 后，iOS 模拟器构建已通过。

如果希望以后不带 `DEVELOPER_DIR` 前缀运行 iOS 构建，需要执行：

1. 安装完整 Xcode。
2. 执行 `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`。
3. 执行 `sudo xcodebuild -runFirstLaunch`。
4. 重新运行 `flutter build ios --simulator --no-codesign` 或使用 Xcode 打开 `ios/Runner.xcworkspace` 验证。
