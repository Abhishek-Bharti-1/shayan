import 'package:flutter/material.dart';
import 'package:night_gschallenge/screens/library/article_viewer.dart';
import 'package:night_gschallenge/widgets/UI/image_cacher.dart';

class Article extends StatelessWidget {
  String image;
  String name;
  String description;
  Article({super.key, required this.image, required this.name, required this.description});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleViewer.routeName, arguments: {
          'image': image,
          'title': name,
          'description': description
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ImageCacher(
                  imagePath: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).hoverColor
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
