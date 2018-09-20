import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectZoneDialog extends StatefulWidget {
  final Municipal selectedMunicipal;
  final MunicipalZone selectedZone;

  const SelectZoneDialog({
    @required this.selectedMunicipal,
    @required this.selectedZone,
  });

  @override
  SelectZoneDialogState createState() => SelectZoneDialogState();
}

class SelectZoneDialogState extends State<SelectZoneDialog> {
  @override
  void initState() {
    super.initState();

    _getZones();
    _selectedZone = widget.selectedZone;
  }

  bool _isLoading = false;
  MunicipalZone _selectedZone;
  final _zones = List<MunicipalZone>();

  void _getZones() async {
    _updateLoadingState(true);

    final zones =
        await municipalClient.getMunicipalZones(widget.selectedMunicipal.token);

    setState(() {
      _zones.clear();
      _zones.addAll(zones);
    });

    _updateLoadingState(false);
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  void _onZoneSelected(MunicipalZone zone) {
    Navigator.of(context).pop(zone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a zone"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !_isLoading && _zones.isEmpty ? 1.0 : 0.0,
            child: Text(
              "Some error happened trying to load zones. Please try again later",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity: !_isLoading && _zones.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _zones.length,
              itemBuilder: (context, index) {
                MunicipalZone zone = _zones[index];
                bool isSelected = _selectedZone != null
                    ? _selectedZone.token == zone.token
                    : false;

                return ListTile(
                  title: Text(zone.name),
                  selected: isSelected,
                  enabled: zone.isVisible || zone.parkingAllowed,
                  trailing:
                      isSelected ? Icon(Icons.check) : Icon(Icons.arrow_right),
                  onTap: () {
                    _onZoneSelected(zone);
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
