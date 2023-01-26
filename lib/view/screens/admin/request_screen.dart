import 'package:baitulmaal/view/animations/slide_animation.dart';
import 'package:baitulmaal/view_model/request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/enums.dart';
import '../../../view_model/admin_view_model.dart';
import '../../widgets/general/loading_widget.dart';
import '../../widgets/general/request_card.dart';

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
            child: provider.notVerifiedList.isEmpty
                ? Consumer<AdminProvider>(builder: (ctx, adminProvider, child) {
                    if (adminProvider.paymentStatus == Status.loading) {
                      return const LoadingWidget();
                    } else {
                      return Wrap(
                        runAlignment: WrapAlignment.center,
                        children: const [
                          SlideAnimation(child: Center(child: Text("No Requests", style: TextStyle(fontSize: 25)))),
                        ],
                      );
                    }
                  })
                : AnimatedList(
                    key: provider.listKey,
                    initialItemCount: provider.notVerifiedList.length,
                    itemBuilder: (ctx, index, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: RequestCard(
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
