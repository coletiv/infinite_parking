import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_fare_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_municipal_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_vehicle_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_zone_dialog.dart';
import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => AddSessionPageState();
}

class AddSessionPageState extends State<AddSessionPage> {
  BuildContext _context;

  Vehicle _selectedVehicle;
  Municipal _selectedMunicipal;
  MunicipalZone _selectedZone;
  FareCost _selectedFare;

  void _addSession() {
    // TODO add session
  }

  Future _selectVehicle() async {
    Vehicle vehicle = await Navigator.of(context).push(
      MaterialPageRoute<Vehicle>(
        builder: (BuildContext context) {
          return SelectVehicleDialog(selectedVehicle: _selectedVehicle);
        },
        fullscreenDialog: true,
      ),
    );

    if (vehicle != null) {
      _onVehicleSelected(vehicle);
    }
  }

  void _onVehicleSelected(Vehicle vehicle) {
    setState(() {
      if (_selectedVehicle != null && _selectedVehicle.token != vehicle.token) {
        _selectedFare = null;
      }
      _selectedVehicle = vehicle;
    });
  }

  Future _selectMunicipal() async {
    Municipal municipal = await Navigator.of(context).push(
      MaterialPageRoute<Municipal>(
        builder: (BuildContext context) {
          return SelectMunicipalDialog(selectedMunicipal: _selectedMunicipal);
        },
        fullscreenDialog: true,
      ),
    );

    if (municipal != null) {
      _onMunicipalSelected(municipal);
    }
  }

  void _onMunicipalSelected(Municipal municipal) {
    setState(() {
      if (_selectedMunicipal != null &&
          _selectedMunicipal.token != municipal.token) {
        _selectedZone = null;
        _selectedFare = null;
      }
      _selectedMunicipal = municipal;
    });
  }

  void _selectZone() {
    if (_selectedMunicipal == null) {
      // TODO show alert saying that he must choose the municipal first
      return;
    } else {
      _showZoneSelectionDialog();
    }
  }

  Future _showZoneSelectionDialog() async {
    MunicipalZone zone = await Navigator.of(context).push(
      MaterialPageRoute<MunicipalZone>(
        builder: (BuildContext context) {
          return SelectZoneDialog(
            selectedMunicipal: _selectedMunicipal,
            selectedZone: _selectedZone,
          );
        },
        fullscreenDialog: true,
      ),
    );

    if (zone != null) {
      _onZoneSelected(zone);
    }
  }

  void _onZoneSelected(MunicipalZone zone) {
    setState(() {
      if (_selectedZone != null && _selectedZone.token != zone.token) {
        _selectedFare = null;
      }
      _selectedZone = zone;
    });
  }

  void _selectFare() {
    if (_selectedVehicle == null) {
      // TODO show alert saying that he must choose the vehicle first
      return;
    } else if (_selectedZone == null) {
      // TODO show alert saying that he must choose the zone first
      return;
    } else {
      _showFareSelectionDialog();
    }
  }

  Future _showFareSelectionDialog() async {
    FareCost fare = await Navigator.of(context).push(
      MaterialPageRoute<FareCost>(
        builder: (BuildContext context) {
          return SelectFareDialog(
            selectedVehicle: _selectedVehicle,
            selectedZone: _selectedZone,
            selectedFare: _selectedFare,
          );
        },
        fullscreenDialog: true,
      ),
    );

    if (fare != null) {
      _onFareSelected(fare);
    }
  }

  void _onFareSelected(FareCost fare) {
    setState(() {
      _selectedFare = fare;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Session'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _context = context;
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text("Vehicle"),
                trailing: Icon(Icons.arrow_right),
                subtitle: Text(_selectedVehicle != null
                    ? _selectedVehicle.number
                    : "Select a vehicle"),
                onTap: _selectVehicle,
              ),
              ListTile(
                title: Text("Municipal"),
                trailing: Icon(Icons.arrow_right),
                subtitle: Text(_selectedMunicipal != null
                    ? _selectedMunicipal.name
                    : "Select municipal"),
                onTap: _selectMunicipal,
              ),
              ListTile(
                title: Text("Zone"),
                trailing: Icon(Icons.arrow_right),
                subtitle: Text(
                    _selectedZone != null ? _selectedZone.name : "Select zone"),
                onTap: _selectZone,
              ),
              ListTile(
                title: Text("Fare"),
                trailing: Icon(Icons.arrow_right),
                subtitle: Text(_selectedFare != null
                    ? "${_selectedFare.cost}€ - Duration: ${_selectedFare
                    .getChargedDuration()
                    .inMinutes}"
                    : "Select fare"),
                onTap: _selectFare,
              ),
            ],
          );
        },
      ),
    );
  }
}
