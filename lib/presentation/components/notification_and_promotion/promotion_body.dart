import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PromotionBody extends StatefulWidget {
  const PromotionBody({super.key});

  @override
  State<PromotionBody> createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text('promotion');
  }

  @override
  bool get wantKeepAlive => true;
}
