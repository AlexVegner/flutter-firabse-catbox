import 'package:flutter/material.dart';
import 'package:flutter_firebase_catbox/models/cat.dart';

class CatDetailBody extends StatelessWidget {
  final Cat cat;

  CatDetailBody(this.cat);

  Widget _createCircleBagge(IconData iconData, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          iconData,
          color: Colors.white,
          size: 16,
        ),
        radius: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTeam = theme.textTheme;

    var locationInfo = Row(
      children: <Widget>[
        Icon(
          Icons.pages,
          color: Colors.white,
          size: 16,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            cat.location,
            style: textTeam.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          cat.name,
          style: textTeam.headline.copyWith(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: locationInfo,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            cat.description,
            style: textTeam.body1.copyWith(color: Colors.white70, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: <Widget>[
              _createCircleBagge(Icons.share, theme.accentColor),
              _createCircleBagge(Icons.phone, Colors.white12),
              _createCircleBagge(Icons.email, Colors.white12),
            ],
          ),
        )
      ],
    );
  }
}
