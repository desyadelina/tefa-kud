import 'package:flutter/material.dart';
import 'package:tefa_kud/Settings/screens/profile_screen.dart';

class DetailedPage extends StatefulWidget {
  final String titleBar;
  final Color backgroundBar;

  const DetailedPage({
    required this.titleBar,
    this.backgroundBar = const Color(0xFF43964F),
    super.key,
  });

  @override
  State<DetailedPage> createState() => _DetailedPagedState();
}

class _DetailedPagedState extends State<DetailedPage>
    with SingleTickerProviderStateMixin {
  double _appBarOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.axis == Axis.vertical) {
            double offset = scrollInfo.metrics.pixels;
            setState(() {
              _appBarOpacity =
                  offset <= 0 ? 1.0 : (1 - (offset / 100)).clamp(0.0, 1.0);
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: widget.backgroundBar,
              expandedHeight: 78.0,
              toolbarHeight: 0,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: const EdgeInsetsDirectional.only(bottom: 0),
                title: Opacity(
                  opacity: _appBarOpacity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: Text(
                        widget.titleBar,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
