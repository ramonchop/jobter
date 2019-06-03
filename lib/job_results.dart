import 'package:flutter/material.dart';
import 'package:hack19/repository_search.dart';
import 'package:provider/provider.dart';

import 'job_model.dart';

class JobResults extends StatelessWidget {


  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('Results'),
       actions: <Widget>[
         IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
              final repo = Provider.of<SearchRepository>(context);
            repo.toStart();
          },
         )
       ],),
       body: Results(),
       drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: SizedBox(height: 1,),
              // child: CircleAvatar(
                
              //   backgroundImage: AssetImage('assets/broca.jpeg'
                
              //   ),
              // ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Find'),
              leading: Icon(Icons.search),
            ),
            ListTile(
              title: Text('Your Applies'),
              leading: Icon(Icons.import_contacts),

              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

  }
}

class Results extends StatefulWidget {
  Results({Key key}) : super(key: key);

  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  Color colorIcon = Colors.blue;
  List<String> applys = List<String>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<SearchRepository>(context);

    return SafeArea(
      child: 
      ListView.separated(
        itemCount: repo.results.length,
        itemBuilder: (context, index) {
            return _buildRow(context, repo.results[index], repo);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      )
    );
  }

  ListTile _buildRow(BuildContext context, Job job, SearchRepository repo){
    return ListTile(
      key: Key(job.id),
      title: Text(job.title),
      subtitle: Text(job.description),
      trailing: Text(job.experience),
      leading: Icon(Icons.work,
        color: applys.contains(job.id) 
        ? Colors.green
        : Colors.blue ,
      ),
      onTap: (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context)=> AlertDialog(
            title: Text('Apply'),
            content: Text('Do you want to apply for this Job?'),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  //repo.apply(job.id);
                  setState(() {
                    applys.add(job.id);
                  });
                },
                child: Text('Apply'),
              ),
              FlatButton(
                onPressed: (){
                  print('Close');
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),           
            ],
          )
        );
      //);
      }
    );
    
  }
}
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
