import 'package:flutter/widgets.dart';

class ImageHero extends StatelessWidget {
  final String imageKey;
  const ImageHero({super.key, required this.imageKey});

  factory ImageHero.asset(String key) => ImageHero(imageKey: key);

  @override
  Widget build(BuildContext context) {
    return Hero(tag: imageKey, child: Image.asset(imageKey));
  }
}
