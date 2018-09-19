import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectFareDialog extends StatefulWidget {
  final Vehicle selectedVehicle;
  final MunicipalZone selectedZone;
  final Function(FareCost selectedFare) onFareSelected;

  const SelectFareDialog(
      {this.selectedVehicle, this.selectedZone, this.onFareSelected});

  @override
  State createState() => _SelectFareDialogState(
      selectedVehicle: selectedVehicle,
      selectedZone: selectedZone,
      onFareSelected: onFareSelected);
}

class _SelectFareDialogState extends State<SelectFareDialog> {
  final Vehicle selectedVehicle;
  final MunicipalZone selectedZone;
  final Function(FareCost selectedFare) onFareSelected;

  _SelectFareDialogState(
      {this.selectedVehicle, this.selectedZone, this.onFareSelected});

  bool isLoading = false;
  FareCost selectedFare;
  final fares = List<FareCost>();

  void getZones() async {
    updateLoadingState(true);

    final fare = await municipalClient.getFare(selectedVehicle, selectedZone);

    setState(() {
      fares.clear();
      if (fare != null) {
        fares.addAll(fare.simpleValues.reversed);
      }
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
      title: Text("Choose the fare:"),
      contentPadding: EdgeInsets.all(16.0),
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !isLoading && fares.isEmpty ? 1.0 : 0.0,
            child: Text("No fares for this vehicle and municipal!"),
          ),
          Opacity(
            opacity: !isLoading && fares.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: fares.length,
              itemBuilder: (context, index) {
                String cost = fares[index].cost.toString();
                String time =
                    fares[index].getChargedDuration().inMinutes.toString();

                return ListTile(
                  title: Text("$cost€ - Duration: $time"),
                  onTap: () {
                    setState(() {
                      selectedFare = fares[index];
                    });

                    onFareSelected(selectedFare);
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
