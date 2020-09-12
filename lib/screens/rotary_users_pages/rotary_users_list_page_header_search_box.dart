import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/user_object.dart';

class RotaryUsersListPageHeaderSearchBox implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  RotaryUsersListPageHeaderSearchBox({
    this.minExtent,
    @required this.maxExtent,
  });

  TextEditingController searchController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    final bloc = BlocProvider.of<RotaryUsersListBloc>(context);

    return StreamBuilder<List<UserObject>>(
      stream: bloc.usersStream,
      initialData: bloc.usersList,
      builder: (context, snapshot) {
        List<UserObject> users =
        (snapshot.connectionState == ConnectionState.waiting)
            ? bloc.usersList
            : snapshot.data;

        // if (users == null || users.isEmpty) {
        //   return Center(child: Text('רשימת משתמשים ריקה'));
        // }

        return Container(
          color: Colors.lightBlue[400],
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
                        onChanged: (searchText) {bloc.getUsersListBySearchQuery(searchText);},
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                              color: Colors.blue,
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                bloc.getUsersListBySearchQuery(searchController.text);
                              },
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "הקלד שם משתמש",
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
