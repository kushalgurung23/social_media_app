import 'package:c_talent/presentation/tabs/service_appbar.dart';
import 'package:flutter/material.dart';

class InterestClassTab extends StatefulWidget {
  const InterestClassTab({Key? key}) : super(key: key);

  @override
  State<InterestClassTab> createState() => _InterestClassTabState();
}

class _InterestClassTabState extends State<InterestClassTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: interestAppBar(context: context),
      body: const Text('Service tab'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
