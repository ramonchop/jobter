import 'package:flutter/material.dart';
import 'package:hack19/job_results.dart';
import 'package:hack19/repository_search.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<SearchRepository>(
        builder: (_)=> SearchRepository(),
        child: Consumer(
          builder: (context, SearchRepository repo, _){
            switch (repo.status) {
              case Status.Results:
                return JobResults();
              default:
                  return MyHomePage(title: 'Find your new Job');
            }
          },
        ),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _job;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _job = TextEditingController();
  }

  @override
  void dispose() { 
    _job.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<SearchRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        child: Center(child: 
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Image.asset('assets/jobs.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: style,
                  decoration: InputDecoration(
                    prefix: Icon(Icons.work),
                    labelText: 'Job',
                    border: OutlineInputBorder()
                  ),
                  controller: _job,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(16),
                child: repo.status == Status.Searching
                ? Center(child:CircularProgressIndicator())
                : Material(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    onPressed: () async {
                       if (! await repo.search(_job.text)){
                         _key.currentState.showSnackBar(
                           SnackBar(
                           content: Text('No Results')
                         ));
                       }
                    },
                    child: Text('Search',
                      style: style.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      )
    );
  }
}
