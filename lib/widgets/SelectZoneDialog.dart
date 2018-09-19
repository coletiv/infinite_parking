import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectZoneDialog extends StatefulWidget {
  final Municipal selectedMunicipal;
  final Function(MunicipalZone selectedZone) onZoneSelected;

  const SelectZoneDialog({this.selectedMunicipal, this.onZoneSelected});

  @override
  State createState() => _SelectZoneDialogState(
      selectedMunicipal: selectedMunicipal, onZoneSelected: onZoneSelected);
}

class _SelectZoneDialogState extends State<SelectZoneDialog> {
  final Municipal selectedMunicipal;
  final Function(MunicipalZone selectedZone) onZoneSelected;

  _SelectZoneDialogState({this.selectedMunicipal, this.onZoneSelected});

  bool isLoading = false;
  MunicipalZone selectedZone;
  final zones = List<MunicipalZone>();

  void getZones() async {
    updateLoadingState(true);

    final updatedZones =
        await municipalClient.getMunicipalZones(selectedMunicipal.token);

    setState(() {
      zones.clear();
      zones.addAll(updatedZones);
    });

    updateLoadingState(false);
  }

  void updateLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  @override
  void initState() {
    super.initState();

    getZones();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose the zone:"),
      contentPadding: EdgeInsets.all(16.0),
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !isLoading && zones.isEmpty ? 1.0 : 0.0,
            child: Text("No zones for this municipal!"),
          ),
          Opacity(
            opacity: !isLoading && zones.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: zones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(zones[index].name),
                  onTap: () {
                    setState(() {
                      selectedZone = zones[index];
                    });

                    onZoneSelected(selectedZone);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
