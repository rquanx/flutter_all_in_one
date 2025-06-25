import 'dart:ui';

import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter_application_1/utils/graphx.dart';
import 'package:graphx/graphx.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

final measureTextSize = <String, double>{};

class ProfileCardSpriteOptions {
  final double avatarSize;
  final double tagFontSize;
  final double nameFontSize;
  final double spacing;
  final String nameDecorateUrl;
  final double tagPadding;
  final double tagRadius;
  final double nameRadius;
  final double namePadding;
  final double tagSpacing;
  final double nameDecorateSize;
  final double nameSpacing;

  ProfileCardSpriteOptions({
    this.avatarSize = 64,
    this.tagFontSize = 12,
    this.nameFontSize = 12,
    this.spacing = 8,
    this.tagPadding = 4,
    this.nameDecorateUrl =
        'https://fastly.jsdelivr.net/gh/rquanx/my-statics@master/images/PacMan%E2%84%A2%20Knowledge%20Quest%20(Community)%20(3).png',
    this.nameDecorateSize = 24,
    this.tagRadius = 14,
    this.nameRadius = 18,
    this.tagSpacing = 6,
    this.nameSpacing = 4,
    this.namePadding = 4,
  });
}

/// 头像、标签、名字复合元素
class ProfileCardSprite extends GSprite {
  final String avatarUrl;
  final String avatarBorderUrl;
  final List<String> tags;
  final String nameText;
  final ProfileCardSpriteOptions options = ProfileCardSpriteOptions();
  final EventEmitter events;
  ProfileCardSprite({
    required this.events,
    required this.avatarUrl,
    required this.avatarBorderUrl,
    required this.tags,
    required this.nameText,
    ProfileCardSpriteOptions? options,
  });

  @override
  Future<void> addedToStage() async {
    super.addedToStage();
    final avatarGroup = await _buildAvatar(avatarSize: options.avatarSize);
    avatarGroup.onMouseClick.add((e) {
      showToast("avatar clicked");
    });
    addChild(avatarGroup);

    // 标签
    final tagsGroup = await _buildTags(options);
    tagsGroup.onMouseClick.add((e) {
      showToast("tags clicked");
    });
    addChild(tagsGroup);

    // 名字
    final nameGroup = await _buildName(options);
    nameGroup.onMouseClick.add((e) {
      showToast("name clicked");
    });
    addChild(nameGroup);
    events.on<double>("zoom", (zoom) {
      if (zoom < 0.8) {
        visible = false;
      } else {
        visible = true;
      }
    });
  }

  Future<GSprite> _buildAvatar({required double avatarSize}) async {
    final group = GSprite();
    final avatar = await loadNetworkImage(avatarUrl);
    avatar.width = avatar.height = avatarSize;
    group.addChild(avatar);

    // 创建圆形遮罩
    final maskShape = GShape();
    maskShape.graphics.beginFill(const Color(0xFFFFFFFF));
    maskShape.graphics.drawCircle(
      avatarSize / 2,
      avatarSize / 2,
      avatarSize / 2,
    );
    maskShape.graphics.endFill();
    group.addChild(maskShape);
    avatar.mask = maskShape;

    final borderBitmap = await loadNetworkImage(avatarBorderUrl);
    borderBitmap.width = borderBitmap.height = avatarSize;
    group.addChild(borderBitmap);
    return group;
  }

  Future<GSprite> _buildTags(ProfileCardSpriteOptions options) async {
    final group = GSprite();
    double tagsStartY = 0;
    for (int i = 0; i < tags.length; i++) {
      final tagSprite = GSprite();
      final tagText = GText(
        text: tags[i],
        paragraphStyle: ParagraphStyle(textAlign: TextAlign.left, maxLines: 1),
        textStyle: TextStyle(color: Colors.red, fontSize: options.tagFontSize),
      );

      final textBounds = tagText.getBounds(null);
      double textWidth = textBounds.width;
      double tagWidth = textWidth + options.tagPadding * 2;
      double tagHeight = textBounds.height + options.tagPadding;
      final tagBg = GShape();
      tagBg.graphics.beginFill(const Color(0xFFFFFFFF));
      tagBg.graphics.drawRoundRect(
        0,
        0,
        tagWidth,
        tagHeight,
        options.tagRadius,
        options.tagRadius,
      );
      tagBg.graphics.endFill();
      tagSprite.addChild(tagBg);
      tagText.setPosition(options.tagPadding, options.tagPadding / 2);
      tagSprite.addChild(tagText);
      tagSprite.x = options.avatarSize + options.spacing;
      tagSprite.y = tagsStartY;
      group.addChild(tagSprite);
      tagsStartY += tagHeight + options.tagSpacing;
    }
    return group;
  }

  Future<GSprite> _buildName(ProfileCardSpriteOptions options) async {
    final group = GSprite();
    final nameText = GText(
      text: this.nameText,
      // !! center 可能会导致文字不渲染
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.left, maxLines: 1),
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: options.nameFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
    final nameTextBounds = nameText.getBounds(null);
    final nameBgWidth =
        nameTextBounds.width +
        options.namePadding * 2 +
        options.nameDecorateSize * 2;
    final nameBgHeight = nameTextBounds.height + options.namePadding;

    final nameBg = GShape();
    nameBg.graphics.beginFill(Colors.white);
    nameBg.graphics.drawRoundRect(
      0,
      0,
      nameBgWidth,
      nameBgHeight,
      options.nameRadius,
      options.nameRadius,
    );
    nameBg.graphics.endFill();
    group.addChild(nameBg);

    group.addChild(nameText);
    nameText.setPosition(
      options.namePadding + options.nameDecorateSize,
      options.namePadding / 2,
    );

    final nameDecorateLeft = await loadNetworkImage(options.nameDecorateUrl);
    nameDecorateLeft.width = nameDecorateLeft.height = options.nameDecorateSize;
    nameDecorateLeft.x = options.namePadding;
    // nameDecorateLeft.y = options.tagPadding / 2;
    group.addChild(nameDecorateLeft);

    final nameDecorateRight = await loadNetworkImage(options.nameDecorateUrl);
    nameDecorateRight.width =
        nameDecorateRight.height = options.nameDecorateSize;
    nameDecorateRight.x =
        nameBgWidth - options.nameDecorateSize - options.namePadding;
    // nameDecorateRight.y = options.tagPadding / 2;
    group.addChild(nameDecorateRight);
    group.y = options.avatarSize + options.spacing + options.nameSpacing;
    return group;
  }
}
