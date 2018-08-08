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
          return Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Plate:"),
                    DropdownButton(
                        value: selectedVehicle?.number,
                        items: vehicles.map((vehicle) {
                          return DropdownMenuItem<String>(
                            value: vehicle.number,
                            child: SizedBox(
                              width: 200.0,
                              child: Text(vehicle.number),
                            ),
                          );
                        }).toList(),
                        onChanged: onVehicleSelected),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Municipal:"),
                    DropdownButton(
                        value: selectedMunicipal?.name,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Zone:"),
                    DropdownButton(
                        value: selectedZone?.name,
                        items: municipalZones.map((zone) {
                          return DropdownMenuItem<String>(
                            value: zone.name,
                            child: Text(zone.name),
                          );
                        }).toList(),
                        onChanged: onZoneSelected),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
