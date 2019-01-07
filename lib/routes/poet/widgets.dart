import 'package:flutter/material.dart';
import 'package:flutter_tools/routes/poet/collection_detail.dart';
import 'package:flutter_tools/routes/poet/const_fix.dart';

///作品集item
class CollectionItemWidget extends StatelessWidget {
  final double _size = 48;
  final Collection item;
  CollectionItemWidget(this.item);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CollectionDetailPage.factory(item)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Divider(
            height: 8,
            color: Colors.transparent,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(_size)),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(_size)),
              child: Image.network(
                item.cover,
                width: _size,
                height: _size,
              ),
            ),
          ),
          Divider(
            height: 4,
            color: Colors.transparent,
          ),
          Text(
            item.name,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
