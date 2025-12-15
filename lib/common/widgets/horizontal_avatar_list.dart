import 'package:flutter/material.dart';

class HorizontalAvatarList extends StatelessWidget {
  const HorizontalAvatarList({
    required this.imageUrlList,
    super.key,
    this.height = 32,
  });

  final double? height;
  final List<String> imageUrlList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: height! * (imageUrlList.length) - height! / 2,
      child: Stack(
        fit: StackFit.expand,
        children: List.generate(imageUrlList.length, (index) {
          return Positioned(
            top: 0,
            left: (25 * index).toDouble(),
            child: _CoordinatorImage(imageUrl: imageUrlList[index]),
          );
        }),
      ),
    );
  }
}

class _CoordinatorImage extends StatelessWidget {
  const _CoordinatorImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('assets/images/user_placeholder.png'),
        ),
      ),
    );
  }
}
