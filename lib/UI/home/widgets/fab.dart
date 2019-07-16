import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/dialogs.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class FABScan extends StatelessWidget {
  const FABScan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LockProvider lockProvider = Provider.of<LockProvider>(context);
    final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);

    return Visibility(
      visible: fabVisibility.isVisible && lockProvider.isOpened,
      child: FloatingActionButton(
        child: const Icon(Icons.camera_enhance),
        onPressed: () async {
          await scan(context);
        },
      ),
    );
  }

  Future<void> scan(BuildContext context) async {
    try {
      final String barcode = await BarcodeScanner.scan();
      await _addAmiiboDialog(context, barcode);
    } on PlatformException catch (e) {
      if (e.code != BarcodeScanner.CameraAccessDenied) {
        await okDialog(
          context,
          Text(I18n.of(context).text('error-dialog-title')),
          <Widget>[Text(e.message)],
        );
      }
    } on FormatException {
      // User pressed the "back"-button before scanning anything.
    } catch (e) {
      await okDialog(
        context,
        Text(I18n.of(context).text('error-dialog-title')),
        <Widget>[Text(e.message)],
      );
    }
  }

  Future<void> _addAmiiboDialog(
    BuildContext context,
    String barcode,
  ) async {
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);
    final AssetsService assetsService = locator<AssetsService>();
    final AmiiboList l = assetsService.amiiboLineup.matchBarcode(barcode);

    // Unknown barcode?
    if (l.isEmpty) {
      await errorDialog(
        context,
        Text(I18n.of(context).text('fab-scan-error-dialog-title')),
        <Widget>[
          Text(
            sprintf(
              I18n.of(context).text('fab-scan-unknown-barcode'),
              <String>[barcode],
            ),
          ),
        ],
      );
      return;
    }

    // TODO(cbonello): add support for boxes with more than one amiibo.
    assert(l.length == 1);
    final bool isOwned = ownedProvider.isOwned(l[0].id);

    final bool add = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(I18n.of(context).text('fab-scan-add-dialog-title')),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  sprintf(
                    I18n.of(context).text('fab-scan-barcode'),
                    <String>[barcode],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (AmiiboModel a in l)
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: a.box,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  sprintf(
                    I18n.of(context).text('fab-scan-amiibo-name'),
                    <String>[I18n.of(context).text(l[0].id)],
                  ),
                ),
                Text(
                  sprintf(
                    I18n.of(context).text(
                      isOwned
                          ? 'fab-scan-amiibo-status-owned'
                          : 'fab-scan-amiibo-status-not-owned',
                    ),
                    <String>[I18n.of(context).text(l[0].id)],
                  ),
                ),
                if (isOwned == false) const SizedBox(height: 10.0),
                if (isOwned == false)
                  Text(I18n.of(context).text('fab-scan-add-dialog-add')),
              ],
            ),
          ),
          actions: <Widget>[
            if (isOwned == false)
              RaisedButton(
                textColor: Colors.white,
                child: Text(I18n.of(context).text('cancel-button')),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            if (isOwned == false)
              RaisedButton(
                textColor: Colors.white,
                child: Text(I18n.of(context).text('add-button')),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            if (isOwned)
              RaisedButton(
                textColor: Colors.white,
                child: Text(I18n.of(context).text('ok-button')),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
          ],
        );
      },
    );

    if (add) {
      l.forEach(ownedProvider.setOwned);
    }
  }
}
