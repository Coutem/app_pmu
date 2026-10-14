import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/usuario.dart';
import '../model/consulta.dart';
import '../model/documento.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final caminhoBanco = await getDatabasesPath();

    final caminho = join(
      caminhoBanco,
      'prontuario_medico_unico.db',
    );

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {

        // TABELA DE USUÁRIOS
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha_hash TEXT NOT NULL
          )
        ''');

        // TABELA DE CONSULTAS
        await db.execute('''
          CREATE TABLE consultas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            hospital TEXT NOT NULL,
            medico TEXT NOT NULL,
            especialidade TEXT NOT NULL,
            endereco TEXT NOT NULL,
            data TEXT NOT NULL,
            horario TEXT NOT NULL,
            observacao TEXT,
            
            FOREIGN KEY (usuario_id) 
            REFERENCES usuarios (id)
            ON DELETE CASCADE
          )
        ''');

        // TABELA DE DOCUMENTOS
        await db.execute('''
          CREATE TABLE documentos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            consulta_id INTEGER NOT NULL,
            nome_arquivo TEXT NOT NULL,
            caminho_arquivo TEXT NOT NULL,
            tipo_arquivo TEXT,
            tamanho INTEGER,

            FOREIGN KEY (consulta_id)
            REFERENCES consultas (id)
            ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // ==========================================================
  // USUÁRIOS
  // ==========================================================

  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await database;

    return await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<bool> emailExiste(String email) async {
    final db = await database;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return resultado.isNotEmpty;
  }

  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    final db = await database;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Usuario.fromMap(resultado.first);
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await database;

    final resultado = await db.query('usuarios');

    return resultado.map((map) {
      return Usuario.fromMap(map);
    }).toList();
  }

  // ==========================================================
  // CONSULTAS
  // ==========================================================

  Future<int> inserirConsulta(Consulta consulta) async {
    final db = await database;

    return await db.insert(
      'consultas',
      consulta.toMap(),
    );
  }

  Future<List<Consulta>> listarConsultas(int usuarioId) async {
    final db = await database;

    final resultado = await db.query(
      'consultas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'data ASC, horario ASC',
    );

    return resultado.map((map) {
      return Consulta.fromMap(map);
    }).toList();
  }

  Future<Consulta?> buscarConsulta(int id) async {
    final db = await database;

    final resultado = await db.query(
      'consultas',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Consulta.fromMap(resultado.first);
  }

  Future<int> atualizarConsulta(Consulta consulta) async {
    final db = await database;

    return await db.update(
      'consultas',
      consulta.toMap(),
      where: 'id = ?',
      whereArgs: [consulta.id],
    );
  }

  Future<int> excluirConsulta(int id) async {
    final db = await database;

    return await db.delete(
      'consultas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================================
  // DOCUMENTOS
  // ==========================================================

  Future<int> inserirDocumento(Documento documento) async {
    final db = await database;

    return await db.insert(
      'documentos',
      documento.toMap(),
    );
  }

  Future<List<Documento>> listarDocumentos(int consultaId) async {
    final db = await database;

    final resultado = await db.query(
      'documentos',
      where: 'consulta_id = ?',
      whereArgs: [consultaId],
    );

    return resultado.map((map) {
      return Documento.fromMap(map);
    }).toList();
  }

  Future<int> excluirDocumento(int id) async {
    final db = await database;

    return await db.delete(
      'documentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}