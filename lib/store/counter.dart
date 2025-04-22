import 'package:flutter_riverpod/flutter_riverpod.dart';

/// riverpod 是用于共享状态的，不是用在组件内状态，是类似 store 的东西
final counterProvider = StateProvider((ref) => 1);