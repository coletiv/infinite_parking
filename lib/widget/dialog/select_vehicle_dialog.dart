import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:flutter/material.dart';

class SelectVehicleDialog extends StatefulWidget {
  final Vehicle selectedVehicle;

  const SelectVehicleDialog({@required this.selectedVehicle});

  @override
  SelectVehicleDialogState createState() => SelectVehicleDialogState();
}

class SelectVehicleDialogState extends State<SelectVehicleDialog> {
  @override
  void initState() {
    super.initState();

    _getVehicles();
    _selectedVehicle = widget.selectedVehicle;
  }

  bool _isLoading = false;
  Vehicle _selectedVehicle;
  final _vehicles = List<Vehicle>();

  void _getVehicles() async {
    _updateLoadingState(true);

    final updatedVehicles = await vehicleClient.getVehicles();

    setState(() {
      _vehicles.clear();
      _vehicles.addAll(updatedVehicles);
    });

    _updateLoadingState(false);
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  void _onVehicleSelected(Vehicle vehicle) {
    Navigator.of(context).pop(vehicle);
  }

  Future _addVehicle() async {
    // TODO create modal to add vehicle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your vehicle"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addVehicle,
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !_isLoading && _vehicles.isEmpty ? 1.0 : 0.0,
            child: Text(
              "No vehicles! Please add one.",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity: !_isLoading && _vehicles.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = _vehicles[index];
                bool isSelected = _selectedVehicle != null
                    ? _selectedVehicle.token == vehicle.token
                    : false;

                return ListTile(
                  title: Text(vehicle.number),
                  subtitle: Text(vehicle.comment),
                  trailing:
                      isSelected ? Icon(Icons.check) : Icon(Icons.arrow_right),
                  selected: isSelected,
                  onTap: () {
                    _onVehicleSelected(vehicle);
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
