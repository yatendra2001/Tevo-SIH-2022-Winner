import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'dart:io' show Platform;

import 'package:tevo/utils/theme_constants.dart';

class MembersListSheet extends StatefulWidget {
  final Channel channel;
  const MembersListSheet({Key? key, required this.channel}) : super(key: key);

  @override
  _MembersListSheetState createState() => _MembersListSheetState();
}

class _MembersListSheetState extends State<MembersListSheet> {
  Future<List<Member>> getAllMembers() async {
    var membersResponse = await widget.channel.queryMembers();
    var members = membersResponse.members;
    return members;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  width: 80,
                  height: 4,
                  margin: EdgeInsets.only(top: 8, bottom: 16),
                  decoration: BoxDecoration(
                    color: kSecondaryYellowColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                )),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Members',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getAllMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var members = snapshot.data as List<Member>;
                      return ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        members[index].user!.image!),
                                  ),
                                ),
                              ),
                              title: Text(
                                members[index].user?.name ?? '',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          });
                    }
                    return Center(
                        child: (Platform.isIOS)
                            ? CupertinoActivityIndicator(
                                color: kPrimaryBlackColor)
                            : CircularProgressIndicator(
                                color: kPrimaryBlackColor));
                  }),
            ),
          ],
        ));
  }
}
