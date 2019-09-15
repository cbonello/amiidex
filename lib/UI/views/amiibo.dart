import 'package:amiidex/main.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/country.dart';
import 'package:amiidex/providers/region_indicators.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/dialogs.dart';
import 'package:amiidex/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AmiiboView extends StatefulWidget {
  const AmiiboView({Key key, @required this.amiibo}) : super(key: key);

  final AmiiboModel amiibo;

  @override
  AmiiboViewState createState() => AmiiboViewState();
}

class AmiiboViewState extends State<AmiiboView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AssetsService assetsService = locator<AssetsService>();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: theme.appBarTheme.iconTheme,
            title: Text(I18n.of(context).text(widget.amiibo.lKey)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              widget.amiibo.box,
                              widget.amiibo.image,
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  I18n.of(context).text(widget.amiibo.serieID),
                                  style: Theme.of(context).textTheme.body1,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Release Date',
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                for (String regionId
                                    in assetsService.config.regions.keys)
                                  if (widget.amiibo
                                      .wasReleasedInRegion(regionId))
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          RegionButton(regionId: regionId),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12.0,
                                              bottom: 12.0,
                                            ),
                                            child: Text(
                                              DateFormat.yMMMd(
                                                Localizations.localeOf(context)
                                                    .toString(),
                                              ).format(
                                                widget.amiibo.releases[regionId]
                                                    .releaseDate,
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RegionButton extends StatelessWidget {
  const RegionButton({
    Key key,
    @required this.regionId,
    this.fullCountryName = false,
  }) : super(key: key);

  final String regionId;
  final bool fullCountryName;

  @override
  Widget build(BuildContext context) {
    final RegionIndicatorsProvider regionIndicatorsProvider =
        Provider.of<RegionIndicatorsProvider>(context);
    final CountryModel country = regionIndicatorsProvider.country(regionId);

    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: country.hasURL ? lightBlueColor : Colors.transparent,
          ),
        ),
        child: country.flag,
      ),
      onTap: country.hasURL
          ? () async {
              if (await url_launcher.canLaunch(country.url)) {
                await url_launcher.launch(country.url);
              } else {
                await errorDialog(
                  context,
                  Text(I18n.of(context).text('error-dialog-title')),
                  <Widget>[
                    Text(
                      sprintf(
                        I18n.of(context).text('error-url-launch'),
                        <String>[country.url],
                      ),
                    )
                  ],
                );
              }
            }
          : null,
    );
  }
}
