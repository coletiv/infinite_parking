import 'dart:async';

import 'package:flutter/material.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_fare_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_municipal_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_vehicle_dialog.dart';
import 'package:coletiv_infinite_parking/widget/dialog/select_zone_dialog.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => AddSessionPageState();
}

class AddSessionPageState extends State<AddSessionPage> {
  BuildContext _context;

  Vehicle _selectedVehicle;
  Municipal _selectedMunicipal;
  MunicipalZone _selectedZone;
  Fare _fare;

  void _addSession() async {
    await sessionClient.addSession(_selectedVehicle, _selectedZone, _fare);
  }

  void _validateInput() {
    if (_selectedVehicle == null) {
      _showError("Please choose your Vehicle first!");
    } else if (_selectedMunicipal == null) {
      _showError("Please select a Municipal first!");
    } else if (_selectedZone == null) {
      _showError("Please select a Zone first!");
    } else if (_fare == null || _fare.simpleFareIndex == null) {
      _showError("Please select a Fare first!");
    } else {
      _addSession();
    }
  }

  void _showError(String errorMessage) {
    Scaffold.of(_context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(errorMessage),
      ),
    );
  }

  Future _selectVehicle() async {
    Vehicle vehicle = await Navigator.push(
      context,
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
        _fare = null;
      }
      _selectedVehicle = vehicle;
    });
  }

  Future _selectMunicipal() async {
    Municipal municipal = await Navigator.push(
      context,
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
        _fare = null;
      }
      _selectedMunicipal = municipal;
    });
  }

  void _selectZone() {
    if (_selectedMunicipal == null) {
      _showError("Please select a Municipal first!");
    } else {
      _showZoneSelectionDialog();
    }
  }

  Future _showZoneSelectionDialog() async {
    MunicipalZone zone = await Navigator.push(
      context,
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
        _fare = null;
      }
      _selectedZone = zone;
    });
  }

  void _selectFare() {
    if (_selectedVehicle == null) {
      _showError("Please choose your Vehicle first!");
    } else if (_selectedZone == null) {
      _showError("Please select a Zone first!");
    } else {
      _showFareSelectionDialog();
    }
  }

  Future _showFareSelectionDialog() async {
    Fare fare = await Navigator.push(
      context,
      MaterialPageRoute<Fare>(
        builder: (BuildContext context) {
          return SelectFareDialog(
            selectedVehicle: _selectedVehicle,
            selectedZone: _selectedZone,
            selectedFare: _fare,
          );
        },
        fullscreenDialog: true,
      ),
    );

    if (fare != null) {
      _onFareSelected(fare);
    }
  }

  void _onFareSelected(Fare fare) {
    setState(() {
      _fare = fare;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Session'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: _validateInput,
          )
        ],
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
                    : "Select vehicle"),
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
                subtitle: Text(_fare != null && _fare.simpleFareIndex != null
                    ? "${_fare.getSelectedSimpleFare().cost}€ - Duration: ${_fare.getSelectedSimpleFare().getChargedDuration().inMinutes}"
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
