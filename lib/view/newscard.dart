import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, postUrl;

  const NewsCard({
    Key? key,
    required this.imgUrl,
    required this.desc,
    required this.title,
    required this.content,
    required this.postUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(233, 166, 59, 59),
      elevation: 4.0, // Replace with the desired elevation value
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.fromLTRB(
        16.0,
        0,
        16.0,
        16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Image.network(
              imgUrl,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Icon(Icons.broken_image_outlined),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                color: Color.fromARGB(221, 27, 27, 35),
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              desc,
              maxLines: 2,
              style: const TextStyle(
                color: Color.fromARGB(221, 27, 27, 35),
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
