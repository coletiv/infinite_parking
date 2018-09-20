import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectFareDialog extends StatefulWidget {
  final Vehicle selectedVehicle;
  final MunicipalZone selectedZone;
  final FareCost selectedFare;

  const SelectFareDialog({
    @required this.selectedVehicle,
    @required this.selectedZone,
    @required this.selectedFare,
  });

  @override
  SelectFareDialogState createState() => SelectFareDialogState();
}

class SelectFareDialogState extends State<SelectFareDialog> {
  @override
  void initState() {
    super.initState();

    _getFares();
    _selectedFare = widget.selectedFare;
  }

  bool _isLoading = false;
  FareCost _selectedFare;
  final _fares = List<FareCost>();

  void _getFares() async {
    _updateLoadingState(true);

    final fare = await municipalClient.getFare(
        widget.selectedVehicle, widget.selectedZone);

    setState(() {
      _fares.clear();
      if (fare != null) {
        _fares.addAll(fare.simpleValues);
      }
    });

    _updateLoadingState(false);
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  void _onFareSelected(FareCost fare) {
    Navigator.of(context).pop(fare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a fare"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !_isLoading && _fares.isEmpty ? 1.0 : 0.0,
            child: Text(
              "Some error happened trying to load fares. Please try again later.",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity: !_isLoading && _fares.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _fares.length,
              itemBuilder: (context, index) {
                FareCost fare = _fares[index];
                bool isSelected = _selectedFare != null
                    ? _selectedFare.chargedDuration == fare.chargedDuration
                    : false;
                String cost = "${fare.cost.toString()}€";
                String duration =
                    "Duration : ${fare.getChargedDuration().inMinutes.toString()}";

                return ListTile(
                  title: Text(cost),
                  subtitle: Text(duration),
                  selected: isSelected,
                  trailing:
                      isSelected ? Icon(Icons.check) : Icon(Icons.arrow_right),
                  onTap: () {
                    _onFareSelected(fare);
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
