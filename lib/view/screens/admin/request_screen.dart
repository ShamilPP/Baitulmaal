import 'package:baitulmaal/view_model/request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/request_list_tile.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RequestProvider>(context, listen: false);
    provider.setNotVerifiedList(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Requests',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: provider.listKey,
              initialItemCount: provider.notVerifiedList.length,
              itemBuilder: (ctx, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: RequestListTile(
                    index: index,
                    payment: provider.notVerifiedList[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
