import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectFareDialog extends StatefulWidget {
  final Vehicle selectedVehicle;
  final MunicipalZone selectedZone;
  final Fare selectedFare;

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

    if (widget.selectedFare != null) {
      setState(() {
        _fare = widget.selectedFare;
      });
    } else {
      _getFares();
    }
  }

  bool _isLoading = false;
  Fare _fare;

  void _getFares() async {
    _updateLoadingState(true);

    Fare fare = await municipalClient.getFare(
        widget.selectedVehicle, widget.selectedZone);

    setState(() {
      _fare = fare;
    });

    _updateLoadingState(false);
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  void _onFareSelected(int simpleFareIndex) {
    _fare.updateSelectedSimpleFare(simpleFareIndex);
    Navigator.of(context).pop(_fare);
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
            opacity:
            !_isLoading && (_fare == null || _fare.simpleValues.isEmpty)
                ? 1.0
                : 0.0,
            child: Text(
              "Some error happened trying to load fares. Please try again later.",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity:
            !_isLoading && _fare != null && _fare.simpleValues.isNotEmpty
                ? 1.0
                : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _fare == null ? 0 : _fare.simpleValues.length,
              itemBuilder: (context, index) {
                FareCost fare = _fare.simpleValues[index];
                bool isSelected = _fare.simpleFareIndex != null
                    ? _fare.simpleFareIndex == index
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
                    _onFareSelected(index);
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
