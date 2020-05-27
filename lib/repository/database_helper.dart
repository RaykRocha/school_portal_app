import 'package:school_portal_app/models/aluno_model.dart';
import 'package:school_portal_app/models/atividade_aluno.dart';
import 'package:school_portal_app/models/atividade_model.dart';
import 'package:school_portal_app/models/chamada_aluno.dart';
import 'package:school_portal_app/models/chamada_model.dart';
import 'package:school_portal_app/models/disciplina_model.dart';
import 'package:school_portal_app/models/disciplina_turma.dart';
import 'package:school_portal_app/models/professor_model.dart';
import 'package:school_portal_app/models/turma_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Instancia do SQFLite Database
  static Database _database;

  // Instancia da classe Helper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Fábrica de construtor
  factory DatabaseHelper() {
    return _instance;
  }

  // Construtor nomeado
  DatabaseHelper._internal();

  // Abre conexão com o banco
  Future<Database> get connection async {
    if (_database == null) {
      _database = await _createDatabase();
    }
    return _database;
  }

  Future<Database> _createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'portal_app.db');

    var database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createTables,
    );

    return database;
  }

  void _createTables(Database database, int version) async {
    // Criando a tabela de Cursos

    await database.execute('''
      CREATE TABLE TurmaModel(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          ano TEXT NOT NULL,
          horario TEXT,
          inicio TEXT,
          termino TEXT
        );
      
      ''');

    await database.execute(
      '''
       CREATE TABLE  ProfessorModel(
        rm TEXT PRIMARY KEY,
        nome TEXT,
        senha TEXT NOT NULL
      );
      ''',
    );
    await database.execute(
      ''' 
      CREATE TABLE AlunoModel(
        rm TEXT PRIMARY KEY ,
        nome TEXT,
        foto TEXT,
        idTurma INTEGER,
        FOREIGN KEY(idTurma) REFERENCES turmaModel(id)
      );
      ''',
    );
    await database.execute(
      '''
      CREATE TABLE DisciplinaModel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        rmProfessor TEXT,
        FOREIGN KEY(rmProfessor) REFERENCES ProfessorModel(rm)
      );
      ''',
    );
    await database.execute(
      '''
      CREATE TABLE DisciplinaTurma(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idDisciplina INTEGER,
        idTurma INTEGER,
        FOREIGN KEY(idDisciplina) REFERENCES DisciplinaModel(id),
        FOREIGN KEY(idTurma) REFERENCES DisciplinaModel(id)
      );
      ''',
    );
    await database.execute(
      '''
     CREATE TABLE AtividadeModel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nota TEXT,
        tipo TEXT,
        dataEntrega TEXT,
        idDisciplina INTEGER,
        FOREIGN KEY(idDisciplina) REFERENCES DisciplinaModel(id)
      );
      ''',
    );
    await database.execute(
      '''
      CREATE TABLE AtividadeAluno(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rmAluno TEXT,
        idAtividade INTEGER,
        FOREIGN KEY(rmAluno) REFERENCES AlunoModel(rm),
        FOREIGN KEY(idAtividade) REFERENCES AtividadeModel(id)
      );
            ''',
    );
    await database.execute(
      '''
      CREATE TABLE ChamadaModel(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        data TEXT,
        idDisciplinaTurma INTEGER,
        FOREIGN KEY(idDisciplinaTurma) REFERENCES DisciplinaTurma(id)
      );
     
      ''',
    );
    await database.execute(
      '''
      CREATE TABLE ChamadaAluno(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        presente INTEGER DEFAULT 0,
        rmAluno TEXT,
        FOREIGN KEY(rmAluno) REFERENCES AlunoModel(rm),
      );
     
      ''',
    );

    await database.insert("ProfessorModel",
        new ProfessorModel(rm: "123", nome: "Flavio", senha: "123").toMap());
    await database.insert("ProfessorModel",
        new ProfessorModel(rm: "1234", nome: "Pedro", senha: "123").toMap());


    await database.insert("TurmaModel",
        new TurmaModel(id: 1, nome: 'Flutter',ano: '3SIA', horario: 'manha', inicio: '0800',termino: '0945').toMap());
    await database.insert("TurmaModel",
        new TurmaModel(id: 2,nome: 'Flutter',ano: '3SIB',horario: 'manha',inicio: '1000',termino: '1145').toMap());


    await database.insert("AlunoModel",
        new AlunoModel(rm: "85132", nome: "Jean", foto: "foto.png",idTurma: 11).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "80101", nome: "vini", foto: "foto.png",idTurma: 11).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "85183", nome: "petillo", foto: "foto.png",idTurma: 11).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "49845", nome: "vitor", foto: "foto.png",idTurma: 11).toMap());

    await database.insert("DisciplinaTurma",
        new DisciplinaTurma(id: 1, idTurma: 11, idDisciplina: 1,).toMap());

    await database.insert("DisciplinaModel",
        new DisciplinaModel(id: 1, nome: "Flavio", rmProfessor: "123",).toMap());

    await database.insert("AtividadeModel",
        new AtividadeModel(id: 1, nota: "10", tipo: "1",dataEntrega: "12/12/2020",idDisciplina: 1).toMap());

    await database.insert("AtividadeAluno",
        new AtividadeAluno(id: 1, rmAluno:  "10", idAtividade: 1).toMap());


    await database.insert("ChamadaModel",
        new ChamadaModel(id: 49845,  data:"19/3/2020", idDisciplinaTurma:1 ).toMap());

    await database.insert("ChamadaModel",
        new ChamadaModel(id: 49846,  data:"15/4/2020", idDisciplinaTurma:1 ).toMap());

    await database.insert("ChamadaModel",
        new ChamadaModel(id: 49847,  data:"12/12/2020", idDisciplinaTurma:1 ).toMap());

    await database.insert("ChamadaModel",
        new ChamadaModel(id: 49848,  data:"12/12/2020", idDisciplinaTurma:1 ).toMap());


    await database.insert("ChamadaAluno",
        new ChamadaAluno(id: 49849, presente: 0, rmAluno:"85132" ).toMap());

    await database.insert("ChamadaAluno",
        new ChamadaAluno(id: 49850, presente: 1, rmAluno:"80101" ).toMap());

    await database.insert("ChamadaAluno",
        new ChamadaAluno(id: 49851, presente: 0, rmAluno:"85183" ).toMap());

    await database.insert("ChamadaAluno",
        new ChamadaAluno(id: 49852, presente: 1, rmAluno:"49845" ).toMap());


  }
}
