import 'package:flutter/material.dart';
import 'package:flutter_firebase_catbox/models/cat.dart';

class DetailsShowcase extends StatelessWidget {
  final Cat cat;

  DetailsShowcase(this.cat);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        cat.description,
        textAlign: TextAlign.center,
        style: textTheme.subhead.copyWith(color: Colors.white),
      ),
    );
  }
}
