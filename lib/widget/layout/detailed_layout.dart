// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailedPage extends StatefulWidget {
  final String titleBar;
  final Color backgroundBar;
  final Color background;
  final bool backButtonStatus;
  final Widget content;

  const DetailedPage({
    required this.content,
    this.backButtonStatus = false,
    this.titleBar = "no title",
    this.backgroundBar = const Color(0xFF43964F),
    this.background = Colors.white,
    super.key,
  });

  @override
  State<DetailedPage> createState() => _DetailedPagedState();
}

class _DetailedPagedState extends State<DetailedPage>
    with TickerProviderStateMixin {
  double _appBarOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.axis == Axis.vertical) {
            double offset = scrollInfo.metrics.pixels;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _appBarOpacity =
                      offset <= 0 ? 1.0 : (1 - (offset / 100)).clamp(0.0, 1.0);
                });
              }
            });
          }
          return true;
        },
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: widget.backgroundBar,
              expandedHeight: 78.0,
              toolbarHeight: 0,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: const EdgeInsetsDirectional.only(bottom: 0),
                title: Stack(
                  children: [
                    if (widget.backButtonStatus == true) // Add conditional check
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    Opacity(
                      opacity: _appBarOpacity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height,
                        height: 200,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: widget.content,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
