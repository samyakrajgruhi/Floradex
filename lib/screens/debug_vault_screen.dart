import 'dart:io';

import 'package:floradex/models/plant_record.dart';
import 'package:floradex/services/database_service.dart';
import 'package:flutter/material.dart';

class DebugVaultScreen extends StatefulWidget {
  const DebugVaultScreen({super.key});

  @override
  State<DebugVaultScreen> createState() => _debugVaultScreenState();
}

class _debugVaultScreenState extends State<DebugVaultScreen> {
  final dbService = DatabaseService();

  List<PlantRecord> PlantRecords = [];
  @override
  void initState() {
    PlantRecords = dbService.fetchPlants();
    super.initState();
  }

  List<DataColumn> columns = [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('COMMON_NAME')),
  ];

  @override
  Widget build(BuildContext context) {
    if (PlantRecords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('DEBUG VAULT')),
        body: const Center(child: Text('The Vault is completely empty!')),
      );
    }
    
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: columns,
            rows: PlantRecords.map(
              (plantRecord) => DataRow(
                cells: [
                  DataCell(Text(plantRecord.id)),
                  DataCell(Text(plantRecord.plantName)),
                ],
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
