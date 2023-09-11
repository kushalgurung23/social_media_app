import 'package:c_talent/presentation/tabs/profile_appbar.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: profileAppBar(context: context),
      body: const Text('Profile body'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
