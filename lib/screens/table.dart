import 'package:flutter/material.dart';

class TableShow extends StatelessWidget {
  const TableShow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Table Example'),
        ),
        body: Center(
          child: DataTable(
            border: TableBorder.all(
              width: 2,
              color: Colors.black,
            ),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Age')),
              DataColumn(label: Text('Occupation')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('John')),
                DataCell(Text('30')),
                DataCell(Text('Engineer')),
              ]),
              DataRow(cells: [
                DataCell(Text('Alice')),
                DataCell(Text('25')),
                DataCell(Text('Doctor')),
              ]),
              DataRow(cells: [
                DataCell(Text('Bob')),
                DataCell(Text('35')),
                DataCell(Text('Teacher')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
