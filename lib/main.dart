import 'package:flutter/material.dart';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

import 'globals.dart' as globals;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class FavoriteWidget extends StatefulWidget {
  
  @override
  _FavoriteWidgetState createState() {
    _FavoriteWidgetState x = new _FavoriteWidgetState();
    return x;
  }
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;
  int getFavorite() {
    return _favoriteCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
      globals.fav = _favoriteCount;
    });
  }
}

class MyApp extends StatelessWidget {
  final FavoriteWidget fav = FavoriteWidget();
  // final int favCount = fav.
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          fav,
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    _navigateAndDisplaySecondRoute(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute(globals.fav)),
      );
      // print(result[0]+result[1]);

    }

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          InkWell(
            child: _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
            onTap:()=> _navigateAndDisplaySecondRoute(context)
          ),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );
    int x = globals.tapX;
    int y = globals.tapY;
    String message;
    if (x == 0) {
      message = 'the user has not tapped on the other screen';
    } else {
      message = 'The user has tapped at x = $x '
          'y = $y';
    }
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        message,
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class SecondRoute extends StatelessWidget {
  final int fav;
  SecondRoute(this.fav);

  @override
  Widget build(BuildContext context) {
    _onTapDown(TapDownDetails details) {
      var x = details.globalPosition.dx;
      var y = details.globalPosition.dy;
      globals.tapY = y.toInt();
      globals.tapX = x.toInt();
     // print("tap down " + x.toString() + ", " + y.toString());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                child: Image.asset(
                  'images/map.jpg',
                  width: 350,
                  height: 500,
                  fit: BoxFit.cover,
                ),
                onTapDown: (TapDownDetails details) => _onTapDown(details),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context,[globals.tapX, globals.tapY]);
                },
                child: Text('$fav'),
              ),
            ],
          ),
        ));
  }
}
