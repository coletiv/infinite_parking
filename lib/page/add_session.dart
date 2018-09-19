import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/widgets/SelectFareDialog.dart';
import 'package:coletiv_infinite_parking/widgets/SelectMunicipalDialog.dart';
import 'package:coletiv_infinite_parking/widgets/SelectVehicleDialog.dart';
import 'package:coletiv_infinite_parking/widgets/SelectZoneDialog.dart';
import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  BuildContext buildContext;

  Vehicle selectedVehicle;
  Municipal selectedMunicipal;
  MunicipalZone selectedZone;
  FareCost selectedFare;

  void addSession() {
    // TODO add session
  }

  void selectVehicle() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SelectVehicleDialog(onVehicleSelected: (Vehicle vehicle) {
              setState(() {
                selectedVehicle = vehicle;
              });
            }));
  }

  void selectMunicipal() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SelectMunicipalDialog(onMunicipalSelected: (Municipal municipal) {
              setState(() {
                selectedMunicipal = municipal;
              });
            }));
  }

  void selectZone() {
    if (selectedMunicipal == null) {
      // TODO show alert saying that he must choose the municipal first
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              SelectZoneDialog(
                  selectedMunicipal: selectedMunicipal,
                  onZoneSelected: (MunicipalZone zone) {
                    setState(() {
                      selectedZone = zone;
                    });
                  }));
    }
  }

  void selectFare() {
    if (selectedVehicle == null) {
      // TODO show alert saying that he must choose the vehicle first
      return;
    } else if (selectedZone == null) {
      // TODO show alert saying that he must choose the zone first
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              SelectFareDialog(
                  selectedVehicle: selectedVehicle,
                  selectedZone: selectedZone,
                  onFareSelected: (FareCost fare) {
                    setState(() {
                      selectedFare = fare;
                    });
                  }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Session'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          buildContext = context;
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text("Vehicle"),
                subtitle: Text(selectedVehicle != null
                    ? selectedVehicle.number
                    : "Select a vehicle"),
                onTap: selectVehicle,
              ),
              ListTile(
                title: Text("Municipal"),
                subtitle: Text(selectedMunicipal != null
                    ? selectedMunicipal.name
                    : "Select municipal"),
                onTap: selectMunicipal,
              ),
              ListTile(
                title: Text("Zone"),
                subtitle: Text(
                    selectedZone != null ? selectedZone.name : "Select zone"),
                onTap: selectZone,
              ),
              ListTile(
                title: Text("Fare"),
                subtitle: Text(selectedFare != null
                    ? "${selectedFare.cost}€ - Duration: ${selectedFare
                    .getChargedDuration()
                    .inMinutes}"
                    : "Select fare"),
                onTap: selectFare,
              ),
            ],
          );
        },
      ),
    );
  }
}
