import 'package:flutter/material.dart';
import 'package:school_portal_app/models/professor_model.dart';
import 'package:school_portal_app/repository/professor_repository.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ProfessorRepository professorRepository = ProfessorRepository();
  ProfessorModel professorModel = ProfessorModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Montserrat',
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('FIAPP',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w500,
              )),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 100,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Portal do Professor",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: new InputDecoration(
                          icon: const Icon(Icons.person_pin),
                          fillColor: Colors.white,
                          hintText: 'Digite o seu RM',
                          labelText: "RM"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite o RM para logar';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        professorModel.rm = value;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.lock),
                        fillColor: Colors.white,
                        hintText: 'Digite sua senha',
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite a senha para logar';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        professorModel.senha = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        child: Text("Entrar",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.pink,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();

                            var resultLogin = professorRepository.login(
                                professorModel.rm, professorModel.senha);

                            resultLogin.then((professor) {
                              if (professor == null) {
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/menu',
                                  arguments: professor,
                                );
                              }
                            });
                          } else {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Não foi possível faze o login.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    RaisedButton(
                        child: Text("Cadastrar",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.pink,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/cadastro-professor',
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
