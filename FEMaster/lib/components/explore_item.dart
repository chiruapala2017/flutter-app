import 'package:flutter/material.dart';

class ExploreItem extends StatefulWidget {
  final String itemHeader;
  final String itemImage;
  final String itemFooter;

  const ExploreItem({Key key, this.itemHeader, this.itemImage, this.itemFooter}) : super(key: key);

  @override
  _ExploreItemState createState() => _ExploreItemState();
}

class _ExploreItemState extends State<ExploreItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'images/tilesHeader.png',
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    widget.itemHeader,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),)
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              widget.itemImage,
              height: 200.0,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(widget.itemFooter, style: TextStyle(fontSize: 20.0),),
          )
        ],
      ),
    );
  }
}
