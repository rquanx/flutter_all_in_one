import 'package:graphx/graphx.dart';

Future<GBitmap> loadNetworkImage(String url) async {
  final texture = await ResourceLoader.loadNetworkTexture(url);
  return GBitmap(texture);
}
