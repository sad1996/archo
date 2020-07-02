import 'package:archo/model/user.dart';
import 'package:archo/provider/home_provider.dart';
import 'package:archo/view/settings_page.dart';
import 'package:archo/widget/user_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "HomePage";

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterLogo(
            style: FlutterLogoStyle.markOnly,
            colors: Colors.orange,
          ),
        ),
        title: Text(
          "Archo",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.toNamed(SettingsPage.routeName),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (_, home, __) => home.users != null
            ? CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: [
                    CupertinoSliverRefreshControl(
                      refreshIndicatorExtent: 50,
                        onRefresh: () => home.getUsers(forceRefresh: true)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        User user = home.users[index];

                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          title: Text(
                            user.firstName + " " + user.lastName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(user.email),
                        );
                      }, childCount: home.users.length),
                    ),
                  ],
                ),
              )
            : UserShimmer(),
      ),
    );
  }
}
