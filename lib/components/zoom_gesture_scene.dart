import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'package:oktoast/oktoast.dart';

final map =
    'https://fastly.jsdelivr.net/gh/rquanx/my-statics@master/images/PacMan%E2%84%A2%20Knowledge%20Quest%20(Community)%20(2).png';
final npc =
    'https://fastly.jsdelivr.net/gh/rquanx/my-statics@master/images/PacMan%E2%84%A2%20Knowledge%20Quest%20(Community)%20(1).png';
final food =
    'https://fastly.jsdelivr.net/gh/rquanx/my-statics@master/images/PacMan%E2%84%A2%20Knowledge%20Quest%20(Community)%20(3).png';

class ZoomGestureScene extends GSprite {
  GSprite content = GSprite();
  GPoint dragPoint = GPoint();
  GPoint grabPoint = GPoint();
  double grabRotation = 0.0;
  double grabScale = 1.0;
  double contentX = 0.0;
  double contentY = 0.0;
  double initDX = 0.0;
  double initDY = 0.0;

  @override
  Future<void> addedToStage() async {
    super.addedToStage();
    stage!.maskBounds = true;
    stage!.color = Colors.grey.shade700;

    content = GSprite();
    addChild(content);
    final initScale = 0.15;
    final mapTexture = await ResourceLoader.loadNetworkTexture(map);
    final mapEle = GBitmap(mapTexture);
    content.addChild(mapEle);
    mapEle.scale = initScale;
    mapEle.height = content.height;
    mapEle.setPosition(
      content.width / 2 - mapEle.width / 2,
      content.height / 2 - mapEle.height / 2,
    );
    
    final npcTexture = await ResourceLoader.loadNetworkTexture(npc);
    final npcEle = GBitmap(npcTexture);
    content.addChild(npcEle);
    npcEle.scale = initScale;
    npcEle.setPosition(
      mapEle.x + mapEle.width / 2 - npcEle.width / 2,
      mapEle.y + mapEle.height / 2 - npcEle.height / 2,
    );
    npcEle.onMouseClick.add((e) => showToast("this is npc"));

    final foodTexture = await ResourceLoader.loadNetworkTexture(food);
    final foodEle = GBitmap(foodTexture);
    content.addChild(foodEle);
    foodEle.scale = initScale;
    foodEle.setPosition(
      mapEle.x + mapEle.width / 2 - foodEle.width / 2 + mapEle.width * 3.3 / 20,
      mapEle.y + mapEle.height / 2 - foodEle.height / 2,
    );
    foodEle.onMouseClick.add((e) => showToast("this is food"));
    resetContentInitialPosition();
  }

  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 1) {
      contentX = content.x;
      contentY = content.y;
      initDX = details.focalPoint.dx;
      initDY = details.focalPoint.dy;
    }
    dragPoint = GPoint.fromNative(details.localFocalPoint);
    grabScale = content.scale;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1) {
      content.setPosition(
        contentX + details.focalPoint.dx - initDX,
        contentY + details.focalPoint.dy - initDY,
      );
      print(details.focalPoint.distance);
      return;
    }
    final scale = details.scale * grabScale;
    setZoom(scale);
  }

  void setZoom(double zoom) {
    final finalZoom = zoom.clamp(.5, 3.0);
    // content.scale = zoom < 1 ? 1 : zoom;
    content.scale = zoom;
  }

  void resetTransform() {
    content.pivotX = content.pivotY = content.rotation = 0;
    content.scale = 1;
    resetContentInitialPosition();
  }

  void resetContentInitialPosition() {
    content.scale = 1;
    content.alignPivot();
    content.centerInStage();
  }
}
