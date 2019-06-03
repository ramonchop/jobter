import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

import 'job_model.dart';
import 'dart:convert';

enum Status{ Started, Searching, Results, EmptyResult, Problems }

class SearchRepository extends ChangeNotifier{

  Status _status = Status.Started;
  List<Job> _results = List<Job>();
  List<int> _applys = List<int>();
  
  AuthGoogle authGoogle;

  get status => _status;

  List<Job> get results => _results;
  List<int> get applys => _applys;



  Future<bool> search(String job) async {
    _status = Status.Searching;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    try{
      authGoogle = await AuthGoogle(fileJson: 'assets/chat.json',).build();

      Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle,language: Language.SPANISH_LATIN_AMERICA,);
      AIResponse response = await dialogflow.detectIntent(job+'-mobile');
      final resultMessage = response.getListMessage();
      if (resultMessage.isEmpty){
        _status = Status.EmptyResult;
        notifyListeners();
        return false;
      }
      final json = jsonDecode(resultMessage[0]['text']['text'][0]);
      final List result = json['list'];
      _results = List<Job>();
      _applys = List<int>();
      resultHelper(result);

      _status = Status.Results;
      notifyListeners();
      return true;
    }catch(e){
        _status = Status.Results;
        dummyResult();
        notifyListeners();
        return false;
    }
  }

  void apply(int){
    _applys.add(int);
    notifyListeners();
  }

  void toStart(){
    _results = List<Job>();
    _applys = List<int>();
    _status = Status.EmptyResult;
    notifyListeners();
  }

  @override
  void dispose() { 
    super.dispose();
  }

  void dummyResult(){
    Job job1 = Job(id:'1', description: 'Java 1', title: 'Ing en Java', experience: '2+ Años');
    _results.add(job1);
  }

  void resultHelper(List datas){
    for (var data in datas){
      var title = data['Titulo'];
      var description = data['Descripcion'];
      var experience = data['Experiencia'];
      var id = data['id'].toString() ?? "1";

      _results.add(Job(description: description, title: title, experience: experience, id: id));
    }

  }
}