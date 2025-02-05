import 'package:flutter/material.dart';

class ImageWithBuilder extends StatelessWidget {
  const ImageWithBuilder({
    super.key,
    this.imageUrl =
        'https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png',
    this.width = 290,
    this.height = 200,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(4),
      child: Image.network(
        imageUrl!,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        (progress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}
