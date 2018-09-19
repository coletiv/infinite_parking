import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectMunicipalDialog extends StatefulWidget {
  final Function(Municipal selectedMunicipal) onMunicipalSelected;

  const SelectMunicipalDialog({this.onMunicipalSelected});

  @override
  State createState() =>
      _SelectMunicipalDialogState(onMunicipalSelected: onMunicipalSelected);
}

class _SelectMunicipalDialogState extends State<SelectMunicipalDialog> {
  final Function(Municipal selectedMunicipal) onMunicipalSelected;

  _SelectMunicipalDialogState({this.onMunicipalSelected});

  bool isLoading = false;
  Municipal selectedMunicipal;
  final municipals = List<Municipal>();

  void getMunicipals() async {
    updateLoadingState(true);

    final updatedMunicipals = await municipalClient.getMunicipals();

    setState(() {
      municipals.clear();
      municipals.addAll(updatedMunicipals);
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

    getMunicipals();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose the municipal:"),
      contentPadding: EdgeInsets.all(16.0),
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !isLoading && municipals.isEmpty ? 1.0 : 0.0,
            child: Text("No municipals!"),
          ),
          Opacity(
            opacity: !isLoading && municipals.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: municipals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(municipals[index].name),
                  onTap: () {
                    setState(() {
                      selectedMunicipal = municipals[index];
                    });

                    onMunicipalSelected(selectedMunicipal);
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
