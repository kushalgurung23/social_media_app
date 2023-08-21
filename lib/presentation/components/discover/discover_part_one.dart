import 'package:flutter/material.dart';
import 'package:c_talent/logic/providers/discover_provider.dart';
import 'package:provider/provider.dart';

class DiscoverPartOne extends StatelessWidget {
  const DiscoverPartOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, data, child) {
        return const Flexible(child: SizedBox());
      },
    );
  }
}
