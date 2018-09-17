import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:flutter/material.dart';

class VehicleDialog extends StatefulWidget {
  @override
  State createState() => _VehicleDialogState();
}

class _VehicleDialogState extends State<VehicleDialog> {
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

  void updateSelectedVehicle(Vehicle vehicle) {
    setState(() {
      this.selectedVehicle = vehicle;
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
      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
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
              shrinkWrap: true,
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(vehicles[index].number),
                  onTap: () {
                    setState(() {
                      selectedVehicle = vehicles[index];
                    });

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
