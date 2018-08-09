import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  BuildContext buildContext;

  Municipal selectedMunicipal;
  final municipals = List<Municipal>();

  Vehicle selectedVehicle;
  final vehicles = List<Vehicle>();

  MunicipalZone selectedZone;
  final municipalZones = List<MunicipalZone>();

  FareCost selectedFare;
  final fares = List<FareCost>();

  void addSession() {
    // TODO add session
  }

  void getVehicles() async {
    final vehicles = await vehicleClient.getVehicles();

    setState(() {
      this.vehicles.addAll(vehicles);
    });
  }

  void getMunicipals() async {
    final municipals = await municipalClient.getMunicipals();

    setState(() {
      this.municipals.addAll(municipals);
    });
  }

  void getMunicipalZones() async {
    final municipalZones =
    await municipalClient.getMunicipalZones(selectedMunicipal.token);

    setState(() {
      this.municipalZones.addAll(municipalZones);
    });
  }

  void getFare() async {
    final fare = await municipalClient.getFare(selectedZone, selectedVehicle);

    setState(() {
      this.fares.addAll(fare.values);
    });
  }

  void onVehicleSelected(String value) {
    setState(() {
      selectedVehicle = vehicles
          .firstWhere((vehicle) => vehicle.number == value, orElse: () => null);
    });
  }

  void onMunicipalSelected(String value) {
    setState(() {
      selectedMunicipal = municipals.firstWhere(
              (municipal) => municipal.name == value,
          orElse: () => null);

      this.selectedZone = null;
      this.municipalZones.clear();
    });

    getMunicipalZones();
  }

  void onZoneSelected(String value) {
    setState(() {
      selectedZone = municipalZones.firstWhere((zone) => zone.name == value,
          orElse: () => null);
    });
  }

  void onFareSelected() {}

  @override
  void initState() {
    super.initState();

    getVehicles();
    getMunicipals();
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
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Plate:"),
                  DropdownButton(
                      value: selectedVehicle != null
                          ? selectedVehicle.number
                          : null,
                      items: vehicles.map((vehicle) {
                        return DropdownMenuItem<String>(
                          value: vehicle.number,
                          child: Text(vehicle.number),
                        );
                      }).toList(),
                      onChanged: onVehicleSelected),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Municipal:"),
                  DropdownButton(
                      value: selectedMunicipal != null
                          ? selectedMunicipal.name
                          : null,
                      items: municipals.map((municipal) {
                        return DropdownMenuItem<String>(
                          value: municipal.name,
                          child: Text(municipal.name),
                        );
                      }).toList(),
                      onChanged: onMunicipalSelected),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Zone:"),
                  DropdownButton(
                      value: selectedZone != null ? selectedZone.name : null,
                      items: municipalZones.map((zone) {
                        return DropdownMenuItem<String>(
                          value: zone.name,
                          child: SizedBox(
                            width: 200.0,
                            child: Text(zone.name),
                          ),
                        );
                      }).toList(),
                      onChanged: onZoneSelected),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Fare:"),
                  DropdownButton(
                      value: selectedFare != null
                          ? selectedFare.cost.toString()
                          : null,
                      items: fares.map((fare) {
                        return DropdownMenuItem<String>(
                          value: fare.cost.toString(),
                          child: Text(fare.cost.toString()),
                        );
                      }).toList(),
                      onChanged: onZoneSelected),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
