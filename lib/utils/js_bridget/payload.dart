// 定义一个用于 Flutter 和 WebView 通信的数据结构模型
import 'package:uuid/uuid.dart';
import 'dart:convert';

class Payload {
  // 动作类型，用于标识不同的操作
  String? action;
  // 唯一标识符，用于区分不同的请求或响应
  String id;
  // 携带的数据，可用于传递各种类型的数据
  dynamic data;
  // 状态码，用于表示请求或响应的状态
  int? code;
  // 错误信息，当请求或响应出现错误时使用
  String? errorMessage;

  // 构造函数，用于初始化模型属性，将 customId 替换为 id
  Payload({this.action, this.data, this.code, this.errorMessage, String? id})
    : id = id ?? const Uuid().v4();

  // 将模型转换为 Map 类型，方便在不同平台间传递数据
  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'id': id,
      'data': data,
      'code': code,
      'errorMessage': errorMessage,
    };
  }

  // 从 Map 类型数据创建模型实例
  factory Payload.fromMap(Map<String, dynamic> map) {
    return Payload(
      action: map['action'] as String,
      data: map['data'],
      code: map['statusCode'] as int?,
      errorMessage: map['errorMessage'] as String?,
      id: map['id'] as String?,
    );
  }

  // 将模型转换为 JSON 字符串
  String toJson() => json.encode(toMap());

  // 从 JSON 字符串创建模型实例
  factory Payload.fromJson(String source) =>
      Payload.fromMap(json.decode(source));
}
