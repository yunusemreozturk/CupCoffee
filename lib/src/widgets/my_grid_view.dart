import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final int columnLength;
  final List<Widget> children;

  const MyGridView({
    Key? key,
    required this.columnLength,
    required this.children,
  }) : super(key: key);

  List<Row> generateGridView({
    required List<Widget> items,
    required int columnLength,
  }) {
    int rowLength = (items.length / columnLength).ceil();
    List<Row> rowList = [];
    int count = 0;

    for (int i = 0; i < rowLength; i++) {
      List<Widget> tempItemList = [];

      int columnIndex = ((i == (columnLength))
          ? (items.length == rowLength * columnLength)
              ? columnLength
              : (items.length % columnLength).toInt()
          : columnLength);

      for (int l = 0; l < columnIndex; l++) {
        if ((items.length == 1 && l == 1) ||
            ((items.length % 2 == 1) && items.length == count)) {
          tempItemList.add(const SizedBox());
        } else {
          tempItemList.add(items[count]);
        }

        count++;
      }

      rowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tempItemList,
        ),
      );
    }

    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: generateGridView(
        columnLength: columnLength,
        items: children,
      ),
    );
  }
}
