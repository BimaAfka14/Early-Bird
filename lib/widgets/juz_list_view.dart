import 'package:flutter/material.dart';
import '../screens/juz_page.dart';

class JuzListView extends StatelessWidget {
  const JuzListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          int juzNumber = index + 1;
          return Card(
            child: ListTile(
              title: Text("Juz $juzNumber"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuzPage(juzNumber: juzNumber),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
