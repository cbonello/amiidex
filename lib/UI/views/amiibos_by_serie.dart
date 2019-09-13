import 'dart:collection';

import 'package:amiidex/UI/widgets/amiibo_actionbar.dart';
import 'package:amiidex/UI/widgets/amiibos.dart';
import 'package:amiidex/UI/widgets/fab.dart';
import 'package:amiidex/UI/widgets/search_bar.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:provider/provider.dart';

class AmiibosBySerieView extends StatefulWidget {
  const AmiibosBySerieView({
    Key key,
    @required this.series,
    @required this.serie,
  }) : super(key: key);

  final UnmodifiableListView<SerieModel> series;
  final SerieModel serie;

  @override
  _AmiibosBySerieViewState createState() => _AmiibosBySerieViewState();
}

class _AmiibosBySerieViewState extends State<AmiibosBySerieView> {
  int _index;
  ScrollController _scrollViewController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _index = widget.series.indexOf(widget.serie);
    _scrollViewController = ScrollController();
    _pageController = PageController(
      initialPage: _index,
    );
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<AmiiboSortProvider>(
            builder: (_) => AmiiboSortProvider(),
          ),
          ChangeNotifierProvider<ViewAsProvider>(
            builder: (_) => ViewAsProvider(ItemsDisplayed.amiibo),
          ),
          ChangeNotifierProvider<FABVisibility>(
            builder: (_) => FABVisibility(),
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F6),
          body: NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              final FABVisibility fabVisibility = Provider.of<FABVisibility>(
                context,
                listen: false,
              );
              _scrollViewController.addListener(() {
                if (_scrollViewController.position.userScrollDirection ==
                    ScrollDirection.forward) {
                  fabVisibility.visible = true;
                } else {
                  fabVisibility.visible = false;
                }
              });

              final SerieModel serie = widget.series[_index];

              return <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  title: Semantics(
                    label: I18n.of(context).text('sm-detail-logo'),
                    child: serie.logo,
                  ),
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: ExcludeSemantics(
                    child: FlexibleSpaceBar(
                      background: serie.header,
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        padding: const EdgeInsets.all(15.0),
                        icon: Icon(
                          Icons.search,
                          semanticLabel:
                              I18n.of(context).text('collection-search'),
                        ),
                        onPressed: () async {
                          await showSearch<AmiiboModel>(
                            context: context,
                            delegate: CustomSearchDelegate(
                              widget.series[_index].amiibos,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                AmiiboActionBar(),
              ];
            },
            body: Container(
              color: Theme.of(context).canvasColor,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() => _index = index);
                },
                children: <Widget>[
                  for (SerieModel serie in widget.series)
                    AmiibosWidget(amiibos: serie.amiiboList),
                ],
              ),
            ),
          ),
          floatingActionButton: const FABWdiget(),
        ),
      ),
    );
  }
}
