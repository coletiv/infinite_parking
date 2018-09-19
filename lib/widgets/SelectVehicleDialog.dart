import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:flutter/material.dart';

class SelectVehicleDialog extends StatefulWidget {
  final Function(Vehicle selectedVehicle) onVehicleSelected;

  const SelectVehicleDialog({this.onVehicleSelected});

  @override
  State createState() =>
      _SelectVehicleDialogState(onVehicleSelected: onVehicleSelected);
}

class _SelectVehicleDialogState extends State<SelectVehicleDialog> {
  final Function(Vehicle selectedVehicle) onVehicleSelected;

  _SelectVehicleDialogState({this.onVehicleSelected});

  bool isLoading = false;
  Vehicle selectedVehicle;
  final vehicles = List<Vehicle>();

  void getVehicles() async {
    updateLoadingState(true);

    final updatedVehicles = await vehicleClient.getVehicles();

    setState(() {
      vehicles.clear();
      vehicles.addAll(updatedVehicles);
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

    getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose your vehicle:"),
      contentPadding: EdgeInsets.all(16.0),
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !isLoading && vehicles.isEmpty ? 1.0 : 0.0,
            child: Text("No vehicles!"),
          ),
          Opacity(
            opacity: !isLoading && vehicles.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(vehicles[index].number),
                  onTap: () {
                    setState(() {
                      selectedVehicle = vehicles[index];
                    });

                    onVehicleSelected(selectedVehicle);
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
