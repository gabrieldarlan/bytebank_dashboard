import 'dart:async';

import 'package:bytebank_dashboard/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    },
    version: 1,
    // onDowngrade: onDatabaseDowngradeDelete,
    // esse comando serve pra limpar a base, primeiro muda a versao pra 2
    // dá um restart usado ctrl+shit+f5, depois entra na lista para atualizar mesmo a versão do banco de dados,
    // depois volta pra versão 1 pra lista ficar zerada de dados.
  );
}

