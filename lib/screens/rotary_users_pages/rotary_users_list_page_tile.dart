import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/rotary_user_detail_pages/rotary_user_detail_page_screen.dart';

class RotaryUsersListPageTile extends StatelessWidget {
  final UserObject argUserObj;

  RotaryUsersListPageTile({Key key, this.argUserObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0, bottom: 5.0),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Colors.blue[300],
          ),

          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.grey[50],
            ),

            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                // CircleAvatar(
                //   radius: 30.0,
                //   backgroundColor: Colors.blue[900],
                //   backgroundImage: userImage,
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            argUserObj.firstName + " " + argUserObj.lastName,
                            style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          argUserObj.emailId,
                          style: TextStyle(color: Colors.grey[900], fontSize: 12.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),

                _buildDeleteUserButton(context),
                // IconButton(
                //     icon: Icon(Icons.delete) ,
                //     onPressed: () {
                //       bloc.deleteUser(argUserObj);
                //     }
                // ),
              ],
            ),
          ),
        ),
        onTap: ()
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                RotaryUserDetailPageScreen(argUserObject: argUserObj),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeleteUserButton(BuildContext context) {
    final bloc = BlocProvider.of<RotaryUsersListBloc>(context);
    return StreamBuilder<List<UserObject>>(
      stream: bloc.usersStream,
      initialData: bloc.usersList,
      builder: (context, snapshot) {
        List<UserObject> users =
        (snapshot.connectionState == ConnectionState.waiting)
            ? bloc.usersList
            : snapshot.data;

        return IconButton(
            icon: Icon(Icons.delete) ,
            onPressed: () {
              bloc.deleteUser(argUserObj);
            }
        );
      },
    );
  }
}
