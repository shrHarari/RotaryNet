import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RotaryMainPageHeaderSearchBox implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  TextEditingController searchController;
  Function funcExecuteSearch;

  RotaryMainPageHeaderSearchBox({
    this.minExtent,
    @required this.maxExtent,
    this.searchController,
    this.funcExecuteSearch,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      // color: Colors.lightBlue[400],
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          /// ----------- Header - Second line - Search Box Area -----------------
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, top: 10.0, right: 50.0, bottom: 10.0),
                  child: TextField(
                    maxLines: 1,
                    controller: searchController,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 0.8,
                        color: Colors.black
                    ),
                    //onSubmitted: (value) async {await executeSearch(value);},
//                    onChanged: (value) async {setSearchTextValueFunc(value);},
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            funcExecuteSearch(searchController.text);
                          },
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "מילת חיפוש",
                        fillColor: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
