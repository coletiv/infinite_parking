import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:flutter/material.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
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

  bool _isLoadingFares = false;

  void _getFares() async {
    if (_selectedVehicle == null || _selectedZone == null) {
      return;
    }

    setState(() {
      _isLoadingFares = true;
    });

    _fare = await municipalClient.getFare(_selectedVehicle, _selectedZone);

    setState(() {
      _isLoadingFares = false;
    });
  }

  void _addSession() async {
    bool isParkingSessionSaved = await sessionManager.saveParkingSession(_fare);

    if (!isParkingSessionSaved) {
      _showError("Some problem happened while creating your parking session");
      return;
    }

    Session parkingSession = await sessionClient.addSession(_selectedVehicle, _selectedZone);

    if (parkingSession == null) {
      _showError("Some problem happened while creating your parking session");
    } else {
      await sessionManager.updateSelectedFares();
      Navigator.pop(context);
    }
  }

  void _validateInput() {
    if (_selectedVehicle == null) {
      _showError("Please choose your Vehicle first!");
    } else if (_selectedMunicipal == null) {
      _showError("Please select a Municipal first!");
    } else if (_selectedZone == null) {
      _showError("Please select a Zone first!");
    } else if (_fare == null || _fare.selectedTime == null) {
      _showError("Please select a Time first!");
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
    _getFares();
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
    _getFares();
  }

  void _selectTime() {
    if (_selectedVehicle == null) {
      _showError("Please choose your Vehicle first!");
    } else if (_selectedZone == null) {
      _showError("Please select a Zone first!");
    } else {
      _showTimeSelectionDialog();
    }
  }

  Future _showTimeSelectionDialog() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      _onTimeSelected(time);
    }
  }

  void _onTimeSelected(TimeOfDay time) {
    DateTime currentDate = DateTime.now();
    DateTime selectedTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      time.hour,
      time.minute,
    );

    if (!_isSelectedTimeValid(selectedTime)) {
      return;
    }

    setState(() {
      _fare.selectedTime = selectedTime;
    });
  }

  bool _isSelectedTimeValid(DateTime selectedTime) {
    DateTime currentDate = DateTime.now();

    // After 19:00 it's not possible to schedule a session
    if (selectedTime.hour > 19) {
      _showError("Please select a time before 19:00");
      return false;
    }

    // A session cannot be scheduled to the past
    if (selectedTime.hour < currentDate.hour) {
      _showError("Please select a time after the current time");
      return false;
    }

    // A session cannot be scheduled to the past
    if (selectedTime.hour == currentDate.hour &&
        selectedTime.minute < currentDate.minute) {
      _showError("Please select a time after the current time");
      return false;
    }

    int minimumDuration = _fare.getMinimumDuration().inMinutes;
    int selectedDuration = selectedTime.difference(currentDate).inMinutes;

    // A schedule as a minimum duration
    if (selectedDuration < minimumDuration) {
      _showError("${minimumDuration}m is the minimum duration for this zone");
      return false;
    }

    return true;
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
              Builder(
                builder: (BuildContext context) {
                  if (_isLoadingFares) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  } else {
                    return ListTile(
                      title: Text("Time"),
                      trailing: Icon(Icons.arrow_right),
                      subtitle: Text(_fare != null && _fare.selectedTime != null
                          ? "${_fare.getFormattedSessionCost()} - ${_fare.getFormattedSessionExpirationTime()}"
                          : "Select time"),
                      onTap: _selectTime,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
